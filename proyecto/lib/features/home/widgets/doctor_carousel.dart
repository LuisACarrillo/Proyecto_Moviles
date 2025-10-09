import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/theme/app_colors.dart';

class DoctorCarousel extends StatefulWidget {
  const DoctorCarousel({super.key});

  @override
  State<DoctorCarousel> createState() => _DoctorCarouselState();
}

class _DoctorCarouselState extends State<DoctorCarousel> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> doctors = [
    {"name": "Dr. Fulanito", "rating": 5},
    {"name": "Dra. Pérez", "rating": 4},
    {"name": "Dr. Ramírez", "rating": 5},
  ];

  @override
  Widget build(BuildContext context) {
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
                  const Icon(
                    Icons.medical_services,
                    color: AppColors.primaryGreen,
                    size: 40,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    doctor["name"],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      5,
                      (star) => Icon(
                        Icons.star,
                        color: star < doctor["rating"]
                            ? AppColors.accentGold
                            : AppColors.neutralGray,
                        size: 20,
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
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
        ),

        const SizedBox(height: 12),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: doctors.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => setState(() => _currentIndex = entry.key),
              child: Container(
                width: _currentIndex == entry.key ? 14.0 : 8.0,
                height: 8.0,
                margin: const EdgeInsets.symmetric(
                  vertical: 4.0,
                  horizontal: 4.0,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(4),
                  color: _currentIndex == entry.key
                      ? AppColors.primaryGreen
                      : AppColors.neutralGray.withValues(alpha: 0.4),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
