import 'package:flutter/material.dart';

/// İşlem kategorisi — sekme yapısını belirler.
enum ProcedureCategory {
  vatandaslik,
  pasaport,
  tapu,
  tasit,
  sgk,
  kira,
  egitim,
  aile,
  dijitalDevlet,
}

/// Kategori görsel ayarları
class CategoryConfig {
  final String label;
  final IconData icon;
  final Color color;
  final Color backgroundColor;

  const CategoryConfig({
    required this.label,
    required this.icon,
    required this.color,
    required this.backgroundColor,
  });
}

/// Gerekli belge modeli
class RequiredDocument {
  final String name;
  final String? description;
  final String? source;
  final bool isCritical;

  const RequiredDocument({
    required this.name,
    this.description,
    this.source,
    this.isCritical = true,
  });
}

/// Ana prosedür veri modeli
class ProcedureModel {
  final String id;
  final String name;
  final ProcedureCategory category;
  final String applicationVenue;
  final List<RequiredDocument> requiredDocuments;
  final String fee;
  final double? feeAmount;
  final String estimatedDuration;
  final String? criticalNote;
  final List<String> steps;
  final Map<String, dynamic>? workflowMeta;

  const ProcedureModel({
    required this.id,
    required this.name,
    required this.category,
    required this.applicationVenue,
    required this.requiredDocuments,
    required this.fee,
    this.feeAmount,
    required this.estimatedDuration,
    this.criticalNote,
    this.steps = const [],
    this.workflowMeta,
  });

  static CategoryConfig configFor(ProcedureCategory cat) {
    switch (cat) {
      case ProcedureCategory.vatandaslik:
        return const CategoryConfig(
          label: 'Vatandaşlık',
          icon: Icons.public_rounded,
          color: Color(0xFF3D7EE8),
          backgroundColor: Color(0xFFE8F0FE),
        );
      case ProcedureCategory.pasaport:
        return const CategoryConfig(
          label: 'Pasaport',
          icon: Icons.badge_outlined,
          color: Color(0xFFF5A623),
          backgroundColor: Color(0xFFFEF3E2),
        );
      case ProcedureCategory.tapu:
        return const CategoryConfig(
          label: 'Tapu & Emlak',
          icon: Icons.landscape_rounded,
          color: Color(0xFF3A9E7A),
          backgroundColor: Color(0xFFE6F4EF),
        );
      case ProcedureCategory.tasit:
        return const CategoryConfig(
          label: 'Taşıt İşlemleri',
          icon: Icons.directions_car_filled_rounded,
          color: Color(0xFFE05252),
          backgroundColor: Color(0xFFFDECEC),
        );
      case ProcedureCategory.sgk:
        return const CategoryConfig(
          label: 'SGK & Emeklilik',
          icon: Icons.account_balance_wallet_rounded,
          color: Color(0xFF673AB7),
          backgroundColor: Color(0xFFF3E5F5),
        );
      case ProcedureCategory.kira:
        return const CategoryConfig(
          label: 'Kira Hukuku',
          icon: Icons.home_work_outlined,
          color: Color(0xFF7D9D85),
          backgroundColor: Color(0xFFF0F4F1),
        );
      case ProcedureCategory.egitim:
        return const CategoryConfig(
          label: 'Eğitim İşlemleri',
          icon: Icons.school_rounded,
          color: Color(0xFFF87171),
          backgroundColor: Color(0xFFFEF2F2),
        );
      case ProcedureCategory.aile:
        return const CategoryConfig(
          label: 'Aile & Medeni Hal',
          icon: Icons.family_restroom_rounded,
          color: Color(0xFFEC4899),
          backgroundColor: Color(0xFFFDF2F8),
        );
      case ProcedureCategory.dijitalDevlet:
        return const CategoryConfig(
          label: 'Dijital Devlet',
          icon: Icons.electrical_services_rounded,
          color: Color(0xFF0EA5E9),
          backgroundColor: Color(0xFFF0F9FF),
        );
    }
  }
}


