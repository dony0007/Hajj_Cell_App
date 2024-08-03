import 'package:hive/hive.dart';

part "ambulance_model.g.dart";

@HiveType(typeId: 6)
class AmbulanceModel  {
  @HiveField(0)
  final String E;

  @HiveField(1)
  final String N;

  @HiveField(2)
  final String Street;

  @HiveField(3)
  final String Camp;

  @HiveField(4)
  final String Centre;

  @HiveField(5)
  final String Category;

  AmbulanceModel({required this.E, required this.N, required this.Street, required this.Camp, required this.Centre, required this.Category});
}