// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hospital_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HospitalModelAdapter extends TypeAdapter<HospitalModel> {
  @override
  final int typeId = 1;

  @override
  HospitalModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HospitalModel(
      E: fields[0] as String,
      N: fields[1] as String,
      Street: fields[2] as String,
      Camp: fields[3] as String,
      Hospital: fields[4] as String,
      ArabicName: fields[5] as String,
    );
  }

  @override
  void write(BinaryWriter writer, HospitalModel obj) {
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
      ..write(obj.Hospital)
      ..writeByte(5)
      ..write(obj.ArabicName);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HospitalModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
