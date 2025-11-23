import 'package:flutter/material.dart';
import 'package:proyecto/theme/app_colors.dart';

class DoctorReviewArgs {
  final String vetName;
  final String? vetImageUrl;
  final String? appointmentId;
  const DoctorReviewArgs({
    required this.vetName,
    this.vetImageUrl,
    this.appointmentId,
  });
}

class DoctorReviewScreen extends StatefulWidget {
  final String? vetName;
  final String? vetImageUrl;
  final String? appointmentId;

  const DoctorReviewScreen({
    super.key,
    this.vetName,
    this.vetImageUrl,
    this.appointmentId,
  });

  @override
  State<DoctorReviewScreen> createState() => _DoctorReviewScreenState();
}

class _DoctorReviewScreenState extends State<DoctorReviewScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _reviewController = TextEditingController();
  int _rating = 0;
  bool _submitting = false;

  late String _vetName;
  String? _vetImageUrl;
  String? _appointmentId;
  bool _loadedArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_loadedArgs) return;

    final args = ModalRoute.of(context)?.settings.arguments as DoctorReviewArgs?;
    _vetName = args?.vetName ?? widget.vetName ?? 'Veterinario';
    _vetImageUrl = args?.vetImageUrl ?? widget.vetImageUrl;
    _appointmentId = args?.appointmentId ?? widget.appointmentId;
    _loadedArgs = true;
  }

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  void _setRating(int value) => setState(() => _rating = value);

  Future<void> _submit() async {
    if (_rating == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Por favor selecciona una calificación.')),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    await Future.delayed(const Duration(milliseconds: 700));

    setState(() => _submitting = false);

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Reseña enviada. ¡Gracias!')),
    );
    Navigator.of(context).pop();
  }

  Widget _buildStar(int index) {
    final filled = index <= _rating;
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      onPressed: () => _setRating(index),
      icon: Icon(
        filled ? Icons.star : Icons.star_border,
        color: filled ? AppColors.accentGold : Theme.of(context).colorScheme.onSurfaceVariant,
        size: 32,
      ),
      tooltip: '$index estrellas',
    );
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          'Escribir reseña',
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Vet header
              Row(
                children: [
                  Container(
                    width: 84,
                    height: 84,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.accentGold, width: 2),
                    ),
                    child: ClipOval(
                      child: _vetImageUrl != null
                          ? Image.network(_vetImageUrl!, fit: BoxFit.cover)
                          : Icon(Icons.medical_services, color: AppColors.primaryGreen, size: 48),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _vetName,
                          style: textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: cs.onSurface,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _appointmentId != null ? 'Cita: $_appointmentId' : 'Última cita reciente',
                          style: textTheme.bodyMedium?.copyWith(color: cs.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Rating
              Text(
                'Calificación',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                children: List.generate(5, (i) => _buildStar(i + 1)),
              ),

              const SizedBox(height: 20),

              // Review form
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Escribe tu reseña',
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: cs.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _reviewController,
                      maxLines: 6,
                      maxLength: 500,
                      style: textTheme.bodyMedium?.copyWith(color: cs.onSurface),
                      decoration: InputDecoration(
                        hintText: 'Cuenta tu experiencia con el doctor...',
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                      ),
                      validator: (v) {
                        if (v == null || v.trim().length < 10) {
                          return 'Escribe al menos 10 caracteres.';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _submitting ? null : _submit,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: _submitting
                            ? const SizedBox(height: 18, width: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                            : Text('Enviar reseña', style: textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}