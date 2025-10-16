import 'package:flutter/material.dart';
import 'package:proyecto/features/home/next_appointment_screen.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';

class NextAppointmentCard extends StatelessWidget {
  const NextAppointmentCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CustomCard(
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
                  "Viernes 5 de septiembre",
                  style: tt.bodySmall?.copyWith(
                    color: cs.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Calle 236, Col. Producción",
                  style: tt.bodySmall?.copyWith(color: cs.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NextAppointmentScreen())
        );
      },
    );
  }
}
