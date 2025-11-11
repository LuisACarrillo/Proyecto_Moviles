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
                        user?.displayName ?? 'Usuario sin nombre',
                        style: textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: csTheme.onSurface,
                        ),
                      ),
                      Text(
                        user?.email ?? 'Correo no disponible',
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
                  'Información de la mascota',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: csTheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(height: 8),

              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Text(
                        'Raza: Labrador\nEdad: 5 años\nPeso: 25 kg',
                        style: textTheme.bodyMedium?.copyWith(
                          color: csTheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Citas previas',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: csTheme.onSurface,
                  ),
                ),
              ),

              const SizedBox(height: 8),

              // 👇 Contenedor con texto
              Row(
                children: [
                  Expanded(
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 0),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Theme.of(context).dividerColor),
                      ),
                      child: Text(
                        'Aquí va la información de las citas...',
                        style: textTheme.bodyMedium?.copyWith(
                          color: csTheme.onSurface,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              cs.CarouselSlider(
                options: cs.CarouselOptions(
                  height: 150,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayInterval: const Duration(seconds: 3),
                ),
                items: [
                  'Cita 1',
                  'Cita 2',
                  'Cita 3',
                ].map((item) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width * 0.8,
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreen,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(
                            item,
                            style: textTheme.titleMedium?.copyWith(color: Colors.white),
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),

              //  Botón de cerrar sesión 
              Align(
                alignment: Alignment.center,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text('Cerrar sesión'),
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
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (_) => false);
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
