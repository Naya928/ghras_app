// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reading_progress.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ReadingProgressAdapter extends TypeAdapter<ReadingProgress> {
  @override
  final int typeId = 2;

  @override
  ReadingProgress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReadingProgress(
      pagesRead: fields[0] as int,
      placedPlants: (fields[1] as List?)?.cast<PlantItem>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReadingProgress obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.pagesRead)
      ..writeByte(1)
      ..write(obj.placedPlants);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReadingProgressAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
