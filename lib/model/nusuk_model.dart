import 'package:hive/hive.dart';

part "nusuk_model.g.dart";

@HiveType(typeId: 7)
class NusukModel  {
  @HiveField(0)
  final String E;

  @HiveField(1)
  final String N;

  @HiveField(2)
  final String Street;

  @HiveField(3)
  final String Camp;

  @HiveField(4)
  final String Category;

  @HiveField(5)
  final String Arabic;

  @HiveField(6)
  final String Centre;

  NusukModel({required this.E, required this.N, required this.Street, required this.Camp, required this.Category, required this.Arabic, required this.Centre});
}
