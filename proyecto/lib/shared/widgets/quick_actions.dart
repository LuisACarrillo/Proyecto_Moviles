import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/routes/app_routes.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final items = const [
      (Icons.cut, "Grooming", AppRoutes.grooming),
      (Icons.local_hospital_outlined, "Veterinario", AppRoutes.vets),
      (Icons.pets, "Paseo", AppRoutes.walks),
      (Icons.store_outlined, "Tienda", AppRoutes.store),
    ];

    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          mainAxisSpacing: 8,
          crossAxisSpacing: 4,
        ),
        itemBuilder: (_, i) {
          final (icon, label, routeName) = items[i];
          return InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Navigator.pushNamed(context, routeName),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: cs.primary.withValues(alpha: .12),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: cs.primary),
                ),
                const SizedBox(height: 6),
                Text(label, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
          );
        },
      ),
    );
  }
}
