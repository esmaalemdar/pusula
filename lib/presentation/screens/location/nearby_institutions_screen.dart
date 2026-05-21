// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Yakınımdaki Kurumlar Ekranı (GPS & Harita)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pusula/core/theme/app_colors.dart';

class InstitutionModel {
  final String id;
  final String name;
  final String type; // Adliye, Belediye, Nüfus
  final LatLng location;
  final String workingHours;
  final String phone;
  final String address;

  InstitutionModel({
    required this.id,
    required this.name,
    required this.type,
    required this.location,
    required this.workingHours,
    required this.phone,
    required this.address,
  });
}

class NearbyInstitutionsScreen extends StatefulWidget {
  const NearbyInstitutionsScreen({super.key});

  @override
  State<NearbyInstitutionsScreen> createState() => _NearbyInstitutionsScreenState();
}

class _NearbyInstitutionsScreenState extends State<NearbyInstitutionsScreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  InstitutionModel? _selectedInstitution;
  
  // Örnek Kurum Verileri (Mock)
  final List<InstitutionModel> _mockInstitutions = [
    InstitutionModel(
      id: '1',
      name: 'Ankara Adliyesi',
      type: 'Adliye',
      location: const LatLng(39.9334, 32.8597),
      workingHours: '08:30 - 17:00',
      phone: '0312 417 77 77',
      address: 'Hacı Bayram, Türkocağı Cd. No:1, 06050 Altındağ/Ankara',
    ),
    InstitutionModel(
      id: '2',
      name: 'Çankaya Nüfus Müdürlüğü',
      type: 'Nüfus Müdürlüğü',
      location: const LatLng(39.9208, 32.8541),
      workingHours: '08:30 - 16:30',
      phone: '0312 433 33 33',
      address: 'Kızılay, 06420 Çankaya/Ankara',
    ),
    InstitutionModel(
      id: '3',
      name: 'Ankara Büyükşehir Belediyesi',
      type: 'Belediye',
      location: const LatLng(39.9413, 32.8545),
      workingHours: '09:00 - 17:30',
      phone: 'ALO 153',
      address: 'Emniyet, Hipodrom Cd. No:5, 06330 Yenimahalle/Ankara',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  /// GPS Konumunu Al
  Future<void> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) return;
    }
    
    final position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });

    _mapController?.animateCamera(
      CameraUpdate.newLatLng(LatLng(position.latitude, position.longitude)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yakınımdaki Kurumlar"),
        backgroundColor: Theme.of(context).cardColor,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        elevation: 0.5,
      ),
      body: Stack(
        children: [
          // 1. Google Maps & Placeholder
          _currentPosition == null 
            ? _buildMapPlaceholder()
            : GoogleMap(
                initialCameraPosition: const CameraPosition(
                  target: LatLng(39.9334, 32.8597),
                  zoom: 13,
                ),
                onMapCreated: (controller) => _mapController = controller,
                markers: _buildMarkers(),
                myLocationEnabled: true,
                myLocationButtonEnabled: true,
                zoomControlsEnabled: false,
              ),

          // Google Maps API Bilgilendirme (Geliştirici Notu)
          if (_currentPosition != null)
            Positioned(
              top: 80,
              left: 20,
              right: 20,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(color: Colors.black54, borderRadius: BorderRadius.circular(8)),
                child: const Text(
                  "Not: Haritanın tam yüklenmesi için Google Cloud API Key yapılandırması gereklidir.",
                  style: TextStyle(color: Colors.white, fontSize: 10),
                  textAlign: TextAlign.center,
                ),
              ),
            ),

          // 2. Filtreleme Chip'leri
          Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  _buildFilterChip("Adliyeler", Icons.gavel_rounded),
                  _buildFilterChip("Nüfus Md.", Icons.badge_outlined),
                  _buildFilterChip("Belediyeler", Icons.account_balance_outlined),
                ],
              ),
            ),
          ),

          // 3. Seçili Kurum Detay Kartı
          if (_selectedInstitution != null)
            Positioned(
              bottom: 30,
              left: 20,
              right: 20,
              child: _buildInstitutionDetailCard(),
            ),
        ],
      ),
    );
  }

  Widget _buildMapPlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        image: const DecorationImage(
          image: NetworkImage("https://images.unsplash.com/photo-1569336415962-a4bd9f6dfc0f?q=80&w=2070&auto=format&fit=crop"),
          fit: BoxFit.cover,
          opacity: 0.5,
        ),
      ),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.accent),
            SizedBox(height: 16),
            Text("Konum alınıyor ve harita yükleniyor...", style: TextStyle(color: AppColors.text600, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return _mockInstitutions.map((inst) {
      return Marker(
        markerId: MarkerId(inst.id),
        position: inst.location,
        onTap: () => setState(() => _selectedInstitution = inst),
        infoWindow: InfoWindow(title: inst.name),
      );
    }).toSet();
  }

  Widget _buildFilterChip(String label, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: ActionChip(
        avatar: Icon(icon, size: 16, color: AppColors.accent),
        label: Text(label, style: const TextStyle(fontSize: 12)),
        backgroundColor: Theme.of(context).cardColor,
        onPressed: () {
          debugPrint('Floating action button tapped');
        },
      ),
    );
  }

  Widget _buildInstitutionDetailCard() {
    final inst = _selectedInstitution!;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(inst.type.toUpperCase(), style: const TextStyle(color: AppColors.accent, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 1)),
              IconButton(onPressed: () => setState(() => _selectedInstitution = null), icon: const Icon(Icons.close, size: 18)),
            ],
          ),
          Text(inst.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.text900)),
          const SizedBox(height: 12),
          _buildDetailRow(Icons.schedule_outlined, "Çalışma Saatleri: ${inst.workingHours}"),
          _buildDetailRow(Icons.phone_outlined, "İletişim: ${inst.phone}"),
          _buildDetailRow(Icons.location_on_outlined, inst.address, maxLines: 2),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    debugPrint('Get directions tapped');
                  },
                  icon: const Icon(Icons.directions_outlined, color: Colors.white),
                  label: const Text("Yol Tarifi", style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(backgroundColor: AppColors.accent, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                decoration: BoxDecoration(color: Theme.of(context).scaffoldBackgroundColor, borderRadius: BorderRadius.circular(12)),
                child: IconButton(onPressed: () { debugPrint('Call institution tapped'); }, icon: const Icon(Icons.phone_callback_outlined, color: AppColors.accent)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text, {int maxLines = 1}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 16, color: AppColors.text400),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: const TextStyle(fontSize: 13, color: AppColors.text600), maxLines: maxLines, overflow: TextOverflow.ellipsis)),
        ],
      ),
    );
  }
}



