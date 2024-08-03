import 'package:flutter/material.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF), // Custom background color
        leading: Padding(
          padding: const EdgeInsets.only(left: 13.0),
          child: Image.asset('assets/images/kmcc_hajj_cell_appbar.png'),
        ),
        leadingWidth: 100, // Image on the left side
      ),
      body: const Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("About US", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28, color: Color(0xFF1A737E))),
              SizedBox(height: 10),
              Text(
                  "KMCC Hajj Cell App is a guide for Hajj and Umrah pilgrims to locate their camps, "
                      "Mina Camp poll numbers, camp maktab numbers, street numbers, train stations, mosques, hospitals, healthcare facilities, and ambulance centers. "
                      "It also covers the Hajis' apartment numbers in Azizia. Additionally, the app provides information on important hospitals, clinics, "
                      "and notable places in the two holy cities, Makkah and Madeena.",
              style: TextStyle(fontSize: 16),),
              SizedBox(height: 20),
            ],
          ),
        ),
    );
  }
}
