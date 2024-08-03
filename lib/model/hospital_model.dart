import 'package:hive/hive.dart';

part 'hospital_model.g.dart';

@HiveType(typeId: 1)
class HospitalModel {
  @HiveField(0)
  final String E;

  @HiveField(1)
  final String N;

  @HiveField(2)
  final String Street;

  @HiveField(3)
  final String Camp;

  @HiveField(4)
  final String Hospital;

  @HiveField(5)
  final String ArabicName;

  HospitalModel({required this.E, required this.N, required this.Street, required this.Camp, required this.Hospital, required this.ArabicName});
}