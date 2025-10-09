import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';

class DoctorCarousel extends StatefulWidget {
  const DoctorCarousel({super.key});

  @override
  State<DoctorCarousel> createState() => _DoctorCarouselState();
}

class _DoctorCarouselState extends State<DoctorCarousel> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> doctors = const [
    {"name": "Dr. Fulanito", "rating": 5},
    {"name": "Dra. Pérez", "rating": 4},
    {"name": "Dr. Ramírez", "rating": 5},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: doctors.length,
          itemBuilder: (context, index, realIndex) {
            final doctor = doctors[index];
            return CustomCard(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.medical_services, color: cs.primary, size: 40),
                  const SizedBox(height: 8),
                  Text(
                    doctor["name"] as String,
                    style: textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: cs.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (star) => Icon(
                        Icons.star,
                        size: 20,
                        color: star < (doctor["rating"] as int)
                            ? cs
                                  .secondary
                            : cs.outline.withValues(alpha: 0.6),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
          options: CarouselOptions(
            height: 200,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            enableInfiniteScroll: true,
            autoPlayInterval: const Duration(seconds: 4),
            onPageChanged: (index, reason) =>
                setState(() => _currentIndex = index),
          ),
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: doctors.asMap().entries.map((entry) {
            final isActive = _currentIndex == entry.key;
            return GestureDetector(
              onTap: () => setState(() => _currentIndex = entry.key),
              child: Container(
                width: isActive ? 14.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 4.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: isActive
                      ? cs.primary
                      : cs.outline.withValues(
                          alpha: 0.4,
                        ), 
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
