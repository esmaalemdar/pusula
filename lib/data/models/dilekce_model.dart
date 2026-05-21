import 'package:hive/hive.dart';

part 'dilekce_model.g.dart';

@HiveType(typeId: 1)
class DilekceModel extends HiveObject {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String content;
  
  @HiveField(3)
  final DateTime createDate;

  DilekceModel({
    required this.id,
    required this.title,
    required this.content,
    required this.createDate,
  });
}


