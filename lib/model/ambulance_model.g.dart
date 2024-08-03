// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ambulance_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AmbulanceModelAdapter extends TypeAdapter<AmbulanceModel> {
  @override
  final int typeId = 6;

  @override
  AmbulanceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AmbulanceModel(
      E: fields[0] as String,
      N: fields[1] as String,
      Street: fields[2] as String,
      Camp: fields[3] as String,
      Centre: fields[4] as String,
      Category: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AmbulanceModel obj) {
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
      other is AmbulanceModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
