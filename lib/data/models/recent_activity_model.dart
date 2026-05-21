enum ActivityType { petitionCreated, documentUploaded, statusUpdated, reminder }

class RecentActivityModel {
  final String id;
  final String title;
  final String? description;
  final ActivityType type;
  final DateTime date;

  const RecentActivityModel({
    required this.id,
    required this.title,
    this.description,
    required this.type,
    required this.date,
  });
}


