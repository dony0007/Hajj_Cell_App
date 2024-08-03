// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CountryModelAdapter extends TypeAdapter<CountryModel> {
  @override
  final int typeId = 5;

  @override
  CountryModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CountryModel(
      Arabic: fields[0] as String,
      Country: fields[1] as String,
      Category: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CountryModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.Arabic)
      ..writeByte(1)
      ..write(obj.Country)
      ..writeByte(2)
      ..write(obj.Category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CountryModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
