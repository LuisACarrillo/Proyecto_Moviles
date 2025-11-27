import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:proyecto/features/appointments/appointment_form_screen.dart';
import 'package:proyecto/features/home/widgets/doctor_carousel.dart';
import 'package:proyecto/features/home/widgets/food_carousel.dart';
import 'package:proyecto/features/reviews/doctor_review.dart';
import 'package:proyecto/routes/app_routes.dart';
import 'package:proyecto/shared/widgets/custom_card.dart';
import 'package:proyecto/shared/widgets/primary_button.dart';
import 'package:proyecto/theme/app_colors.dart';

class VetProfileArgs {
  final String vetId;

  const VetProfileArgs({
    required this.vetId
  });
}

class VetProfile extends StatelessWidget {
  const VetProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    final args = ModalRoute.of(context)?.settings.arguments as VetProfileArgs?;
    final vetId = args?.vetId ?? "";

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: cs.surface,
        elevation: 0,
        title: Text(
          "Información veterinaria",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
        .collection("veterinarias")
        .doc(vetId)
        .snapshots(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || !snapshot.data!.exists) {
          return const Center(child: Text("No se encontró la veterinaria"),);
        }

        final vetData = snapshot.data!.data() as Map<String, dynamic>;
        final nombre = vetData["nombre"] ?? "Veterinaria";
        final direccion = vetData["direccion"] ?? "Sin dirección";
        final telefono = vetData["telefono"] ?? "Sin teléfono";
        final horaApertura = vetData["hora_apertura"] ?? "Horario no establecido";
        final horaCierre = vetData["hora_cierre"] ?? "";

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomCard(
                  child: Column(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: AppColors.primaryGreen,
                        child: Icon(
                          Icons.pets,
                          size: 50,
                          color: AppColors.primaryGreen,
                        ),
                      ),
                      const SizedBox(height: 16,),
                      Text(
                        nombre,
                        style: textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: cs.onSurface
                        ),
                        textAlign: TextAlign.center,
                      )
                    ],
                  )
                ),

                const SizedBox(height: 20,),

                Text(
                  "Contacto",
                  style: textTheme.titleMedium?.copyWith(
                    color: AppColors.primaryGreen,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 12,),

                CustomCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.phone,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Teléfono",
                                  style: textTheme.titleMedium?.copyWith(
                                    color: cs.onSurfaceVariant
                                  ),
                                ),
                                Text(
                                  telefono,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ],
                            )
                          )
                        ],
                      ),
                      const SizedBox(height: 16,),
                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(width: 12,),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Dirección",
                                  style: textTheme.bodySmall?.copyWith(
                                    color: cs.onSurfaceVariant,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text(
                                  direccion,
                                  style: textTheme.bodyMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                    color: cs.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          )
                        ],
                      )
                    ],
                  )
                ),

                const SizedBox(height: 20,),

                Text(
                  "Horario",
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),

                const SizedBox(height: 12,),

                CustomCard(
                  child: Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: AppColors.primaryGreen
                      ),
                      const SizedBox(width: 12,),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "De $horaApertura a $horaCierre",
                              style: textTheme.bodySmall?.copyWith(
                                color: cs.onSurface,
                                fontWeight: FontWeight.w600
                              ),
                            ),

                          ],
                        )
                      )
                    ],
                  )
                ),

                const SizedBox(height: 24,),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    text: "Agendar Cita",
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.appointmentForm,
                        arguments: AppointmentArgs(
                          petName: "",
                          defaultReason: "Consulta General"
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 12,),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)
                      )
                    ),
                    onPressed: () {
                      Navigator.pushNamed(
                        context,
                        AppRoutes.doctorReview,
                        arguments: DoctorReviewArgs(
                          vetName: nombre,
                          appointmentId: "vet-$vetId",
                        )
                      );
                    },
                    child: Text(
                      "Escribir reseña",
                      style: textTheme.titleMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                      ),
                    )
                  ),
                )
              ],
            ),
          ));

      })
    );
  }
}