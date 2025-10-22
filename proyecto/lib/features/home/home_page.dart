import 'package:flutter/material.dart';
import 'package:proyecto/features/home/widgets/home_search.dart';
import 'package:proyecto/features/home/widgets/next_appointment_card.dart';
import 'package:proyecto/features/home/widgets/doctor_carousel.dart';
import 'package:proyecto/shared/widgets/pets_summary_card.dart';
import 'package:proyecto/shared/widgets/promo_banner.dart';
import 'package:proyecto/shared/widgets/quick_actions.dart';
import 'package:proyecto/shared/widgets/section_header.dart';
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
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: RefreshIndicator(
        // pull-to-refresh sutil
        color: cs.primary,
        onRefresh: () async =>
            Future.delayed(const Duration(milliseconds: 800)),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const HomeSearch(),
              const SizedBox(height: 16),
              const PetSummaryCard(),
              const SizedBox(height: 16),
              const NextAppointmentCard(),

              const SizedBox(height: 24),
              const SectionHeader(title: "Agenda tu próxima cita"),
              const SizedBox(height: 12),
              const DoctorCarousel(),

              const SizedBox(height: 24),
              const SectionHeader(title: "Promos para ti"),
              const SizedBox(height: 12),
              const PromoBanner(),

              const SizedBox(height: 24),
              const SectionHeader(title: "Accesos rápidos"),
              const SizedBox(height: 8),
              const QuickActions(),

              const SizedBox(height: 28),
            ],
          ),
        ),
      ),
    );
  }
}
