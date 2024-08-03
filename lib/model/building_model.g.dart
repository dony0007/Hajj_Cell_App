// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'building_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class BuildingModelAdapter extends TypeAdapter<BuildingModel> {
  @override
  final int typeId = 4;

  @override
  BuildingModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BuildingModel(
      BuildingNo: fields[0] as String,
      Link: fields[1] as String,
      N: fields[2] as String,
      E: fields[3] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BuildingModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.BuildingNo)
      ..writeByte(1)
      ..write(obj.Link)
      ..writeByte(2)
      ..write(obj.N)
      ..writeByte(3)
      ..write(obj.E);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BuildingModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
