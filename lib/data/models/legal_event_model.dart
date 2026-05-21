// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Hukuki Ajanda Veri Modeli
// ═══════════════════════════════════════════════════════════════════════════

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

enum DeadlinePriority { low, medium, high, critical }

class LegalEventModel {
  final String id;
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime deadlineDate;
  final String relatedProcedureId;

  const LegalEventModel({
    required this.id,
    required this.title,
    required this.description,
    required this.startDate,
    required this.deadlineDate,
    required this.relatedProcedureId,
  });

  // Kalan gün sayısını hesapla
  int get daysLeft {
    final now = DateTime.now();
    final difference = deadlineDate.difference(DateTime(now.year, now.month, now.day));
    return difference.inDays;
  }

  // Öncelik durumunu hesapla
  DeadlinePriority get priority {
    final days = daysLeft;
    if (days <= 3) return DeadlinePriority.critical;
    if (days <= 7) return DeadlinePriority.high;
    if (days <= 15) return DeadlinePriority.medium;
    return DeadlinePriority.low;
  }

  // Önceliğe göre renk döndür
  Color get priorityColor {
    switch (priority) {
      case DeadlinePriority.critical: return const Color(0xFFE05252);
      case DeadlinePriority.high: return const Color(0xFFF59E0B);
      case DeadlinePriority.medium: return const Color(0xFF3D7EE8);
      case DeadlinePriority.low: return const Color(0xFF3A9E7A);
    }
  }

  // table_calendar için Event listesi formatı
  static Map<DateTime, List<LegalEventModel>> toCalendarFormat(List<LegalEventModel> events) {
    final Map<DateTime, List<LegalEventModel>> data = {};
    for (var event in events) {
      final date = DateTime(event.deadlineDate.year, event.deadlineDate.month, event.deadlineDate.day);
      if (data[date] == null) data[date] = [];
      data[date]!.add(event);
    }
    return data;
  }
}

class LegalEventModelAdapter extends TypeAdapter<LegalEventModel> {
  @override
  final int typeId = 2; // 0=Process, 1=Dilekce

  @override
  LegalEventModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LegalEventModel(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      startDate: fields[3] as DateTime,
      deadlineDate: fields[4] as DateTime,
      relatedProcedureId: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LegalEventModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.startDate)
      ..writeByte(4)
      ..write(obj.deadlineDate)
      ..writeByte(5)
      ..write(obj.relatedProcedureId);
  }
}


