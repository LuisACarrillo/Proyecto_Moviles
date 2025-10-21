import 'package:flutter/material.dart';
import 'package:proyecto/features/home/widgets/next_appointment_card.dart';
import 'package:proyecto/features/home/widgets/doctor_carousel.dart';
import 'package:proyecto/theme/app_colors.dart';
import 'package:proyecto/main.dart' show themeController;

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: SizedBox(
          height: 300,
          width: 300,
          child: Image.network("https://i.blogs.es/af3666/google-maps-aniversario-nuevo-logo/650_1200.png"),
        )
      ),
    );
  }
}
