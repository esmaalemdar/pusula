class ActiveCaseModel {
  final String id;
  final String title;
  final String subtitle;
  final double progress;        // 0.0 – 1.0
  final String categoryLabel;
  final DateTime lastUpdated;

  const ActiveCaseModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.progress,
    required this.categoryLabel,
    required this.lastUpdated,
  });

  static ActiveCaseModel mock() => ActiveCaseModel(
        id: 'case-001',
        title: 'Aktif Süreç: Kira Tahliye',
        subtitle: 'İstanbul 3. Sulh Hukuk Mahkemesi',
        progress: 0.65,
        categoryLabel: 'Kira Hukuku',
        lastUpdated: DateTime.now().subtract(const Duration(hours: 3)),
      );
}


