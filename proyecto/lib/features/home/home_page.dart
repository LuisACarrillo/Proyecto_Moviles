import 'package:flutter/material.dart';
import 'package:proyecto/features/home/widgets/food_carousel.dart';
import 'package:proyecto/features/home/widgets/next_appointment_card.dart';
import 'package:proyecto/features/home/widgets/doctor_carousel.dart';
import 'package:proyecto/features/home/widgets/veterinaries_carousel.dart';
import 'package:proyecto/theme/app_colors.dart';
import 'package:proyecto/main.dart' show themeController;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const NextAppointmentCard(),
            const SizedBox(height: 24),
            Text(
              "Agenda tu próxima cita",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const DoctorCarousel(),
            const SizedBox(height: 24),
            Text(
              "Echa un vistazo a las siguientes veterinarias",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const VetCarousel(),
            const SizedBox(height: 24),
            Text(
              "Los alimentos más populares del momento",
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: cs.onSurface,
              ),
            ),
            const SizedBox(height: 12),
            const FoodCarousel(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
