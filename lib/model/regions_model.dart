import 'package:hive/hive.dart';

part "regions_model.g.dart";

@HiveType(typeId: 3)
class RegionModel  {
  @HiveField(0)
  final String Category;

  @HiveField(1)
  final String Country;

  @HiveField(2)
  final String Image;

  RegionModel({required this.Category, required this.Country, required this.Image});
}