// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Yerel Veritabanı Servisi (Hive CRUD)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:hive_flutter/hive_flutter.dart';
import '../models/process_model.dart';
import '../models/dilekce_model.dart';
import '../models/legal_event_model.dart';
import '../models/notification_model.dart';

class DatabaseService {
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  static const String processBoxName       = 'processes';
  static const String dilekceBoxName       = 'dilekceler';
  static const String legalEventBoxName    = 'legal_events';
  static const String notificationBoxName  = 'notifications';
  static const String legalDocsBoxName     = 'legal_documents_box';
  /// Kalıcı kullanıcı kaydı: key = email (küçük harf), value = şifre
  static const String usersBoxName         = 'users';
  /// Kullanıcı görünen adı: key = email (küçük harf), value = ad soyad
  static const String userNamesBoxName     = 'user_names';

  Future<void> init() async {
    await Hive.initFlutter();
    
    // Adaptörleri Kaydet
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(ProcessModelAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(DilekceModelAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(LegalEventModelAdapter());
    if (!Hive.isAdapterRegistered(3)) Hive.registerAdapter(NotificationModelAdapter());

    // Kutuları Aç
    await Hive.openBox<ProcessModel>(processBoxName);
    await Hive.openBox<DilekceModel>(dilekceBoxName);
    await Hive.openBox<LegalEventModel>(legalEventBoxName);
    await Hive.openBox<NotificationModel>(notificationBoxName);
    await Hive.openBox<String>(legalDocsBoxName);
    await Hive.openBox<String>(usersBoxName);
    await Hive.openBox<String>(userNamesBoxName);
  }

  // ── Kullanıcı Kayıt & Giriş (Kalıcı - Hive) ─────────────────────────────

  /// Yeni kullanıcıyı Hive'a kaydeder (sayfa yenileme sonrası da korunur).
  Future<void> registerUser(String email, String password, String name) async {
    final key = email.trim().toLowerCase();
    await Hive.box<String>(usersBoxName).put(key, password);
    await Hive.box<String>(userNamesBoxName).put(key, name.trim());
  }

  /// E-posta + şifre doğruysa true döner.
  bool validateLogin(String email, String password) {
    final key = email.trim().toLowerCase();
    final stored = Hive.box<String>(usersBoxName).get(key);
    return stored != null && stored == password;
  }

  /// E-posta daha önce kayıt edilmiş mi?
  bool isEmailRegistered(String email) {
    return Hive.box<String>(usersBoxName).containsKey(email.trim().toLowerCase());
  }

  /// Kayıtlı kullanıcının adını döner (yoksa email'in @ öncesi).
  String getUserName(String email) {
    final key = email.trim().toLowerCase();
    return Hive.box<String>(userNamesBoxName).get(key) ?? email.split('@')[0];
  }

  // --- Süreç İşlemleri ---
  Future<void> saveProcess(ProcessModel process) async {
    final box = Hive.box<ProcessModel>(processBoxName);
    await box.put(process.id, process);
  }

  List<ProcessModel> getAllProcesses() {
    return Hive.box<ProcessModel>(processBoxName).values.toList();
  }

  Future<void> deleteProcess(String id) async {
    await Hive.box<ProcessModel>(processBoxName).delete(id);
  }

  // --- Dilekçe İşlemleri ---
  Future<void> saveDilekce(DilekceModel dilekce) async {
    final box = Hive.box<DilekceModel>(dilekceBoxName);
    await box.put(dilekce.id, dilekce);
  }

  List<DilekceModel> getAllDilekceler() {
    return Hive.box<DilekceModel>(dilekceBoxName).values.toList();
  }

  Future<void> deleteDilekce(String id) async {
    await Hive.box<DilekceModel>(dilekceBoxName).delete(id);
  }

  // --- Hukuki Süre İşlemleri (Yaklaşan Süreler) ---
  Future<void> saveLegalEvent(LegalEventModel event) async {
    final box = Hive.box<LegalEventModel>(legalEventBoxName);
    await box.put(event.id, event);
  }

  List<LegalEventModel> getAllLegalEvents() {
    return Hive.box<LegalEventModel>(legalEventBoxName).values.toList();
  }

  Future<void> deleteLegalEvent(String id) async {
    await Hive.box<LegalEventModel>(legalEventBoxName).delete(id);
  }

  // --- Bildirim İşlemleri ---
  Future<void> saveNotification(NotificationModel notification) async {
    final box = Hive.box<NotificationModel>(notificationBoxName);
    await box.put(notification.id, notification);
  }

  List<NotificationModel> getAllNotifications() {
    final list = Hive.box<NotificationModel>(notificationBoxName).values.toList();
    // En yeni en üstte olacak şekilde tarihe göre sırala
    list.sort((a, b) => b.time.compareTo(a.time));
    return list;
  }

  Future<void> markAllNotificationsAsRead() async {
    final box = Hive.box<NotificationModel>(notificationBoxName);
    for (var notification in box.values) {
      if (notification.isUnread) {
        notification.isUnread = false;
        await box.put(notification.id, notification);
      }
    }
  }

  Future<void> deleteNotification(String id) async {
    await Hive.box<NotificationModel>(notificationBoxName).delete(id);
  }
}


