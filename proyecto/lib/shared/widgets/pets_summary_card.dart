import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';
import 'package:proyecto/features/pets/pet_edit_screen.dart';
import 'package:proyecto/routes/app_routes.dart';

class PetSummaryCard extends StatelessWidget {
  const PetSummaryCard({
    super.key,
    required this.petDocId,
    required this.userPath,
    this.name,
    this.ageYears,
    this.nextVaccine,
    this.breed,
    this.species,
    this.imageUrl,
  });

  final String petDocId;
  final String userPath;
  final String? name;
  final int? ageYears;
  final String? nextVaccine;
  final String? breed;
  final String? species;
  final String? imageUrl;

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
            child: imageUrl != null
                ? ClipOval(
                    child: Image.network(
                      imageUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) =>
                          Icon(Icons.pets, color: cs.primary),
                    ),
                  )
                : Icon(Icons.pets, color: cs.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${name ?? 'Mascota'} (${ageYears ?? 0} años)",
                    style: tt.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: cs.onSurface,
                    )),
                const SizedBox(height: 2),
                Text("Próx. vacuna: ${nextVaccine ?? 'No registrada'}",
                    style: tt.bodySmall?.copyWith(
                      color: cs.onSurfaceVariant,
                    )),
              ],
            ),
          ),
          SizedBox(
            width: 120,
            child: SecondaryButton(
              text: "Editar",
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  AppRoutes.petEdit,
                  arguments: PetEditArgs(
                    petDocId: petDocId,
                    userPath: userPath,
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
