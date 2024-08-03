// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'nusuk_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class NusukModelAdapter extends TypeAdapter<NusukModel> {
  @override
  final int typeId = 7;

  @override
  NusukModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return NusukModel(
      E: fields[0] as String,
      N: fields[1] as String,
      Street: fields[2] as String,
      Camp: fields[3] as String,
      Category: fields[4] as String,
      Arabic: fields[5] as String,
      Centre: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, NusukModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.E)
      ..writeByte(1)
      ..write(obj.N)
      ..writeByte(2)
      ..write(obj.Street)
      ..writeByte(3)
      ..write(obj.Camp)
      ..writeByte(4)
      ..write(obj.Category)
      ..writeByte(5)
      ..write(obj.Arabic)
      ..writeByte(6)
      ..write(obj.Centre);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NusukModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
