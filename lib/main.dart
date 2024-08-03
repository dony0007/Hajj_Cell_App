import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidayath/model/ambulance_model.dart';
import 'package:hidayath/model/building_model.dart';
import 'package:hidayath/model/country_model.dart';
import 'package:hidayath/model/data_model.dart';
import 'package:hidayath/model/health_center_model.dart';
import 'package:hidayath/model/hospital_model.dart';
import 'package:hidayath/model/nusuk_model.dart';
import 'package:hidayath/model/regions_model.dart';
import 'package:hidayath/pages/SplashScreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'model/data_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Hive.initFlutter();
  Hive.registerAdapter(DataModelAdapter());
  Hive.registerAdapter(HospitalModelAdapter());
  Hive.registerAdapter(HealthCenterModelAdapter());
  Hive.registerAdapter(RegionModelAdapter());
  Hive.registerAdapter(BuildingModelAdapter());
  Hive.registerAdapter(CountryModelAdapter());
  Hive.registerAdapter(AmbulanceModelAdapter());
  Hive.registerAdapter(NusukModelAdapter());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    );
  }
}
