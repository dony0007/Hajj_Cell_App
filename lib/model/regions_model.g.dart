// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'regions_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RegionModelAdapter extends TypeAdapter<RegionModel> {
  @override
  final int typeId = 3;

  @override
  RegionModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RegionModel(
      Category: fields[0] as String,
      Country: fields[1] as String,
      Image: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RegionModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.Category)
      ..writeByte(1)
      ..write(obj.Country)
      ..writeByte(2)
      ..write(obj.Image);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RegionModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
