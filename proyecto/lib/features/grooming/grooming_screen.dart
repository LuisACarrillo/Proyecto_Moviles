import 'package:flutter/material.dart';
import 'package:proyecto/features/appointments/appointment_form_screen.dart';
import 'package:proyecto/routes/app_routes.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';

class GroomingScreen extends StatelessWidget {
  const GroomingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          'Grooming',
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CustomCard(
            child: Row(
              children: [
                Icon(Icons.cut, color: cs.primary, size: 28),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Reserva un grooming para tu mascota',
                    style: tt.bodyMedium?.copyWith(
                      color: cs.onSurface,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      AppRoutes.appointmentForm,
                      arguments: AppointmentArgs(
                        petName: 'name',
                        defaultReason: 'Grooming',
                      ),
                    );
                  },
                  child: Text('Agendar', style: TextStyle(color: cs.primary)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          CustomCard(
            child: Text(
              'Listado de estéticas cercanas (pendiente)',
              style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }
}
