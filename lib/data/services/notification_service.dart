// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Bildirim Servisi (Kritik Süre Hatırlatıcısı - FINAL VERIFIED)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    tz.initializeTimeZones();
    
    const AndroidInitializationSettings androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const DarwinInitializationSettings iosSettings = DarwinInitializationSettings();
    
    const InitializationSettings initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    // Web platformunda veya uyumsuz cihazlarda çökmeyi engellemek için try-catch
    try {
      await _notificationsPlugin.initialize(settings: initSettings); 
    } catch (e) {
      debugPrint("Bildirim servisi başlatılamadı (Web ortamı veya uyumsuzluk): $e");
    }
  }

  // Hatırlatıcı Planla (24 Saat Kala)
  Future<void> scheduleDeadlineReminder({
    required int id,
    required String title,
    required String body,
    required DateTime deadline,
  }) async {
    final reminderTime = deadline.subtract(const Duration(hours: 24));
    
    if (reminderTime.isBefore(DateTime.now())) return;

    await _notificationsPlugin.zonedSchedule(
      id: id,
      title: "Kritik Süre Hatırlatıcısı: $title",
      body: body,
      scheduledDate: tz.TZDateTime.from(reminderTime, tz.local),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'deadline_channel',
          'Legal Deadlines',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    );
  }
}


