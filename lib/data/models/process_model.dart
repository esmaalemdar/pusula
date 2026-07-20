// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Veri Modelleri (Hive ile Yerel Saklama)
// ═══════════════════════════════════════════════════════════════════════════

import 'package:hive/hive.dart';

part 'process_model.g.dart';

@HiveType(typeId: 0)
class ProcessModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String status; // Örn: Devam Ediyor, Tamamlandı
  
  @HiveField(3)
  final double progress; // 0.0 - 1.0
  
  @HiveField(4)
  final DateTime lastUpdate;
  
  @HiveField(5)
  final String type; // Örn: Kira, Tapu

  ProcessModel({
    required this.id,
    required this.title,
    required this.status,
    required this.progress,
    required this.lastUpdate,
    required this.type,
  });
}


