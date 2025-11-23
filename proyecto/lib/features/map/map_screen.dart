import 'package:flutter/material.dart';
import 'package:proyecto/features/home/widgets/next_appointment_card.dart';
import 'package:proyecto/features/home/widgets/doctor_carousel.dart';
import 'package:proyecto/theme/app_colors.dart';
import 'package:proyecto/main.dart' show themeController;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;

  final LatLng _center = const LatLng(45.521563, -122.677433);

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

 @override
  Widget build(BuildContext context) {

    final textTheme = Theme.of(context).textTheme;
    final cs = Theme.of(context).colorScheme;

    return MaterialApp(
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.green[700],
      ),
      home: Scaffold(
        body: GoogleMap(
          onMapCreated: _onMapCreated,
          initialCameraPosition: CameraPosition(
            target: _center,
            zoom: 11.0,
          ),
        ),
      ),
    );
  }
}
