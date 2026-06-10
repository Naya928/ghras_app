// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'plant_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlantItemAdapter extends TypeAdapter<PlantItem> {
  @override
  final int typeId = 1;

  @override
  PlantItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PlantItem(
      type: fields[0] as PlantType,
      x: fields[1] as double,
      y: fields[2] as double,
      isPlaced: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PlantItem obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.type)
      ..writeByte(1)
      ..write(obj.x)
      ..writeByte(2)
      ..write(obj.y)
      ..writeByte(3)
      ..write(obj.isPlaced);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class PlantTypeAdapter extends TypeAdapter<PlantType> {
  @override
  final int typeId = 0;

  @override
  PlantType read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return PlantType.seedling;
      case 1:
        return PlantType.flower;
      case 2:
        return PlantType.tree;
      default:
        return PlantType.seedling;
    }
  }

  @override
  void write(BinaryWriter writer, PlantType obj) {
    switch (obj) {
      case PlantType.seedling:
        writer.writeByte(0);
        break;
      case PlantType.flower:
        writer.writeByte(1);
        break;
      case PlantType.tree:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlantTypeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
