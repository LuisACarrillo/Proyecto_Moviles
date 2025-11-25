import 'package:flutter/material.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/app_text_field.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/shared/widgets/secondary_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


import 'package:proyecto/firestore_service.dart';


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
  String? _walker_ ;
  String _doctor = '';
  

  List<String> doctors = [
    'Dr. House',
    'Dra. Meredith Grey',
    'Dr. Strange',
    'No seleccionar', // opcional
  ];
  List<String> walkers = [
  'Cristiano Ronaldo',
  'Iker Casillas',
  'Luis Miguel',
  'No seleccionar',
  ];
  bool _loadingWalkers = true;

  bool _loadingDoctors = true;
  final FirestoreService fs = FirestoreService();
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
    _loadDoctors(); 
    _loadWalkers();
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
                 DropdownButtonFormField<String>(
                  value: _doctor.isEmpty ? null : _doctor,
                  isExpanded: true,
                  isDense: true,
                  hint: const Text("Selecciona un doctor"),
                  icon: const Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 20,
                  decoration: const InputDecoration(
                    labelText: 'Doctor',
                    prefixIcon: Icon(Icons.local_hospital_outlined),
                    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  ),
                  items: _loadingDoctors
                  ? [const DropdownMenuItem(value: 'cargando', child: Text('Cargando...'))]
                  : doctors.map((doc) => DropdownMenuItem(
                      value: doc,
                      child: Text(doc),
                    )).toList(),

                  onChanged: (v) => setState(() => _doctor = v ?? ''),
                  dropdownColor: Theme.of(context).colorScheme.surface,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),


                const SizedBox(height: 12),

DropdownButtonFormField<String>(
  value: _walker_,
  isExpanded: true,
  isDense: true,
  hint: const Text("Selecciona un paseador"),
  icon: const Icon(Icons.keyboard_arrow_down_rounded),
  iconSize: 20,
  decoration: const InputDecoration(
    labelText: 'Paseador',
    prefixIcon: Icon(Icons.person_outline),
    contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 14),
  ),
  items: _loadingWalkers
      ? [const DropdownMenuItem(value: null, child: Text('Cargando...'))]
      : walkers.map((walker) => DropdownMenuItem(
            value: walker,
            child: Text(walker),
          )).toList(),
  onChanged: (v) => setState(() => _walker_ = v),
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
                      // child: PrimaryButton(
                      //   text: 'Confirmar cita',
                      //   onPressed: () {
                      //     if (_formKey.currentState!.validate()) {
                      //       ScaffoldMessenger.of(context).showSnackBar(
                      //         const SnackBar(content: Text('Cita agendada')),
                      //       );
                      //       Navigator.pop(context);
                      //     }
                      //   },
                      // ),
                          child: PrimaryButton(
                            text: 'Confirmar cita',
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                _crearCita(); // aquí llamamos a la función global que guarda en Firestore
                              }
                            },
                          )
                        ,
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

    Future<void> _crearCita() async {
      try {
        final docRef = FirebaseFirestore.instance.collection('citas').doc(); // ID automático
        final idGenerado = docRef.id;

        final citaData = {
          'id': idGenerado,
          'petName': _petCtrl.text.trim(),
          'service': _service,
          'walker': _walker_,
          'doctor': _doctor.isEmpty ? null : _doctor,
          'date': _dateCtrl.text.trim(),
          'time': _timeCtrl.text.trim(),
          'reason': _reasonCtrl.text.trim(),
        };

        await docRef.set(citaData);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Cita creada con éxito. ID: $idGenerado')),
        );
        Navigator.pop(context);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al crear la cita: $e')),
        );
      }
    }


Future<void> _loadDoctors() async {
  setState(() => _loadingDoctors = true); // marcamos cargando
  try {
    final snapshot = await FirebaseFirestore.instance.collection('doctores').get();

   // print('Docs recibidos de Firestore: ${snapshot.docs.length}');
   // for (var doc in snapshot.docs) {
     // print('Doctor: ${doc.data()}');
   // }

    if (snapshot.docs.isNotEmpty) {
      final fetchedDoctors = snapshot.docs
          .map((doc) => doc['Nombre'] as String)
          .toList();
      setState(() {
        doctors = fetchedDoctors;
        _loadingDoctors = false;
      });
    } else {
      // colección vacía, usamos hardcode
      setState(() {
        doctors = [
          'Dr. House',
          'Dra. Meredith Grey',
          'Dr. Strange',
          'No seleccionar',
        ];
        _loadingDoctors = false;
      });
    }
  } catch (e) {
    // error leyendo la bd, usamos hardcode
    setState(() {
      doctors = [
        'Dr. House',
        'Dra. Meredith Grey',
        'Dr. Strange',
        'No seleccionar',
      ];
      _loadingDoctors = false;
    });
    print('Error cargando doctores: $e');
  }
}

Future<void> _loadWalkers() async {
  setState(() => _loadingWalkers = true);
  try {
    final snapshot = await FirebaseFirestore.instance.collection('paseador').get();

    if (snapshot.docs.isNotEmpty) {
      final fetchedWalkers = snapshot.docs.map((doc) => doc['Nombre'] as String).toList();
      setState(() {
        walkers = fetchedWalkers;
        _loadingWalkers = false;
        _walker_ = null;
      });
    } else {
      // fallback hardcodeado
      setState(() {
        walkers = ['Cristiano Ronaldo', 'Iker Casillas', 'Luis Miguel', 'No seleccionar'];
        _loadingWalkers = false;
        _walker_ = null;
      });
    }
  } catch (e) {
    // error leyendo Firestore, fallback hardcodeado
    setState(() {
      walkers = ['Cristiano Ronaldo', 'Iker Casillas', 'Luis Miguel', 'No seleccionar'];
      _loadingWalkers = false;
      _walker_ = null;
    });
    print('Error cargando paseadores: $e');
  }
}





}
