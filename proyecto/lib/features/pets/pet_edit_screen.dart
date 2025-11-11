import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';

class PetEditArgs {
  final String name;
  final int ageYears;
  final String nextVaccine;
  final String? species;
  final String? breed;

  const PetEditArgs({
    required this.name,
    required this.ageYears,
    required this.nextVaccine,
    this.species,
    this.breed,
  });
}

class PetEditScreen extends StatefulWidget {
  const PetEditScreen({super.key});

  @override
  State<PetEditScreen> createState() => _PetEditScreenState();
}

class _PetEditScreenState extends State<PetEditScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();
  final _nextVaccineCtrl = TextEditingController();
  String _species = 'Perro';

  bool _loadedArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments as PetEditArgs?;
    if (args != null) {
      _nameCtrl.text = args.name;
      _ageCtrl.text = args.ageYears.toString();
      _breedCtrl.text = args.breed ?? '';
      _nextVaccineCtrl.text = args.nextVaccine;
      _species = args.species ?? 'Perro';
    }
    _loadedArgs = true;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _ageCtrl.dispose();
    _breedCtrl.dispose();
    _nextVaccineCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      firstDate: now.subtract(const Duration(days: 365 * 2)),
      lastDate: now.add(const Duration(days: 365 * 3)),
      initialDate: now,
      helpText: 'Selecciona fecha de próxima vacuna',
    );
    if (picked != null) {
      const months = [
        'Ene',
        'Feb',
        'Mar',
        'Abr',
        'May',
        'Jun',
        'Jul',
        'Ago',
        'Sep',
        'Oct',
        'Nov',
        'Dic',
      ];
      _nextVaccineCtrl.text =
          '${picked.day} ${months[picked.month - 1]} ${picked.year}';
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final tt = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          'Editar mascota',
          style: tt.titleLarge?.copyWith(
            color: cs.primary,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: CustomCard(
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AppTextField(
                  controller: _nameCtrl,
                  label: 'Nombre',
                  hint: 'Ej. Milo',
                  icon: Icons.pets,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa el nombre'
                      : null,
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _species,
                  isExpanded: true,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 20,
                  decoration: InputDecoration(
                    labelText: 'Especie',
                    prefixIcon: const Icon(Icons.category_outlined),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'Perro', child: Text('Perro')),
                    DropdownMenuItem(value: 'Gato', child: Text('Gato')),
                    DropdownMenuItem(value: 'Otro', child: Text('Otro')),
                  ],
                  onChanged: (v) => setState(() => _species = v ?? 'Perro'),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 12),

                AppTextField(
                  controller: _breedCtrl,
                  label: 'Raza',
                  hint: 'Ej. Mestizo',
                  icon: Icons.badge_outlined,
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: _ageCtrl,
                  label: 'Edad (años)',
                  hint: 'Ej. 2',
                  icon: Icons.cake_outlined,
                  keyboardType: TextInputType.number,
                  validator: (v) {
                    if (v == null || v.isEmpty) return 'Ingresa la edad';
                    final n = int.tryParse(v);
                    if (n == null || n < 0) return 'Edad inválida';
                    return null;
                  },
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _nextVaccineCtrl,
                      label: 'Próxima vacuna',
                      hint: 'Selecciona una fecha',
                      icon: Icons.vaccines_outlined,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: SecondaryButton(
                        text: 'Cancelar',
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        text: 'Guardar',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Cambios guardados'),
                              ),
                            );
                            Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
