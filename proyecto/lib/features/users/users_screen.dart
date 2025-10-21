import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart' as cs;
import 'package:proyecto/theme/app_colors.dart';

class UserScreen extends StatelessWidget {
  const UserScreen({super.key});
  // final cs.CarouselController _controller = cs.CarouselController();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final csTheme = Theme.of(context).colorScheme;

    // No Scaffold here — HomeScreen provides the scaffold and appBar
    return SafeArea(
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
                  child: Icon(Icons.person, color: Colors.white, size: 36),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Nombre', style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: csTheme.onSurface)),
                    Text('Raza', style: textTheme.bodyMedium?.copyWith(color: csTheme.onSurface)),
                    Text('Edad', style: textTheme.bodyMedium?.copyWith(color: csTheme.onSurface)),
                    Text('Peso', style: textTheme.bodyMedium?.copyWith(color: csTheme.onSurface)),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 32),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Citas previas',
                style: textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: csTheme.onSurface),
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
                      'Aquí va la información de las citas...',
                      style: textTheme.bodyMedium?.copyWith(color: csTheme.onSurface),
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
          ],
        ),
      ),
    );
  }
}