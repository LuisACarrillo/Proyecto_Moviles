import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PetCreateArgs {
  final String userPath;
  const PetCreateArgs({required this.userPath});
}

class PetCreateScreen extends StatefulWidget {
  const PetCreateScreen({super.key});

  @override
  State<PetCreateScreen> createState() => _PetCreateScreenState();
}

class _PetCreateScreenState extends State<PetCreateScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _ageCtrl = TextEditingController();
  final _breedCtrl = TextEditingController();
  final _nextVaccineCtrl = TextEditingController();
  String _species = 'Perro';
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _userPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as PetCreateArgs?;
    if (args != null) {
      _userPath = args.userPath;
    }
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
      firstDate: now,
      lastDate: now.add(const Duration(days: 365 * 3)),
      initialDate: now,
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _nextVaccineCtrl.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _saveMascota() async {
    if (!_formKey.currentState!.validate() || _userPath == null) return;

    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('mascotas').add({
        'nombre': _nameCtrl.text.trim(),
        'especie': _species,
        'raza': _breedCtrl.text.trim(),
        'edad': int.parse(_ageCtrl.text.trim()),
        'dueno': FirebaseFirestore.instance.doc(_userPath!), 
        'proxima_vacuna': _selectedDate != null ? Timestamp.fromDate(_selectedDate!) : null,
        'creado_en': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Mascota creada')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      if (mounted) setState(() => _isLoading = false);
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
          'Agregar mascota',
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
                          _saveMascota();
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Mascota agregada'),
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
