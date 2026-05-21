// ═══════════════════════════════════════════════════════════════════════════
// PUSULA — Hukuki Belge Modeli (SQLite)
// Dosya: lib/data/models/legal_document_model.dart
//
// Mevcut process_model.dart ve dilekce_model.dart (Hive) DOKUNULMADI.
// Bu model, location_database_service.dart üzerindeki SQLite DB'ye ait.
// ═══════════════════════════════════════════════════════════════════════════

class LegalDocument {
  final int? id;
  final String title;

  /// Pasaport | Kira | Taşıt | Nüfus | Vergi | Diğer
  final String category;

  /// ISO 8601 formatında tarih string (sıralama için): '2024-05-12'
  final String date;

  /// Dosya boyutu veya alt başlık: '1.2 MB', '450 KB', 'Taslak' vb.
  final String fileSizeOrSubtitle;

  /// 0 → sol listede + zaman çizelgesinde göster
  /// 1 → yalnızca zaman çizelgesinde göster
  final int isTimelineOnly;

  const LegalDocument({
    this.id,
    required this.title,
    required this.category,
    required this.date,
    required this.fileSizeOrSubtitle,
    this.isTimelineOnly = 0,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'category': category,
      'date': date,
      'fileSizeOrSubtitle': fileSizeOrSubtitle,
      'isTimelineOnly': isTimelineOnly,
    };
  }

  factory LegalDocument.fromMap(Map<String, dynamic> map) {
    return LegalDocument(
      id: (map['id'] as num?)?.toInt(),
      title: map['title'] as String,
      category: map['category'] as String,
      date: map['date'] as String,
      fileSizeOrSubtitle: map['fileSizeOrSubtitle'] as String,
      isTimelineOnly: (map['isTimelineOnly'] as num?)?.toInt() ?? 0,
    );
  }

  LegalDocument copyWith({
    int? id,
    String? title,
    String? category,
    String? date,
    String? fileSizeOrSubtitle,
    int? isTimelineOnly,
  }) {
    return LegalDocument(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      date: date ?? this.date,
      fileSizeOrSubtitle: fileSizeOrSubtitle ?? this.fileSizeOrSubtitle,
      isTimelineOnly: isTimelineOnly ?? this.isTimelineOnly,
    );
  }

  @override
  String toString() =>
      'LegalDocument(id: $id, title: $title, category: $category, date: $date)';
}


