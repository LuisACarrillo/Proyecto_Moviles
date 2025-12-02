import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/routes/app_routes.dart';
import 'package:proyecto/features/store/disccount.dart';

class PromoBanner extends StatefulWidget {
  const PromoBanner({super.key});

  @override
  State<PromoBanner> createState() => _PromoBannerState();
}

class _PromoBannerState extends State<PromoBanner> {
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
              "10% de descuento en tu próxima compra",
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
                    DiscountState.activar();   // ⬅ activa el descuento
                    Navigator.pushNamed(context, AppRoutes.storeDemo);
                  },

             
            ),
          ),
        ],
      ),
    );
  }
}
