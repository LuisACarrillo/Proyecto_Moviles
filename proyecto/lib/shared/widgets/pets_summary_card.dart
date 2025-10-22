import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';
import 'package:proyecto/features/pets/pet_profile_screen.dart'; // PetProfileArgs
import 'package:proyecto/routes/app_routes.dart';

class PetSummaryCard extends StatelessWidget {
  const PetSummaryCard({
    super.key,
    this.name = "Milo",
    this.ageYears = 2,
    this.nextVaccine = "12 Oct",
  });

  final String name;
  final int ageYears;
  final String nextVaccine;

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
                Text("$name ($ageYears años)",
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    )),
                const SizedBox(height: 2),
                Text("Próx. vacuna: $nextVaccine",
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
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.petProfile,
                  arguments: PetProfileArgs(
                    name: name,
                    ageYears: ageYears,
                    nextVaccine: nextVaccine,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
