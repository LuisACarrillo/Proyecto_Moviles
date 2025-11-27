import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';

class PetEditArgs {
  final String petDocId;
  final String userPath;

  const PetEditArgs({
    required this.petDocId,
    required this.userPath,
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
  bool _isLoading = false;
  String? _petDocId;
  String? _userPath;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments as PetEditArgs?;
    if (args != null) {
      _petDocId = args.petDocId;
      _userPath = args.userPath;
      _loadPetData();
    }
    _loadedArgs = true;
  }

  Future<void> _loadPetData() async {
    if (_petDocId == null || _userPath == null) return;

    setState(() => _isLoading = true);
    try {
      final doc = await FirebaseFirestore.instance
          .collection('mascotas')
          .doc(_petDocId)
          .get();

      if (doc.exists) {
        final data = doc.data() as Map<String, dynamic>;
        _nameCtrl.text = data['nombre'] ?? '';
        _ageCtrl.text = (data['edad'] ?? 0).toString();
        _breedCtrl.text = data['raza'] ?? '';
        _species = data['especie'] ?? 'Perro';

        final Timestamp? vaccineTimestamp = data['proxima_vacuna'];
        if (vaccineTimestamp != null) {
          final date = vaccineTimestamp.toDate();
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
              '${date.day} ${months[date.month - 1]} ${date.year}';
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al cargar datos: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
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

  Future<void> _savePet() async {
    if (!_formKey.currentState!.validate() || _petDocId == null) return;

    setState(() => _isLoading = true);
    try {
      // Parse vaccine date back to Timestamp
      DateTime? vaccineDate;
      if (_nextVaccineCtrl.text.isNotEmpty) {
        try {
          // Simple parsing for "day month year" format
          final parts = _nextVaccineCtrl.text.split(' ');
          if (parts.length == 3) {
            final day = int.parse(parts[0]);
            final monthMap = {
              'Ene': 1, 'Feb': 2, 'Mar': 3, 'Abr': 4, 'May': 5, 'Jun': 6,
              'Jul': 7, 'Ago': 8, 'Sep': 9, 'Oct': 10, 'Nov': 11, 'Dic': 12,
            };
            final month = monthMap[parts[1]] ?? 1;
            final year = int.parse(parts[2]);
            vaccineDate = DateTime(year, month, day);
          }
        } catch (e) {
          // If parsing fails, use current date
          vaccineDate = DateTime.now();
        }
      }

      await FirebaseFirestore.instance
          .collection('mascotas')
          .doc(_petDocId)
          .update({
        'nombre': _nameCtrl.text,
        'edad': int.parse(_ageCtrl.text),
        'raza': _breedCtrl.text,
        'especie': _species,
        'proxima_vacuna': vaccineDate != null ? Timestamp.fromDate(vaccineDate) : null,
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mascota actualizada')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      setState(() => _isLoading = false);
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
      body: _isLoading && !_loadedArgs
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
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
                              onPressed: _isLoading ? null : _savePet,
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
