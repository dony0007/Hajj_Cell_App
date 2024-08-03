import 'package:hive/hive.dart';

part "country_model.g.dart";

@HiveType(typeId: 5)
class CountryModel  {
  @HiveField(0)
  final String Arabic;

  @HiveField(1)
  final String Country;

  @HiveField(2)
  final String Category;

  CountryModel({required this.Arabic, required this.Country, required this.Category});
}