import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';

class HomeSearch extends StatelessWidget {
  const HomeSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return CustomCard(
      padding: const EdgeInsets.all(12),
      child: AppTextField(
        controller: controller,
        label: 'Buscar',
        hint: 'Veterinarios, grooming, alimentos…',
        icon: Icons.search,
      ),
    );
  }
}
