import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:proyecto/features/home/food_profile.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';

class ImageCarousel extends StatefulWidget {
  const ImageCarousel({super.key});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  int _currentIndex = 0;

  final List<Map<String, dynamic>> images = const [
    {"src": "https://m.media-amazon.com/images/I/616zLpqRSGL._AC_UF1000,1000_QL80_.jpg"},
    {"src": "https://ss345.liverpool.com.mx/xl/1072677277.jpg"},
    {"src": "https://m.media-amazon.com/images/I/51GzI9iM+FL._AC_UF1000,1000_QL80_.jpg"},
  ];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          itemBuilder: (context, index, realIndex) {
            final image = images[index];
            return CustomCard(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image.network(
                      Uri.encodeFull(image["src"]),
                      fit: BoxFit.cover,
                    ),
                  )
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FoodProfile())
                );
              },
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
          children: images.asMap().entries.map((entry) {
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
