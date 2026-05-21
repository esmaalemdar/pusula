// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Akıllı Belge Tarama Modülü
// ═══════════════════════════════════════════════════════════════════════════

import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';

class DocumentScannerScreen extends StatefulWidget {
  const DocumentScannerScreen({super.key});

  @override
  State<DocumentScannerScreen> createState() => _DocumentScannerScreenState();
}

class _DocumentScannerScreenState extends State<DocumentScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _scanController;
  bool _isScanning = false;
  bool _showResultForm = false;

  // Çıkarılan Mock Veriler
  final _dateController = TextEditingController();
  final _amountController = TextEditingController();
  final _typeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _scanController.dispose();
    super.dispose();
  }

  // ── Mock OCR Fonksiyonu (Veri Çıkarma Simülasyonu) ──
  void _processDocument() async {
    setState(() => _isScanning = true);
    
    // AI İşleme Simülasyonu
    await Future.delayed(const Duration(seconds: 3));

    if (!mounted) return;

    setState(() {
      _isScanning = false;
      _showResultForm = true;
      // Mock verileri doldur
      _dateController.text = "12.05.2024";
      _amountController.text = "15.500 ₺";
      _typeController.text = "Kira Sözleşmesi";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Kamera Görünümü (Placeholder)
          Positioned.fill(
            child: Image.network(
              "https://images.unsplash.com/photo-1586281380349-632531db7ed4?q=80&w=2070&auto=format&fit=crop",
              fit: BoxFit.cover,
            ),
          ),

          // 2. iOS Tarzı Şeffaf Overlay
          _buildScannerOverlay(),

          // 3. Tarama Animasyonu (Lazer Çizgisi)
          if (_isScanning) _buildScanningLine(),

          // 4. Alt Kontroller
          _buildBottomControls(),

          // 5. Onay Formu (BottomSheet Tarzı)
          if (_showResultForm) _buildConfirmationForm(),
        ],
      ),
    );
  }

  Widget _buildScannerOverlay() {
    return Positioned.fill(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: _isScanning ? 2 : 0, sigmaY: _isScanning ? 2 : 0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
          ),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.8,
              height: MediaQuery.of(context).size.height * 0.6,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white.withOpacity(0.5), width: 2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Stack(
                children: [
                  _buildCorner(top: 0, left: 0),
                  _buildCorner(top: 0, right: 0, isRight: true),
                  _buildCorner(bottom: 0, left: 0, isBottom: true),
                  _buildCorner(bottom: 0, right: 0, isRight: true, isBottom: true),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScanningLine() {
    return AnimatedBuilder(
      animation: _scanController,
      builder: (context, child) {
        return Positioned(
          top: MediaQuery.of(context).size.height * 0.2 + (MediaQuery.of(context).size.height * 0.6 * _scanController.value),
          left: MediaQuery.of(context).size.width * 0.1,
          right: MediaQuery.of(context).size.width * 0.1,
          child: Container(
            height: 3,
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(color: AppColors.accent.withOpacity(0.8), blurRadius: 15, spreadRadius: 2),
              ],
              gradient: LinearGradient(
                colors: [Colors.transparent, AppColors.accent, Colors.transparent],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 50,
      left: 0,
      right: 0,
      child: Column(
        children: [
          if (!_isScanning && !_showResultForm)
            GestureDetector(
              onTap: _processDocument,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 4),
                ),
                child: Center(
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                  ),
                ),
              ),
            ),
          const SizedBox(height: 20),
          const Text("Belgeyi Çerçevenin İçine Hizalayın", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildConfirmationForm() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Veriler Çıkarıldı", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.text900)),
            const SizedBox(height: 4),
            const Text("Lütfen otomatik tespit edilen bilgileri onaylayın.", style: TextStyle(color: AppColors.text600)),
            const SizedBox(height: 24),
            _buildResultField("Belge Türü", _typeController),
            _buildResultField("Sözleşme Tarihi", _dateController),
            _buildResultField("Bedel / Tutar", _amountController),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                ),
                child: const Text("Bilgileri Onayla ve Kaydet"),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: AppColors.background,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildCorner({double? top, double? bottom, double? left, double? right, bool isRight = false, bool isBottom = false}) {
    return Positioned(
      top: top,
      bottom: bottom,
      left: left,
      right: right,
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          border: Border(
            top: !isBottom ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
            bottom: isBottom ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
            left: !isRight ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
            right: isRight ? const BorderSide(color: Colors.white, width: 4) : BorderSide.none,
          ),
        ),
      ),
    );
  }
}



