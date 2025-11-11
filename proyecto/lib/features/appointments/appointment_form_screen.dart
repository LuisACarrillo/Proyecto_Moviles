import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';

class AppointmentArgs {
  final String petName;
  final String? defaultReason;
  const AppointmentArgs({required this.petName, this.defaultReason});
}

class AppointmentFormScreen extends StatefulWidget {
  const AppointmentFormScreen({super.key});

  @override
  State<AppointmentFormScreen> createState() => _AppointmentFormScreenState();
}

class _AppointmentFormScreenState extends State<AppointmentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _petCtrl = TextEditingController();
  final _reasonCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  String _service = 'Consulta general';

  bool _loadedArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments as AppointmentArgs?;
    if (args != null) {
      _petCtrl.text = args.petName;
      _reasonCtrl.text = args.defaultReason ?? 'Consulta general';
    }
    _loadedArgs = true;
  }

  @override
  void dispose() {
    _petCtrl.dispose();
    _reasonCtrl.dispose();
    _dateCtrl.dispose();
    _timeCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final d = await showDatePicker(
      context: context,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
      initialDate: now.add(const Duration(days: 1)),
      helpText: 'Selecciona la fecha de la cita',
    );
    if (d != null) {
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
      _dateCtrl.text = '${d.day} ${months[d.month - 1]} ${d.year}';
      setState(() {});
    }
  }

  Future<void> _pickTime() async {
    final t = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 10, minute: 0),
      helpText: 'Selecciona la hora',
    );
    if (t != null) {
      final h = t.hour.toString().padLeft(2, '0');
      final m = t.minute.toString().padLeft(2, '0');
      _timeCtrl.text = '$h:$m';
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
          'Agendar cita',
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
                  controller: _petCtrl,
                  label: 'Mascota',
                  hint: 'Nombre de tu mascota',
                  icon: Icons.pets,
                  validator: (v) => (v == null || v.trim().isEmpty)
                      ? 'Ingresa el nombre'
                      : null,
                ),
                const SizedBox(height: 12),

                DropdownButtonFormField<String>(
                  value: _service,
                  isExpanded: true,
                  isDense: true,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 20,
                  decoration: const InputDecoration(
                    labelText: 'Servicio',
                    prefixIcon: Icon(Icons.medical_services_outlined),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 14,
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'Consulta general',
                      child: Text('Consulta general'),
                    ),
                    DropdownMenuItem(
                      value: 'Grooming',
                      child: Text('Grooming'),
                    ),
                    DropdownMenuItem(
                      value: 'Vacunación',
                      child: Text('Vacunación'),
                    ),
                    DropdownMenuItem(value: 'Paseo', child: Text('Paseo')),
                    DropdownMenuItem(
                      value: 'Desparasitación',
                      child: Text('Desparasitación'),
                    ),
                  ],
                  onChanged: (v) =>
                      setState(() => _service = v ?? 'Consulta general'),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _pickDate,
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _dateCtrl,
                      label: 'Fecha',
                      hint: 'Selecciona la fecha',
                      icon: Icons.event,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Selecciona la fecha'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                GestureDetector(
                  onTap: _pickTime,
                  child: AbsorbPointer(
                    child: AppTextField(
                      controller: _timeCtrl,
                      label: 'Hora',
                      hint: 'Selecciona la hora',
                      icon: Icons.schedule,
                      validator: (v) => (v == null || v.isEmpty)
                          ? 'Selecciona la hora'
                          : null,
                    ),
                  ),
                ),
                const SizedBox(height: 12),

                AppTextField(
                  controller: _reasonCtrl,
                  label: 'Motivo',
                  hint: 'Ej. revisión general / limpieza / vacuna…',
                  icon: Icons.note_alt_outlined,
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
                        text: 'Confirmar cita',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Cita agendada')),
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
