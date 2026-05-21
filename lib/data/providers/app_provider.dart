// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — App Provider (Merkezi Kontrol Ünitesi)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../services/database_service.dart';
import '../models/process_model.dart';
import '../models/dilekce_model.dart';

import '../services/sync_service.dart';

class AppProvider extends ChangeNotifier {
  final DatabaseService _db = DatabaseService();
  final SyncService _sync = SyncService();
  bool _isOffline = false;
  bool _isLoading = false;

  bool get isOffline => _isOffline;
  bool get isLoading => _isLoading;

  List<ProcessModel> _processes = [];
  List<DilekceModel> _dilekceler = [];

  List<ProcessModel> get processes => _processes;
  List<DilekceModel> get dilekceler => _dilekceler;

  AppProvider() {
    _checkConnectivity();
    _loadInitialData();
  }

  // İnternet Kontrolü
  void _checkConnectivity() {
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _isOffline = results.contains(ConnectivityResult.none);
      notifyListeners();
    });
  }

  // Verileri Yükle (Simüle edilmiş gecikme ile Shimmer testi için)
  Future<void> _loadInitialData() async {
    _isLoading = true;
    notifyListeners();

    // Veritabanı verilerini çek
    _processes = _db.getAllProcesses();
    _dilekceler = _db.getAllDilekceler();

    _isLoading = false;
    notifyListeners();

    // Verileri Firebase ile Senkronize Et (İnternet varsa)
    if (!_isOffline) {
      _sync.syncProcesses('user_123', _processes);
      _sync.syncDilekceler('user_123', _dilekceler);
    }
  }

  // --- Aksiyonlar ---
  
  // Evet/Hayır Cevabını Kaydet
  Future<void> saveUserAnswer(String questionId, bool answer) async {
    // Burada cevapları bir Log veya Süreç içine kaydedebiliriz
    debugPrint("Cevap Kaydedildi: $questionId -> $answer");
    // Örnek: Cevaba göre süreç oluştur
  }

  // Dilekçe Oluştur ve Kaydet
  Future<void> createAndSaveDilekce(String title, String content) async {
    final newDilekce = DilekceModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title,
      content: content,
      createDate: DateTime.now(),
    );
    await _db.saveDilekce(newDilekce);
    _dilekceler = _db.getAllDilekceler();
    notifyListeners();
  }

  // Veri Yenile
  Future<void> refreshData() => _loadInitialData();
}


