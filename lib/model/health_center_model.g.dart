// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'health_center_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HealthCenterModelAdapter extends TypeAdapter<HealthCenterModel> {
  @override
  final int typeId = 2;

  @override
  HealthCenterModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HealthCenterModel(
      E: fields[0] as String,
      N: fields[1] as String,
      Street: fields[2] as String,
      Camp: fields[3] as String,
      Centre: fields[4] as String,
      Category: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HealthCenterModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.E)
      ..writeByte(1)
      ..write(obj.N)
      ..writeByte(2)
      ..write(obj.Street)
      ..writeByte(3)
      ..write(obj.Camp)
      ..writeByte(4)
      ..write(obj.Centre)
      ..writeByte(5)
      ..write(obj.Category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HealthCenterModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
