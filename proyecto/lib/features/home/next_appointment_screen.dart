import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:proyecto/theme/app_colors.dart";
import "package:proyecto/shared/widgets/custom_card.dart";
import "package:proyecto/services/citas_service.dart";
import "package:firebase_auth/firebase_auth.dart";

class NextAppointmentScreen extends StatelessWidget {
  final String citaId;

  const NextAppointmentScreen({super.key, required this.citaId});

  String _formatDate(DateTime d) {
    const months = [
      "Ene", "Feb", "Mar", "Abr", "May", "Jun",
      "Jul", "Ago", "Sep", "Oct", "Nov", "Dic"
    ];
    return "${d.day} ${months[d.month - 1]} ${d.year} • ${d.hour.toString().padLeft(2, "0")}:${d.minute.toString().padLeft(2, "0")}";
  }

  Future<void> _cancelarCita(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cancelar cita"),
        content: const Text("¿Estás seguro de cancelar esta cita?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text("No")),
          TextButton(onPressed: () => Navigator.pop(ctx, true), child: const Text("Sí")),
        ],
      ),
    );

    if (confirm != true) return;

    await FirebaseFirestore.instance
        .collection("citas")
        .doc(citaId)
        .update({"estado": "cancelada"});

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cita cancelada")),
      );
      Navigator.pop(context);
    }
  }

  Future<void> _reprogramarCita(BuildContext context, Map<String, dynamic> data) async {
    final Timestamp? ts = data["fecha"];
    final fechaActual = ts?.toDate();

    final servicio = data["tipo"];
    final doctorRef = data["doctor"] as DocumentReference?;
    final paseadorRef = data["paseador"] as DocumentReference?;
    final veterinariaRef = data["veterinaria"] as DocumentReference?;
    final user = FirebaseAuth.instance.currentUser;
    final userRef = FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user?.uid);

    final DateTime? dia = await showDatePicker(
      context: context,
      initialDate: fechaActual ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dia == null) return;
    if (!context.mounted) return;

    final ocupados = await CitasService().obtenerHorariosOcupados(
      tipo: servicio,
      dia: dia,
      doctor: doctorRef,
      paseador: paseadorRef,
      veterinaria: veterinariaRef,
      usuarioRef: userRef,
    );

    final disponibles = CitasService().generarSlotsDisponibles(dia, ocupados);

    if (disponibles.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("No hay horarios disponibles este día.")),
        );
      }
      return;
    }

    if (!context.mounted) return;
    final seleccionado = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (_) => _HorariosSheet(slots: disponibles),
    );

    if (seleccionado == null) return;

    final disponible = await CitasService().verificarDisponibilidad(
      tipo: servicio,
      fecha: seleccionado,
      doctor: doctorRef,
      paseador: paseadorRef,
      veterinaria: veterinariaRef,
    );

    if (!disponible) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Ese horario se ocupó hace un momento.")),
        );
      }
      return;
    }

    await FirebaseFirestore.instance
        .collection("citas")
        .doc(citaId)
        .update({"fecha": seleccionado});

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cita reprogramada con éxito")),
      );
    }
  }

  Future<Map<String, String>> _cargarDetallesCompletos(
    Map<String, dynamic> citaData,
    DocumentReference? doctorRef,
    DocumentReference? vetRef,
    DocumentReference? paseadorRef,
  ) async {
    String nombres = "";
    String direccion = citaData["direccion"] ?? citaData["ubicacion_texto"] ?? "";

    if (doctorRef != null) {
      final doc = await doctorRef.get();
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        nombres += "Dr. ${data["nombre"] ?? ""}";
      }
    }

    if (vetRef != null) {
      final doc = await vetRef.get();
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        if (nombres.isNotEmpty) nombres += " – ";
        nombres += "${data["nombre"] ?? ""}";

        if (direccion.isEmpty) {
          direccion = data["direccion"] ?? data["ubicacion"] ?? "";
        }
      }
    }

    if (paseadorRef != null) {
      final doc = await paseadorRef.get();
      final data = doc.data() as Map<String, dynamic>?;
      if (data != null) {
        nombres += "Paseador: ${data["nombre"] ?? ""}";
      }
    }

    if (direccion.isEmpty) {
      direccion = "Ubicación pendiente";
    }

    return {
      "nombres": nombres,
      "direccion": direccion,
    };
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          "Detalles de la Cita",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: cs.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection("citas")
            .doc(citaId)
            .snapshots(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError || !snap.hasData || !snap.data!.exists) {
            return const Center(child: Text("No se encontró la información de la cita."));
          }

          final data = snap.data!.data() as Map<String, dynamic>;
          final Timestamp? ts = data["fecha"] as Timestamp?;
          final DateTime fecha = ts?.toDate() ?? DateTime.now();
          final String motivo = data["motivo"] ?? "Cita";
          final String estado = data["estado"] ?? "";

          final doctorRef = data["doctor"] as DocumentReference?;
          final vetRef = data["veterinaria"] as DocumentReference?;
          final paseadorRef = data["paseador"] as DocumentReference?;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  CustomCard(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _formatDate(fecha),
                          style: textTheme.titleLarge?.copyWith(
                            color: cs.primary,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          estado.toUpperCase(),
                          style: textTheme.labelSmall?.copyWith(
                             color: estado == "cancelada" ? Colors.red : Colors.grey
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),

                        FutureBuilder<Map<String, String>>(
                          future: _cargarDetallesCompletos(data, doctorRef, vetRef, paseadorRef),
                          builder: (context, detailsSnap) {
                            if (!detailsSnap.hasData) {
                              return const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2)
                                  ),
                                ),
                              );
                            }

                            final detalles = detailsSnap.data!;

                            return Column(
                              children: [
                                Text(
                                  detalles["direccion"]!,
                                  style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Motivo: $motivo",
                                  style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  detalles["nombres"]!,
                                  style: textTheme.bodyLarge?.copyWith(
                                    color: cs.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  if (data["ubicacion"] is GeoPoint)
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outline),
                      ),
                      child: Center(
                        child: Text(
                          "Coordenadas: ${(data["ubicacion"] as GeoPoint).latitude}, ${(data["ubicacion"] as GeoPoint).longitude}",
                          style: textTheme.bodySmall,
                        ),
                      ),
                    )
                  else if (data["map_url"] != null)
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: cs.outline),
                        image: DecorationImage(
                          image: NetworkImage(data["map_url"]),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),

                  const SizedBox(height: 32),

                  if (estado != "cancelada" && estado != "completada")
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _cancelarCita(context),
                          icon: const Icon(Icons.close),
                          label: const Text("Cancelar"),
                        ),
                        const SizedBox(width: 16),
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryGreen,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          onPressed: () => _reprogramarCita(context, data),
                          icon: const Icon(Icons.edit_calendar),
                          label: const Text("Reprogramar"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _HorariosSheet extends StatelessWidget {
  final List<DateTime> slots;

  const _HorariosSheet({required this.slots});

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.all(16),
      height: 400,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Horarios disponibles", style: tt.titleLarge),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: slots.length,
              itemBuilder: (_, i) {
                final s = slots[i];
                final label =
                    "${s.hour.toString().padLeft(2, "0")}:${s.minute.toString().padLeft(2, "0")}";

                return ListTile(
                  title: Text(label),
                  onTap: () => Navigator.pop(context, s),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}