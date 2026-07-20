// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Kurum Harita Ekranı (GPS & Yönlendirme)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:pusula/data/services/settings_controller.dart';

class InstitutionMapScreen extends StatefulWidget {
  final String institutionName;
  final String address;

  const InstitutionMapScreen({
    super.key,
    required this.institutionName,
    required this.address,
  });

  @override
  State<InstitutionMapScreen> createState() => _InstitutionMapScreenState();
}

class _InstitutionMapScreenState extends State<InstitutionMapScreen> {
  GoogleMapController? _controller;
  
  // Mock Hedef Konumu
  final LatLng _destination = const LatLng(41.0664, 28.9806);
  LatLng? _userLocation;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb) _getUserLocation();
  }

  Future<void> _getUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
      _fitBounds();
    } catch (e) {
      debugPrint("Konum alınamadı: $e");
    }
  }

  void _fitBounds() {
    if (_controller == null || _userLocation == null) return;
    final bounds = _calculateBounds(_userLocation!, _destination);
    _controller!.animateCamera(CameraUpdate.newLatLngBounds(bounds, 50));
  }

  LatLngBounds _calculateBounds(LatLng p1, LatLng p2) {
    final southwest = LatLng(
      p1.latitude < p2.latitude ? p1.latitude : p2.latitude,
      p1.longitude < p2.longitude ? p1.longitude : p2.longitude,
    );
    final northeast = LatLng(
      p1.latitude > p2.latitude ? p1.latitude : p2.latitude,
      p1.longitude > p2.longitude ? p1.longitude : p2.longitude,
    );
    return LatLngBounds(southwest: southwest, northeast: northeast);
  }

  @override
  Widget build(BuildContext context) {
    final settings = Provider.of<SettingsController>(context);

    return Scaffold(
      appBar: AppBar(title: Text(settings.translate(widget.institutionName)), backgroundColor: Theme.of(context).cardColor, foregroundColor: Theme.of(context).textTheme.bodyLarge?.color),
      body: kIsWeb 
        ? Center(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.map_rounded, size: 80, color: AppColors.accent),
                  const SizedBox(height: 20),
                  Text(settings.translate('map_unavailable'), style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 10),
                  Text(
                    settings.translate('google_maps_web_warning'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 30),
                  Text(widget.address, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ),
          )
        : Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(target: _destination, zoom: 15),
                onMapCreated: (controller) {
                  _controller = controller;
                  if (_userLocation != null) _fitBounds();
                },
                markers: {
                  Marker(markerId: const MarkerId('dest'), position: _destination, infoWindow: InfoWindow(title: settings.translate(widget.institutionName))),
                  if (_userLocation != null)
                    Marker(markerId: const MarkerId('user'), position: _userLocation!, icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure), infoWindow: InfoWindow(title: settings.translate("your_location"))),
                },
                myLocationEnabled: true,
              ),
              Positioned(
                bottom: 20, left: 20, right: 20,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(16), boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 10)]),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(widget.address, style: const TextStyle(fontSize: 13, color: AppColors.text600), textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: _fitBounds,
                        icon: const Icon(Icons.zoom_out_map_rounded, color: Colors.white),
                        label: Text(settings.translate('show_route'), style: const TextStyle(color: Colors.white)),
                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
    );
  }
}




