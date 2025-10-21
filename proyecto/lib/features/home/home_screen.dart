import 'package:flutter/material.dart';
import 'package:proyecto/features/home/doctor_profile.dart';
import 'package:proyecto/features/home/home_page.dart';
import 'package:proyecto/features/home/widgets/next_appointment_card.dart';
import 'package:proyecto/features/home/widgets/doctor_carousel.dart';
import 'package:proyecto/features/map/map_screen.dart';
import 'package:proyecto/features/users/users_screen.dart';
import 'package:proyecto/shared/widgets/app_bottom.dart';
import 'package:proyecto/theme/app_colors.dart';
import 'package:proyecto/main.dart' show themeController;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 1;

  final List<String> _titles = [
    'Mapa',
    'Inicio',
    'Perfil',
  ];

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        elevation: 0,
        // Title changes with selected tab:
        title: Text(
          _titles[_currentIndex],
          style: textTheme.titleLarge?.copyWith(
            color: AppColors.primaryGreen,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        // Show back button only when the navigator can pop
        leading: Navigator.of(context).canPop() ? const BackButton() : null,
        actions: [
          AnimatedBuilder(
            animation: themeController,
            builder: (context, _) {
              return Row(
                children: [
                  const Icon(
                    Icons.wb_sunny_outlined,
                    color: AppColors.accentGold,
                  ),
                  Switch.adaptive(
                    value: themeController.isDark,
                    onChanged: themeController.setDark,
                    activeColor: AppColors.primaryGreen,
                    inactiveThumbColor: AppColors.accentGold,
                  ),
                  const Icon(
                    Icons.nights_stay_outlined,
                    color: AppColors.primaryGreen,
                  ),
                  const SizedBox(width: 8),
                ],
              );
            },
          ),
        ],
      ),
      // Use IndexedStack to preserve pages' state
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          MapScreen(),
          HomePage(),
          UserScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int index) {
          setState(() {
            _currentIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(icon: Icon(Icons.location_pin), label: "Mapa"),
          NavigationDestination(icon: Icon(Icons.home), label: "Home"),
          NavigationDestination(icon: Icon(Icons.person), label: "Perfil"),
        ],
      ),
    );
  }
}
