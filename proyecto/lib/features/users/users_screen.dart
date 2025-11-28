import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_storage/firebase_storage.dart";
import "package:flutter/material.dart";
import "package:carousel_slider/carousel_slider.dart" as cs;
import "package:firebase_auth/firebase_auth.dart";
import "package:firebase_ui_auth/firebase_ui_auth.dart";
import "package:image_picker/image_picker.dart";
import 'dart:convert';

import "package:proyecto/features/pets/pet_create_screen.dart";
import "package:proyecto/services/citas_service.dart";
import "package:proyecto/shared/widgets/pets_summary_card.dart";
import "package:proyecto/theme/app_colors.dart";
import "package:proyecto/routes/app_routes.dart";

class CitaInfoWidget extends StatelessWidget {
  final Map<String, dynamic> data;
  final String fechaTexto;

  const CitaInfoWidget({
    super.key,
    required this.data,
    required this.fechaTexto,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    final doctorRef = data["doctor"] as DocumentReference?;
    final vetRef = data["veterinaria"] as DocumentReference?;
    final paseadorRef = data["paseador"] as DocumentReference?;

    return FutureBuilder(
      future: _loadExtraInfo(doctorRef, vetRef, paseadorRef),
      builder: (context, snap) {
        String extra = "";
        if (snap.hasData) extra = snap.data as String;

        return Column(
          children: [
            Text(
              data["motivo"] ?? "Cita",
              style: textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),

            if (extra.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                extra,
                style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ],

            const SizedBox(height: 6),
            Text(
              fechaTexto,
              style: textTheme.bodyMedium?.copyWith(color: Colors.white),
            ),
            Text(
              data["estado"] ?? "",
              style: textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        );
      },
    );
  }

  Future<String> _loadExtraInfo(
    DocumentReference? doctorRef,
    DocumentReference? vetRef,
    DocumentReference? paseadorRef,
  ) async {
    String result = "";

    if (doctorRef != null) {
      final doc = await doctorRef.get();
      result += "Dr. ${doc["nombre"]}";
    }

    if (vetRef != null) {
      final doc = await vetRef.get();
      if (result.isNotEmpty) result += " – ";
      result += "${doc["nombre"]}";
    }

    if (paseadorRef != null) {
      final doc = await paseadorRef.get();
      result += "Paseador: ${doc["nombre"]}";
    }

    return result;
  }
}

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final csTheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: Text("No hay usuario autenticado.")),
      );
    }

    final userRef = FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid);
    final String userPath = "/usuarios/${user.uid}";
    print(userPath);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("usuarios")
                        .doc(user.uid)
                        .snapshots(),
                    builder: (context, snap) {
                      String? foto = snap.data?["foto"];

                      ImageProvider? avatar;

                      if (foto != null && foto.startsWith("data:image")) {
                        final bytes = base64Decode(foto.split(",").last);
                        avatar = MemoryImage(bytes);
                      }

                      return GestureDetector(
                        onTap: () => _mostrarOpcionesFoto(context, user),
                        child: CircleAvatar(
                          radius: 36,
                          backgroundColor: AppColors.primaryGreen,
                          backgroundImage: avatar,
                          child: avatar == null
                              ? const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 32,
                                )
                              : null,
                        ),
                      );
                    },
                  ),

                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user.displayName ?? "Usuario sin nombre",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: csTheme.onSurface,
                        ),
                      ),
                      Text(
                        user.email ?? "Correo no disponible",
                        style: textTheme.bodyMedium?.copyWith(
                          color: csTheme.onSurface.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Información de la mascota",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: csTheme.onSurface,
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("Agregar mascota"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.petCreate,
                          arguments: PetCreateArgs(userPath: userPath),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("mascotas")
                    .where("dueno", isEqualTo: userRef)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("No tienes mascotas registradas."),
                    );
                  }

                  final petCards = snapshot.data!.docs.map((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final Timestamp? vaccineTimestamp = data["proxima_vacuna"];
                    final String nextVaccineDate = vaccineTimestamp != null
                        ? "${vaccineTimestamp.toDate().day}/${vaccineTimestamp.toDate().month}/${vaccineTimestamp.toDate().year}"
                        : "No registrada";

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: PetSummaryCard(
                        petDocId: doc.id,
                        userPath: userPath,
                        name: data["nombre"] ?? "Sin nombre",
                        ageYears: data["edad"] ?? 0,
                        breed: data["raza"] ?? "No especificada",
                        species: data["especie"] ?? "No especificada",
                        nextVaccine: nextVaccineDate,
                        imageUrl: data["foto_url"],
                      ),
                    );
                  }).toList();

                  return Column(children: petCards);
                },
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Citas pendientes",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: csTheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("citas")
                    .where("estado", isEqualTo: "pendiente")
                    .orderBy("fecha", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData) {
                    return const SizedBox.shrink();
                  }

                  final docsFiltrados = snapshot.data!.docs.where((doc) {
                    final data = doc.data() as Map<String, dynamic>;
                    final u = data["usuario"];

                    if (u is DocumentReference) {
                      return u.path == userRef.path;
                    }
                    if (u is String) {
                      return u == userPath || u == userRef.path;
                    }
                    return false;
                  }).toList();

                  if (docsFiltrados.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("No tienes citas próximas."),
                    );
                  }

                  return cs.CarouselSlider(
                    options: cs.CarouselOptions(
                      height: 200,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      enableInfiniteScroll: false,
                      viewportFraction: 0.85,
                    ),
                    items: docsFiltrados.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final Timestamp? ts = data["fecha"];
                      final fecha = ts?.toDate();
                      final fechaTexto = fecha != null
                          ? "${fecha.day}/${fecha.month}/${fecha.year} "
                                "${fecha.hour.toString().padLeft(2, '0')}:"
                                "${fecha.minute.toString().padLeft(2, '0')}"
                          : "Sin fecha";

                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  CitaInfoWidget(
                                    data: data,
                                    fechaTexto: fechaTexto,
                                  ),

                                  const SizedBox(height: 10),

                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      TextButton.icon(
                                        icon: const Icon(
                                          Icons.close,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "Cancelar",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          await FirebaseFirestore.instance
                                              .collection("citas")
                                              .doc(doc.id)
                                              .update({"estado": "cancelada"});

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text("Cita cancelada"),
                                            ),
                                          );
                                        },
                                      ),

                                      const SizedBox(width: 16),

                                      TextButton.icon(
                                        icon: const Icon(
                                          Icons.edit_calendar,
                                          color: Colors.white,
                                        ),
                                        label: const Text(
                                          "Reprogramar",
                                          style: TextStyle(color: Colors.white),
                                        ),
                                        onPressed: () async {
                                          final data =
                                              doc.data()
                                                  as Map<String, dynamic>;

                                          final servicio =
                                              data["tipo"]; // veterinario / paseo / grooming

                                          final doctorRef =
                                              data["doctor"]
                                                  as DocumentReference?;
                                          final paseadorRef =
                                              data["paseador"]
                                                  as DocumentReference?;
                                          final veterinariaRef =
                                              data["veterinaria"]
                                                  as DocumentReference?;

                                          final mascotaRef =
                                              data["mascota"]
                                                  as DocumentReference;
                                          final usuarioRef =
                                              data["usuario"]
                                                  as DocumentReference;

                                          final DateTime? dia =
                                              await showDatePicker(
                                                context: context,
                                                initialDate:
                                                    fecha ?? DateTime.now(),
                                                firstDate: DateTime.now(),
                                                lastDate: DateTime.now().add(
                                                  const Duration(days: 365),
                                                ),
                                              );

                                          if (dia == null) return;

                                          final ocupados = await CitasService()
                                              .obtenerHorariosOcupados(
                                                tipo: servicio,
                                                dia: dia,
                                                doctor: doctorRef,
                                                paseador: paseadorRef,
                                                veterinaria: veterinariaRef,
                                                usuarioRef: usuarioRef,
                                              );

                                          final disponibles = CitasService()
                                              .generarSlotsDisponibles(
                                                dia,
                                                ocupados,
                                              );

                                          if (disponibles.isEmpty) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "No hay horarios disponibles este día.",
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          final seleccionado =
                                              await showModalBottomSheet<
                                                DateTime
                                              >(
                                                context: context,
                                                builder: (_) => _HorariosSheet(
                                                  slots: disponibles,
                                                ),
                                              );

                                          if (seleccionado == null) return;

                                          final disponible =
                                              await CitasService()
                                                  .verificarDisponibilidad(
                                                    tipo: servicio,
                                                    fecha: seleccionado,
                                                    doctor: doctorRef,
                                                    paseador: paseadorRef,
                                                    veterinaria: veterinariaRef,
                                                  );

                                          if (!disponible) {
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                  "Ese horario se ocupó hace un momento.",
                                                ),
                                              ),
                                            );
                                            return;
                                          }

                                          await FirebaseFirestore.instance
                                              .collection("citas")
                                              .doc(doc.id)
                                              .update({"fecha": seleccionado});

                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                "Cita reprogramada con éxito",
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Historial de citas",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: csTheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("citas")
                    .where("usuario", isEqualTo: userRef)
                    .where("estado", isNotEqualTo: "pendiente")
                    .orderBy("estado")
                    .orderBy("fecha", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("No tienes citas en tu historial."),
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return cs.CarouselSlider(
                    options: cs.CarouselOptions(
                      height: 200,
                      enlargeCenterPage: true,
                      autoPlay: false,
                    ),
                    items: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final ts = data["fecha"] as Timestamp?;

                      if (ts == null) {
                        return const SizedBox();
                      }

                      final fecha = ts.toDate();
                      final fechaString =
                          "${fecha.day}/${fecha.month} ${fecha.hour.toString().padLeft(2, '0')}:${fecha.minute.toString().padLeft(2, '0')}";

                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CitaInfoWidget(
                                data: data,
                                fechaTexto: fechaString,
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 24),

              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Cerrar sesión"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await FirebaseUIAuth.signOut(context: context);
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(
                        context,
                        "/login",
                        (_) => false,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
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
                    "${s.hour.toString().padLeft(2, '0')}:${s.minute.toString().padLeft(2, '0')}";

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

Future<void> _mostrarOpcionesFoto(BuildContext context, User user) async {
  showModalBottomSheet(
    context: context,
    builder: (_) {
      return SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.photo),
              title: const Text("Elegir de galería"),
              onTap: () async {
                Navigator.pop(context);
                await _cambiarFotoPerfil(context, user, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text("Tomar foto"),
              onTap: () async {
                Navigator.pop(context);
                await _cambiarFotoPerfil(context, user, ImageSource.camera);
              },
            ),
          ],
        ),
      );
    },
  );
}

Future<void> _cambiarFotoPerfil(
  BuildContext context,
  User user,
  ImageSource source,
) async {
  try {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: source,
      maxWidth: 512,
      maxHeight: 512,
      imageQuality: 70,
    );

    if (picked == null) return;

    final bytes = await picked.readAsBytes();
    final base64Img = "data:image/jpeg;base64,${base64Encode(bytes)}";

    // Guardamos SOLO en Firestore
    await FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid)
        .update({"foto": base64Img});

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Foto de perfil actualizada")));
  } catch (e) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text("Error al subir foto: $e")));
  }
}
