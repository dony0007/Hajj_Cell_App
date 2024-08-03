import 'package:hive/hive.dart';

part "building_model.g.dart";

@HiveType(typeId: 4)
class BuildingModel  {
  @HiveField(0)
  final String BuildingNo;

  @HiveField(1)
  final String Link;

  @HiveField(2)
  final String N;

  @HiveField(3)
  final String E;

  BuildingModel({required this.BuildingNo, required this.Link, required this.N, required this.E});
}