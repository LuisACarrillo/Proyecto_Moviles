import 'package:flutter/material.dart';
import 'package:proyecto/features/home/widgets/next_appointment_card.dart';
import 'package:proyecto/features/home/widgets/doctor_carousel.dart';
import 'package:proyecto/shared/widgets/app_bottom.dart';
import 'package:proyecto/theme/app_colors.dart';
import 'package:proyecto/main.dart' show themeController;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        title: Text(
          "¡Bienvenido Usuario!",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          AnimatedBuilder(
            animation: themeController,
            builder: (context, _) {
              return Row(
                children: [
                  const Icon(
                    Icons.wb_sunny_outlined,
                    color: AppColors.accentGold,
                  ),
                  // TODO: Move switch to corresponding screen
                  Switch.adaptive(
                    value: themeController.isDark,
                    onChanged: themeController.setDark,
                    activeColor: AppColors.primaryGreen,
                    inactiveThumbColor: AppColors.accentGold,
                  ),
                  const Icon(
                    Icons.nights_stay_outlined,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                ],
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
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
          ],
        ),
      ),
      bottomNavigationBar: AppBottomBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    );
  }
}
