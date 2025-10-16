import 'package:flutter/material.dart';
import 'package:proyecto/features/home/doctor_profile.dart';
import 'package:proyecto/theme/app_colors.dart';

void main() => runApp(const NextAppointmentScreen());

class NextAppointmentScreen extends StatelessWidget {
  const NextAppointmentScreen({super.key});

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
          "Tu próxima cita",
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Viernes 5 de septiembre",
                      style: textTheme.titleLarge?.copyWith(
                        color: cs.primary,
                        fontWeight: FontWeight.bold,
                      )),
                    Text(
                      "Calle 236, Col. Producción",
                      style: textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    Text(
                      "Motivo",
                      style: textTheme.bodyLarge?.copyWith(color: cs.onSurfaceVariant),
                    ),
                    GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const DoctorProfile()));
                        },
                        child: Text(
                          'Doctor',
                          style: textTheme.bodyLarge?.copyWith(
                            color: cs.onSurfaceVariant,
                          ),
                        ),
                      ),
                  ],
                )
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                        width: 2.0
                      )
                    ),
                    width: 300,
                    child: Image.network("https://i.blogs.es/af3666/google-maps-aniversario-nuevo-logo/650_1200.png"),

                  ),
                )
              ],
            ),
            SizedBox(
              height: 50,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement scheduling logic
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Cancelar cita",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 20,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    // TODO: Implement scheduling logic
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Text(
                      "Reagendar cita",
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
    );
  }
}