// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Senkronizasyon ve Şifreleme Servisi (Firebase & AES-256)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:encrypt/encrypt.dart' as enc;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart' show Firebase;
import 'package:flutter/foundation.dart';
import '../models/process_model.dart';
import '../models/dilekce_model.dart';

class SyncService {
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;
  
  // Şifreleme Anahtarı (Gerçek projede güvenli bir yerde tutulmalı)
  static final _key = enc.Key.fromUtf8('my_32_char_secret_key_for_pusula');
  static final _iv = enc.IV.fromLength(16);
  static final _encrypter = enc.Encrypter(enc.AES(_key));

  // Veriyi Şifrele
  static String encrypt(String plainText) {
    return _encrypter.encrypt(plainText, iv: _iv).base64;
  }

  // Veriyi Çöz
  static String decrypt(String encryptedText) {
    return _encrypter.decrypt64(encryptedText, iv: _iv);
  }

  // Süreçleri Firebase'e Senkronize Et
  Future<void> syncProcesses(String userId, List<ProcessModel> processes) async {
    // Firebase başlatılmamışsa (örn: web'de options eksikse) sessizce atla
    if (Firebase.apps.isEmpty) {
      debugPrint('[SyncService] Firebase başlatılmadı, süreç senkronizasyonu atlandı.');
      return;
    }
    try {
      final List<Map<String, dynamic>> data = processes.map((p) => {
        'id': p.id,
        'title': encrypt(p.title),
        'status': encrypt(p.status),
        'progress': p.progress,
        'lastUpdate': p.lastUpdate.toIso8601String(),
        'type': p.type,
      }).toList();

      await _firestore.collection('users').doc(userId).collection('processes').doc('sync').set({
        'updatedAt': FieldValue.serverTimestamp(),
        'items': data,
      });
    } catch (e) {
      debugPrint("Süreç Senkronizasyon Hatası: $e");
    }
  }

  // Dilekçeleri Firebase'e Senkronize Et
  Future<void> syncDilekceler(String userId, List<DilekceModel> dilekceler) async {
    // Firebase başlatılmamışsa sessizce atla
    if (Firebase.apps.isEmpty) {
      debugPrint('[SyncService] Firebase başlatılmadı, dilekçe senkronizasyonu atlandı.');
      return;
    }
    try {
      final List<Map<String, dynamic>> data = dilekceler.map((d) => {
        'id': d.id,
        'title': encrypt(d.title),
        'content': encrypt(d.content),
        'createDate': d.createDate.toIso8601String(),
      }).toList();

      await _firestore.collection('users').doc(userId).collection('dilekceler').doc('sync').set({
        'updatedAt': FieldValue.serverTimestamp(),
        'items': data,
      });
    } catch (e) {
      debugPrint("Dilekçe Senkronizasyon Hatası: $e");
    }
  }
}


