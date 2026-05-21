// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Bildirimler (Notifications)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:pusula/core/theme/app_colors.dart';
import 'package:pusula/data/models/notification_model.dart';
import 'package:pusula/data/services/database_service.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final _db = DatabaseService();
  List<NotificationModel> _notifications = [];

  @override
  void initState() {
    super.initState();
    _loadNotifications();
  }

  void _loadNotifications() {
    var items = _db.getAllNotifications();
    
    // Geçmişte (Örnek) etiketi olmadan kaydedilmiş sahte verileri temizle
    final oldMocks = items.where((i) => i.id.startsWith('notif-') && !i.title.contains('(Örnek)')).toList();
    if (oldMocks.isNotEmpty) {
      for (var mock in oldMocks) {
        _db.deleteNotification(mock.id);
      }
      items = _db.getAllNotifications(); // Temizlik sonrası tekrar çek
    }

    if (items.isEmpty) {
      _seedMockData();
      _notifications = _db.getAllNotifications();
    } else {
      _notifications = items;
    }
    setState(() {});
  }

  void _seedMockData() {
    final now = DateTime.now();
    _db.saveNotification(NotificationModel(
      id: 'notif-1',
      title: 'Duruşma Hatırlatıcısı (Örnek)',
      content: 'Kira Tahliye davanızın duruşmasına 2 gün kaldı. Belgelerinizi hazır bulundurmayı unutmayın.',
      time: now.subtract(const Duration(hours: 2)),
      iconCodePoint: Icons.gavel_rounded.codePoint,
      iconColorValue: const Color(0xFFE05252).value,
      isUnread: true,
    ));
    _db.saveNotification(NotificationModel(
      id: 'notif-2',
      title: 'Pasaport Durumu (Örnek)',
      content: 'Pasaport başvurunuz onaylandı ve basım aşamasına geçildi. 3-5 iş günü içinde teslim edilecektir.',
      time: now.subtract(const Duration(days: 1)),
      iconCodePoint: Icons.badge_outlined.codePoint,
      iconColorValue: const Color(0xFF3D7EE8).value,
      isUnread: true,
    ));
    _db.saveNotification(NotificationModel(
      id: 'notif-3',
      title: 'Sistem Güncellemesi (Örnek)',
      content: 'Yeni "SGK & Emeklilik" modülü kullanıma açıldı. Profilinizden detayları inceleyebilirsiniz.',
      time: now.subtract(const Duration(days: 2)),
      iconCodePoint: Icons.system_update_alt_rounded.codePoint,
      iconColorValue: const Color(0xFF3A9E7A).value,
      isUnread: false,
    ));
    _db.saveNotification(NotificationModel(
      id: 'notif-4',
      title: 'Dilekçe Kaydedildi (Örnek)',
      content: '"Vatandaşlık Başvuru Dilekçesi" başarıyla PDF olarak Arşiv bölümüne kaydedildi.',
      time: now.subtract(const Duration(days: 3)),
      iconCodePoint: Icons.description_outlined.codePoint,
      iconColorValue: const Color(0xFFF5A623).value,
      isUnread: false,
    ));
  }

  Future<void> _markAllAsRead() async {
    await _db.markAllNotificationsAsRead();
    _loadNotifications();
  }

  String _formatTime(DateTime time) {
    final difference = DateTime.now().difference(time);
    if (difference.inHours == 0) return 'Az önce';
    if (difference.inHours < 24) return '${difference.inHours} saat önce';
    if (difference.inDays == 1) return 'Dün';
    return '${difference.inDays} gün önce';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Bildirimler', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        backgroundColor: Theme.of(context).cardColor,
        elevation: 0.5,
        foregroundColor: Theme.of(context).textTheme.bodyLarge?.color,
        actions: [
          TextButton(
            onPressed: _markAllAsRead,
            child: const Text('Tümünü Oku', style: TextStyle(color: AppColors.accent)),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: _notifications.length,
        itemBuilder: (context, index) {
          final notif = _notifications[index];
          return _NotificationTile(
            title: notif.title,
            content: notif.content,
            time: _formatTime(notif.time),
            icon: IconData(notif.iconCodePoint, fontFamily: 'MaterialIcons'),
            iconColor: Color(notif.iconColorValue),
            isUnread: notif.isUnread,
          );
        },
      ),
    );
  }
}

class _NotificationTile extends StatelessWidget {
  final String title;
  final String content;
  final String time;
  final IconData icon;
  final Color iconColor;
  final bool isUnread;

  const _NotificationTile({
    required this.title,
    required this.content,
    required this.time,
    required this.icon,
    required this.iconColor,
    this.isUnread = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isUnread ? Theme.of(context).cardColor : Theme.of(context).cardColor.withOpacity(0.7),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isUnread ? AppColors.accent.withOpacity(0.2) : Theme.of(context).dividerColor.withOpacity(0.2)),
        boxShadow: isUnread ? [BoxShadow(color: AppColors.accent.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4))] : null,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyLarge?.color)),
                    Text(time, style: TextStyle(fontSize: 11, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.4))),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  content,
                  style: TextStyle(fontSize: 13, color: Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6), height: 1.4),
                ),
              ],
            ),
          ),
          if (isUnread)
            Padding(
              padding: const EdgeInsets.only(left: 8, top: 4),
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
              ),
            ),
        ],
      ),
    );
  }
}



