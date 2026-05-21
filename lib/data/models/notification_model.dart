import 'package:hive/hive.dart';

class NotificationModel {
  final String id;
  final String title;
  final String content;
  final DateTime time;
  final int iconCodePoint;
  final int iconColorValue;
  bool isUnread;

  NotificationModel({
    required this.id,
    required this.title,
    required this.content,
    required this.time,
    required this.iconCodePoint,
    required this.iconColorValue,
    this.isUnread = true,
  });
}

class NotificationModelAdapter extends TypeAdapter<NotificationModel> {
  @override
  final int typeId = 3;

  @override
  NotificationModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NotificationModel(
      id: fields[0] as String,
      title: fields[1] as String,
      content: fields[2] as String,
      time: fields[3] as DateTime,
      iconCodePoint: fields[4] as int,
      iconColorValue: fields[5] as int,
      isUnread: fields[6] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, NotificationModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.content)
      ..writeByte(3)
      ..write(obj.time)
      ..writeByte(4)
      ..write(obj.iconCodePoint)
      ..writeByte(5)
      ..write(obj.iconColorValue)
      ..writeByte(6)
      ..write(obj.isUnread);
  }
}
