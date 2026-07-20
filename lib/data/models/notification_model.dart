// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Bildirim Modeli
// ═══════════════════════════════════════════════════════════════════════════

import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 3)
class NotificationModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String content;

  @HiveField(3)
  final DateTime time;

  @HiveField(4)
  final int iconCodePoint;

  @HiveField(5)
  final int iconColorValue;

  @HiveField(6)
  bool isUnread;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.iconCodePoint,
    required this.iconColorValue,
    required this.isUnread,
  });
}
