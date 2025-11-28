import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:proyecto/models/cita.dart';
import 'package:proyecto/services/citas_service.dart';
import 'package:proyecto/services/mascotas_service.dart';
import 'package:proyecto/services/doctores_service.dart';
import 'package:proyecto/services/paseadores_service.dart';
import 'package:proyecto/services/veterinarias_service.dart';

import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';

class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({super.key});

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _serviceCitas = CitasService();
  final _serviceMascotas = MascotasService();
  final _serviceDoctores = DoctoresService();
  final _servicePaseadores = PaseadoresService();
  final _serviceVeterinarias = VeterinariasService();

  String? _servicio;
  String? _especialidad;
  String? _doctorId;
  String? _paseadorId;
  String? _mascotaId;
  String? _veterinariaId;

  DocumentReference? _doctorRef;
  DocumentReference? _veterinariaRef;
  DocumentReference? _paseadorRef;

  DateTime? _fecha;
  String _motivo = "";

  final String uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Agendar cita",
          style: tt.titleLarge?.copyWith(color: cs.primary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CustomCard(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StreamBuilder(
                stream: _serviceMascotas.obtenerMascotasUsuario(uid),
                builder: (context, snap) {
                  if (!snap.hasData) return const LinearProgressIndicator();
                  final mascotas = snap.data!;
                  if (mascotas.isEmpty) {
                    return const Text("No tienes mascotas registradas.");
                  }

                  return DropdownButtonFormField(
                    decoration: const InputDecoration(
                      labelText: "Mascota",
                      prefixIcon: Icon(Icons.pets),
                    ),
                    value: _mascotaId,
                    items: mascotas.map((m) {
                      return DropdownMenuItem(
                        value: m.id,
                        child: Text(m.nombre),
                      );
                    }).toList(),
                    onChanged: (v) => setState(() => _mascotaId = v),
                  );
                },
              ),

              const SizedBox(height: 20),

              DropdownButtonFormField(
                decoration: const InputDecoration(
                  labelText: "Servicio",
                  prefixIcon: Icon(Icons.miscellaneous_services),
                ),
                value: _servicio,
                items: const [
                  DropdownMenuItem(
                    value: "Veterinario",
                    child: Text("Veterinario"),
                  ),
                  DropdownMenuItem(value: "Paseo", child: Text("Paseo")),
                  DropdownMenuItem(value: "Grooming", child: Text("Grooming")),
                ],
                onChanged: (v) {
                  setState(() {
                    _servicio = v;
                    _especialidad = null;
                    _doctorId = null;
                    _paseadorId = null;
                    _veterinariaId = null;
                    _doctorRef = null;
                    _paseadorRef = null;
                    _veterinariaRef = null;
                  });
                },
              ),

              const SizedBox(height: 20),

              if (_servicio == "Grooming")
                StreamBuilder(
                  stream: _serviceVeterinarias.obtenerVeterinarias(),
                  builder: (context, snap) {
                    if (!snap.hasData) return const LinearProgressIndicator();
                    final vets = snap.data!;

                    return SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        isExpanded: true, // <- importantísimo
                        decoration: const InputDecoration(
                          labelText: "Veterinaria",
                          prefixIcon: Icon(Icons.local_hospital),
                          // puedes subir un poco el padding vertical si quieres
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                        ),
                        value: _veterinariaId,
                        items: vets.map((v) {
                          final data = v.data() as Map<String, dynamic>;
                          return DropdownMenuItem<String>(
                            value: v.id,
                            child: Text(
                              data["nombre"] ?? "Veterinaria",
                              maxLines: 2, // permite “bajar” el texto
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                            ),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            _veterinariaId = v;
                            _veterinariaRef = FirebaseFirestore.instance
                                .collection("veterinarias")
                                .doc(v);
                          });
                        },
                      ),
                    );
                  },
                ),

              if (_servicio == "Paseo")
                StreamBuilder(
                  stream: _servicePaseadores.obtenerPaseadores(),
                  builder: (context, snap) {
                    if (!snap.hasData) return const LinearProgressIndicator();
                    final paseadores = snap.data!;

                    return DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Paseador",
                        prefixIcon: Icon(Icons.directions_walk),
                      ),
                      value: _paseadorId,
                      items: paseadores.map((p) {
                        return DropdownMenuItem(
                          value: p.id,
                          child: Text(p.nombre),
                        );
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _paseadorId = v;
                          _paseadorRef = FirebaseFirestore.instance
                              .collection("paseadores")
                              .doc(v);
                        });
                      },
                    );
                  },
                ),
              if (_servicio == "Veterinario") ...[
                StreamBuilder(
                  stream: _serviceDoctores.obtenerEspecialidades(),
                  builder: (context, snap) {
                    if (!snap.hasData) return const LinearProgressIndicator();
                    final especialidades = snap.data!;

                    return DropdownButtonFormField(
                      decoration: const InputDecoration(
                        labelText: "Especialidad",
                        prefixIcon: Icon(Icons.medical_services_outlined),
                      ),
                      value: _especialidad,
                      items: especialidades.map((e) {
                        return DropdownMenuItem(value: e, child: Text(e));
                      }).toList(),
                      onChanged: (v) {
                        setState(() {
                          _especialidad = v;
                          _doctorId = null;
                          _doctorRef = null;
                          _veterinariaRef = null;
                        });
                      },
                    );
                  },
                ),

                const SizedBox(height: 20),

                if (_especialidad != null)
                  StreamBuilder(
                    stream: _serviceDoctores.obtenerDoctoresPorEspecialidad(
                      _especialidad!,
                    ),
                    builder: (context, snap) {
                      if (!snap.hasData) return const LinearProgressIndicator();
                      final doctores = snap.data!;

                      return DropdownButtonFormField(
                        decoration: const InputDecoration(
                          labelText: "Doctor",
                          prefixIcon: Icon(Icons.person_outline),
                        ),
                        value: _doctorId,
                        items: doctores.map((d) {
                          return DropdownMenuItem(
                            value: d.id,
                            child: Text(d.nombre),
                          );
                        }).toList(),
                        onChanged: (v) {
                          setState(() {
                            _doctorId = v;
                            final doctor = doctores.firstWhere(
                              (d) => d.id == v,
                            );

                            _doctorRef = FirebaseFirestore.instance
                                .collection("doctores")
                                .doc(v);

                            _veterinariaRef = doctor.ubicacion;
                          });
                        },
                      );
                    },
                  ),
              ],

              const SizedBox(height: 20),

              InkWell(
                onTap: _seleccionarDia,
                borderRadius: BorderRadius.circular(12),
                child: InputDecorator(
                  isEmpty: _fecha == null,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    _fecha == null
                        ? "Selecciona fecha"
                        : "${_fecha!.day.toString().padLeft(2, '0')}/"
                              "${_fecha!.month.toString().padLeft(2, '0')}/"
                              "${_fecha!.year} – "
                              "${_fecha!.hour.toString().padLeft(2, '0')}:"
                              "${_fecha!.minute.toString().padLeft(2, '0')}",
                  ),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                decoration: const InputDecoration(
                  labelText: "Motivo de la cita",
                  prefixIcon: Icon(Icons.note_add_outlined),
                ),
                onChanged: (v) => _motivo = v,
              ),

              const SizedBox(height: 32),
              PrimaryButton(text: "Confirmar cita", onPressed: _crearCita),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _seleccionarDia() async {
    final DateTime? dia = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (dia == null) return;

    final ocupados = await _serviceCitas.obtenerHorariosOcupados(
      tipo: _servicio!,
      dia: dia,
      doctor: _doctorRef,
      paseador: _paseadorRef,
      veterinaria: _veterinariaRef,
      usuarioRef: FirebaseFirestore.instance.collection("usuarios").doc(uid),
    );

    final disponibles = _serviceCitas.generarSlotsDisponibles(dia, ocupados);

    if (disponibles.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No hay horarios disponibles este día.")),
      );
      return;
    }

    final seleccionado = await showModalBottomSheet<DateTime>(
      context: context,
      builder: (_) => _HorariosSheet(slots: disponibles),
    );

    if (seleccionado != null) {
      setState(() => _fecha = seleccionado);
    }
  }

  Future<void> _crearCita() async {
    if (!(_fecha!.minute == 0 || _fecha!.minute == 30)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Las citas solo pueden ser a la hora o y media (ej: 10:00, 10:30).",
          ),
        ),
      );
      return;
    }

    final disponible = await _serviceCitas.verificarDisponibilidad(
      tipo: _servicio!,
      fecha: _fecha!,
      doctor: _doctorRef,
      paseador: _paseadorRef,
      veterinaria: _veterinariaRef,
    );

    if (!disponible) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El horario elegido ya está ocupado.")),
      );
      return;
    }

    if (_mascotaId == null || _fecha == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Completa todos los campos")),
      );
      return;
    }

    final cita = Cita(
      id: "",
      usuario: FirebaseFirestore.instance.collection("usuarios").doc(uid),
      mascota: FirebaseFirestore.instance
          .collection("mascotas")
          .doc(_mascotaId),

      fecha: _fecha!,
      motivo: _motivo,
      estado: "pendiente",

      tipo: _servicio ?? "otro",

      doctor: _doctorRef,
      paseador: _paseadorRef,
      veterinaria: _veterinariaRef,
    );

    await _serviceCitas.crearCita(cita);

    if (!mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Cita creada con éxito")));
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
