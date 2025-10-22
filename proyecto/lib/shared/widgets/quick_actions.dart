import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    const items = [
      (Icons.cut, "Grooming"),
      (Icons.local_hospital_outlined, "Veterinario"),
      (Icons.pets, "Paseo"),
      (Icons.store_outlined, "Tienda"),
    ];

    return CustomCard(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4, mainAxisSpacing: 8, crossAxisSpacing: 4,
        ),
        itemBuilder: (_, i) {
          final (icon, label) = items[i];
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 44, height: 44,
                decoration: BoxDecoration(
                  color: cs.primary.withValues(alpha: .12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: cs.primary),
              ),
              const SizedBox(height: 6),
              Text(label, style: Theme.of(context).textTheme.bodySmall),
            ],
          );
        },
      ),
    );
  }
}
