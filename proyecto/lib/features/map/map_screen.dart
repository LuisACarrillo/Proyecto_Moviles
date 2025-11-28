import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;

  static const LatLng _center = LatLng(20.609055, -103.4145943);

  String? _darkMapStyle;
  String? _lightMapStyle;

  @override
  void initState() {
    super.initState();
    _loadMapStyles();
  }

  Future<void> _loadMapStyles() async {
    _darkMapStyle = await rootBundle.loadString('assets/map_styles/dark.json');
    _lightMapStyle = await rootBundle.loadString(
      'assets/map_styles/light.json',
    );
    setState(() {});
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final String? style = isDark ? _darkMapStyle : _lightMapStyle;

    return Scaffold(
      body: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: _center,
          zoom: 16.0,
        ),
        style: style,
        myLocationButtonEnabled: true,
        zoomControlsEnabled: true,
      ),
    );
  }
}
