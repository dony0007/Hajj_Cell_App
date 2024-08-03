import 'package:flutter/material.dart';
import 'package:hidayath/pages/DashboardScreen.dart';
import 'package:hidayath/pages/terms_conditions_page.dart';
import 'package:hive/hive.dart';
import 'package:package_info_plus/package_info_plus.dart';

import 'HomeScreen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  String versionNo = "";
  String appName = "";

  @override
  void initState() {
    super.initState();
    _loadAppVersion();
    setState(() {});
    _navigate();
  }

  void _loadAppVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    setState(() {
      appName = packageInfo.appName;
      versionNo = packageInfo.version;
    });
  }

  _navigate() async {
    var box = await Hive.openBox('settings');
    bool acceptedTerms = box.get('acceptedTerms', defaultValue: false);
    if(acceptedTerms) {
      _navigateToHome();
    } else {
      _navigateToTermsAndConditions();
    }
  }

  _navigateToTermsAndConditions() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const TermsConditionsPage()),
    );
  }

  _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 3), () {});
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const DashboardScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF), // Custom background color
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Image(
              image: AssetImage("assets/images/hajj_icon.png"),
              width: 300,
            ), // Logo image
            Text('Version $versionNo', style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
