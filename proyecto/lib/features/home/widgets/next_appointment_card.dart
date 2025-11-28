import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/features/home/next_appointment_screen.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final userRef = FirebaseFirestore.instance
        .collection("usuarios")
        .doc(user.uid);
    final userPath = "/usuarios/${user.uid}";

    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("citas")
          .where("estado", isEqualTo: "pendiente")
          .orderBy("fecha")
          .snapshots(),
      builder: (context, snap) {
        if (!snap.hasData) return const SizedBox.shrink();
        final docsFiltrados = snap.data!.docs.where((doc) {
          final data = doc.data() as Map<String, dynamic>;
          final u = data["usuario"];

          if (u is DocumentReference) return u.path == userRef.path;
          if (u is String) return u == userPath;
          return false;
        }).toList();

        if (docsFiltrados.isEmpty) return const SizedBox.shrink();

        final doc = docsFiltrados.first;
        final data = doc.data() as Map<String, dynamic>;
        final ts = data["fecha"] as Timestamp?;
        final fecha = ts?.toDate();

        final fechaTexto = fecha != null
            ? "${fecha.day}/${fecha.month}/${fecha.year} "
                  "${fecha.hour.toString().padLeft(2, '0')}:"
                  "${fecha.minute.toString().padLeft(2, '0')}"
            : "Fecha no disponible";

        final veterinariaRef =
            data["veterinaria"] as DocumentReference<Object?>?;

        return CustomCard(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NextAppointmentScreen()),
            );
          },
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(Icons.event, color: cs.primary, size: 36),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Tu próxima cita:",
                      style: tt.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      fechaTexto,
                      style: tt.bodySmall?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (veterinariaRef == null)
                      Text(
                        "Veterinaria no asignada",
                        style: tt.bodySmall?.copyWith(
                          color: cs.onSurfaceVariant,
                        ),
                      )
                    else
                      FutureBuilder<DocumentSnapshot>(
                        future: veterinariaRef.get(),
                        builder: (context, vetSnap) {
                          if (!vetSnap.hasData) {
                            return Text(
                              "Cargando ubicación...",
                              style: tt.bodySmall?.copyWith(
                                color: cs.onSurfaceVariant,
                              ),
                            );
                          }

                          final vetData =
                              vetSnap.data!.data() as Map<String, dynamic>?;

                          final nombre = vetData?["nombre"] ?? "Veterinaria";
                          final direccion =
                              vetData?["direccion"] ??
                              vetData?["ubicacion"] ??
                              "";

                          final label = direccion.isNotEmpty
                              ? "$nombre – $direccion"
                              : nombre;

                          return Text(
                            label,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
