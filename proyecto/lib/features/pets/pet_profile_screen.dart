import 'package:flutter/material.dart';
import 'package:proyecto/features/appointments/appointment_form_screen.dart';
import 'package:proyecto/features/pets/pet_edit_screen.dart';
import 'package:proyecto/routes/app_routes.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';

class PetProfileArgs {
  final String name;
  final int ageYears;
  final String nextVaccine;
  const PetProfileArgs({
    required this.name,
    required this.ageYears,
    required this.nextVaccine,
  });
}

class PetProfileScreen extends StatelessWidget {
  const PetProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    final args = ModalRoute.of(context)?.settings.arguments as PetProfileArgs?;
    final name = args?.name ?? "Tu mascota";
    final age = args?.ageYears ?? 0;
    final nextVaccine = args?.nextVaccine ?? "-";

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text(
          name,
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              CustomCard(
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: cs.primary.withValues(alpha: .12),
                      child: Icon(Icons.pets, color: cs.primary, size: 30),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: tt.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: cs.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$age años",
                            style: tt.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SecondaryButton(
                      text: "Editar",
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          AppRoutes.petEdit,
                          arguments: PetEditArgs(
                            name: name,
                            ageYears: age,
                            nextVaccine: nextVaccine,
                            species: 'Perro',
                            breed: 'Mestizo',
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Salud",
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.vaccines, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Próxima vacuna: $nextVaccine",
                            style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.local_hospital_outlined, color: cs.primary),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Desparasitación: pendiente",
                            style: tt.bodyMedium?.copyWith(color: cs.onSurface),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              CustomCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Historial",
                      style: tt.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const _HistoryItem(
                      icon: Icons.check_circle_outline,
                      title: "Vacuna antirrábica",
                      subtitle: "Aplicada el 01 Ago 2025",
                    ),
                    const _HistoryItem(
                      icon: Icons.medical_information_outlined,
                      title: "Consulta general",
                      subtitle: "15 Jul 2025 • Dr. Fulanito",
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              SizedBox(
                width: double.infinity,
                child: PrimaryButton(
                  text: "Agendar cita",
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.appointmentForm,
                      arguments: AppointmentArgs(
                        petName: name,
                        defaultReason: 'Consulta general',
                      ),
                    );
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

class _HistoryItem extends StatelessWidget {
  const _HistoryItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: cs.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: tt.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: cs.onSurface,
                  ),
                ),
                Text(
                  subtitle,
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
