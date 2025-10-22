import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';

class PetSummaryCard extends StatelessWidget {
  const PetSummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return CustomCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: cs.primary.withValues(alpha: .12),
            child: Icon(Icons.pets, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Milo (2 años)",
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    )),
                const SizedBox(height: 2),
                Text("Próx. vacuna: 12 Oct",
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    )),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: SecondaryButton(
              text: "Ver perfil",
              onPressed: () {},
            ),
          ),
        ],
      ),
    );
  }
}
