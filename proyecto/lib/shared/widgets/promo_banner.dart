import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';

class PromoBanner extends StatelessWidget {
  const PromoBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CustomCard(
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.local_offer, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "10% de descuento en tu próximo grooming este mes",
              style: tt.bodyMedium?.copyWith(
                color: cs.onSurface,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          SizedBox(
            width: 130,
            child: PrimaryButton(
              text: "Aprovechar",
              onPressed: () {
                const SnackBar(content: Text('Aqui se verá la oferta'));
              },
            ),
          ),
        ],
      ),
    );
  }
}
