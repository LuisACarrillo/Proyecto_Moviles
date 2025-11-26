import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:proyecto/theme/app_colors.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final csTheme = Theme.of(context).colorScheme;
    final user = FirebaseAuth.instance.currentUser;
    final String userPath = "/usuarios/${user?.uid}";
    print(userPath);

    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Perfil'),
      //   actions: [
      //     IconButton(
      //       icon: const Icon(Icons.logout),
      //       tooltip: 'Cerrar sesión',
      //       onPressed: () async {
      //         await FirebaseAuth.instance.signOut();
      //         // También cierra sesión de proveedores (Google, etc.)
      //         await FirebaseUIAuth.signOut(context: context);
      //         if (context.mounted) {
      //           Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
      //         }
      //       },
      //     )
      //   ],
      // ),
      // esto pudiera servir como ejemplo para cerrar sesion desde la parte de arriba
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 36,
                    backgroundColor: AppColors.primaryGreen,
                    backgroundImage: user?.photoURL != null
                        ? NetworkImage(user!.photoURL!)
                        : null,
                    child: user?.photoURL == null
                        ? const Icon(Icons.person, color: Colors.white, size: 36)
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        user?.displayName ?? "Usuario sin nombre",
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: csTheme.onSurface,
                        ),
                      ),
                      Text(
                        user?.email ?? "Correo no disponible",
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
                child: Text(
                  "Información de la mascota",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: csTheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("mascotas")
                    .where("dueno", isEqualTo: userPath)
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
                      child: const Text("No tienes mascotas registradas")
                    );
                  }

                  final mascotaData = snapshot.data!.docs.first.data() as Map<String, dynamic>;

                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: Text(
                            "Raza: ${mascotaData["raza"] ?? "N/A"}\n"
                            "Edad: ${mascotaData["edad"] ?? "N/A"} años\n"
                            "Especie: ${mascotaData["especie"] ?? "N/A"}",
                            style: textTheme.bodyMedium?.copyWith(
                              color: csTheme.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
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
                    .where("usuario", isEqualTo: userPath)
                    .where("estado", isEqualTo: "pendiente")
                    .orderBy("Fecha", descending: false)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.surfaceVariant,
                         borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("No tienes citas próximas.")
                    );
                  }

                  final proximaCita = snapshot.data!.docs.first.data() as Map<String, dynamic>;
                  final Timestamp? ts = proximaCita["Fecha"];
                  final String fechaTexto = ts != null
                      ? ts.toDate().toString().substring(0, 16)
                      : "Sin fecha";
                  final String nombreDoctor = proximaCita["Doctor"];

                  return Row(
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.surfaceVariant,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Theme.of(context).dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Motivo: ${proximaCita["Motivo"]}",
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text("Fecha: $fechaTexto"),
                              Text("Estado: ${proximaCita["estado"]}"),
                              Text("Doctor: $nombreDoctor"),
                            ],
                          ),
                        ),
                      ),
                    ],
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
                    .where("usuario", isEqualTo: userPath)
                    .where("estado", isNotEqualTo: "pendiente")
                    .orderBy("Fecha", descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(16),
                      width: double.infinity,
                      decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.surfaceVariant,
                         borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text("No tienes citas en tu historial.")
                    );
                  }

                  final docs = snapshot.data!.docs;

                  return cs.CarouselSlider(
                    options: cs.CarouselOptions(
                      height: 150,
                      enlargeCenterPage: true,
                      autoPlay: false,
                      aspectRatio: 16 / 9,
                    ),
                    items: docs.map((doc) {
                      final data = doc.data() as Map<String, dynamic>;
                      final Timestamp? ts = data["Fecha"];
                      final dateStr = ts != null
                          ? "${ts.toDate().day}/${ts.toDate().month} ${ts.toDate().hour}:${ts.toDate().minute}"
                          : "";

                      return Builder(
                        builder: (BuildContext context) {
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
                                  Text(
                                    data["Motivo"] ?? "Cita",
                                    style: textTheme.titleMedium?.copyWith(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    dateStr,
                                    style: textTheme.bodyMedium?.copyWith(color: Colors.white),
                                  ),
                                  Text(
                                    data["estado"] ?? "",
                                    style: textTheme.bodySmall?.copyWith(color: Colors.white70),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }).toList(),
                  );
                }
              ),

              const SizedBox(height: 24),

              //  Botón de cerrar sesión
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text("Cerrar sesión"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () async {
                    await FirebaseAuth.instance.signOut();
                    await FirebaseUIAuth.signOut(context: context);
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, "/login", (_) => false);
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
