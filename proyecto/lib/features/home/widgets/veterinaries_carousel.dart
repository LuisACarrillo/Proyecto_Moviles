import "package:flutter/material.dart";
import "package:carousel_slider/carousel_slider.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:proyecto/features/home/vet_profile.dart";
import "package:proyecto/routes/app_routes.dart";
import "package:proyecto/shared/widgets/custom_card.dart";

class VetCarousel extends StatefulWidget {
  const VetCarousel({super.key});

  @override
  State<VetCarousel> createState() => _VetCarouselState();
}

class _VetCarouselState extends State<VetCarousel> {
  int _currentIndex = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  late Stream<QuerySnapshot> _vetsStream;

  @override
  void initState() {
    super.initState();
    _vetsStream = FirebaseFirestore.instance.collection("veterinarias").snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return StreamBuilder<QuerySnapshot>(
      stream: _vetsStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          );
        }

        if (snapshot.hasError) {
          return SizedBox(
            height: 240,
            child: Center(child: Text("Error: ${snapshot.error}")),
          );
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const SizedBox(
            height: 240,
            child: Center(child: Text("No hay veterinarias disponibles")),
          );
        }

        final vets = snapshot.data!.docs;

        return Column(
          children: [
            CarouselSlider.builder(
              carouselController: _controller,
              itemCount: vets.length,
              itemBuilder: (context, index, realIndex) {
                final vetData = vets[index].data() as Map<String, dynamic>;
                final vetName = vetData["nombre"] ?? "Veterinaria";
                final telefono = vetData["telefono"] ?? "Sin teléfono";
                final direccion = vetData["direccion"] ?? "Sin dirección";
                final horaApertura = vetData["hora_apertura"] ?? "00:00";
                final horaCierre = vetData["hora_cierre"] ?? "00:00";

                return CustomCard(
                  margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.vetProfile,
                        arguments: VetProfileArgs(vetId: vets[index].id)
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.pets, color: cs.primary, size: 32),
                          const SizedBox(height: 8),
                          Text(
                            vetName,
                            style: textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                              color: cs.onSurface,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            "$horaApertura - $horaCierre",
                            style: textTheme.bodySmall?.copyWith(
                              color: cs.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, size: 16, color: cs.primary),
                              const SizedBox(width: 4),
                              Text(
                                telefono,
                                style: textTheme.bodySmall?.copyWith(
                                  color: cs.onSurface,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.pin_drop, size: 16, color: cs.primary),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  direccion,
                                  style: textTheme.bodySmall?.copyWith(
                                    color: cs.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
              options: CarouselOptions(
                height: 240,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 16 / 9,
                enableInfiniteScroll: vets.length > 1,
                autoPlayInterval: const Duration(seconds: 4),
                onPageChanged: (index, reason) =>
                    setState(() => _currentIndex = index),
              ),
            ),
            const SizedBox(height: 12),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: vets.asMap().entries.map((entry) {
                return GestureDetector(
                  onTap: () => _controller.animateToPage(entry.key),
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
                              ? cs.primary
                              : cs.outline.withOpacity(0.4),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}