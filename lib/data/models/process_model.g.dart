// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'process_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProcessModelAdapter extends TypeAdapter<ProcessModel> {
  @override
  final int typeId = 0;

  @override
  ProcessModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProcessModel(
      id: fields[0] as String,
      title: fields[1] as String,
      status: fields[2] as String,
      progress: fields[3] as double,
      lastUpdate: fields[4] as DateTime,
      type: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ProcessModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.status)
      ..writeByte(3)
      ..write(obj.progress)
      ..writeByte(4)
      ..write(obj.lastUpdate)
      ..writeByte(5)
      ..write(obj.type);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProcessModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
