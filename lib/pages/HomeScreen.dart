import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hidayath/pages/AmbulanceScreen.dart';
import 'package:hidayath/pages/BuildingsPage.dart';
import 'package:hidayath/pages/HealthCenterPage.dart';
import 'package:hidayath/pages/HospitalsPage.dart';
import 'package:hidayath/pages/NusukScreen.dart';
import 'package:hidayath/pages/RegionsScreen.dart';

import '../customicons_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> _placeLabels = [
    "Mina",
    "Azizia",
    // "Makkah",
    // "Madina",
    // "Muzdalifah",
    // "Arafat",
  ];

  final List<GridItem> _items = [
    GridItem(icon: Customicons.group, text: 'Camp'),
    GridItem(icon: Customicons.ph_hospital_fill, text: 'Hospital'),
    GridItem(icon: Customicons.fa6_solid_mosque, text: 'Masjid'),
    GridItem(icon: Customicons.fluent_vote_20_filled, text: 'Booth'),
    GridItem(icon: Customicons.healthicons_mobile_clinic, text: 'Ambulance'),
    GridItem(icon: Customicons.ic_round_train, text: 'Train'),
  ];

  final Map<String, List<GridItem>> _placeItems = {
    "Mina": [
      GridItem(icon: Customicons.group, text: 'Camp'),
      GridItem(icon: Customicons.ph_hospital_fill, text: 'Hospital'),
      // GridItem(icon: Customicons.fa6_solid_mosque, text: 'Masjid'),
      GridItem(icon: Icons.medical_services_rounded, text: 'Clinic'),
      GridItem(icon: Customicons.healthicons_mobile_clinic, text: 'Ambulance'),
      GridItem(icon: Customicons.fa6_solid_mosque, text: 'Nusuk'),
    ],
    // "Madina": [
    //   GridItem(icon: Customicons.fa6_solid_mosque, text: 'Masjid'),
    //   GridItem(icon: Customicons.ph_hospital_fill, text: 'Hospital'),
    //   GridItem(icon: Icons.medical_services_rounded, text: 'Clinic'),
    //   GridItem(icon: Customicons.healthicons_mobile_clinic, text: 'Ambulance'),
    //   GridItem(icon: Customicons.ic_round_train, text: 'Train'),
    // ],
    // "Makkah": [
    //   GridItem(icon: Customicons.fa6_solid_mosque, text: 'Masjid'),
    //   GridItem(icon: Customicons.ph_hospital_fill, text: 'Hospital'),
    //   GridItem(icon: Icons.medical_services_rounded, text: 'Clinic'),
    //   GridItem(icon: Customicons.healthicons_mobile_clinic, text: 'Ambulance'),
    //   GridItem(icon: Customicons.ic_round_train, text: 'Train'),
    // ],
    // "Muzdalifah": [
    //   GridItem(icon: Customicons.ph_hospital_fill, text: 'Hospital'),
    //   GridItem(icon: Customicons.fa6_solid_mosque, text: 'Masjid'),
    //   GridItem(icon: Icons.medical_services_rounded, text: 'Clinic'),
    //   GridItem(icon: Customicons.healthicons_mobile_clinic, text: 'Ambulance'),
    //   GridItem(icon: Customicons.ic_round_train, text: 'Train'),
    // ],
    // "Arafat": [
    //   GridItem(icon: Customicons.ph_hospital_fill, text: 'Hospital'),
    //   GridItem(icon: Customicons.fa6_solid_mosque, text: 'Masjid'),
    //   GridItem(icon: Icons.medical_services_rounded, text: 'Clinic'),
    //   GridItem(icon: Customicons.healthicons_mobile_clinic, text: 'Ambulance'),
    //   GridItem(icon: Customicons.ic_round_train, text: 'Train'),
    // ],
    "Azizia": [
      GridItem(icon: Customicons.bi_buildings_fill, text: 'Buildings'),
    ],
  };

  int selectedIndex = 0;

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
        body: Stack(
          children:
            [
            Container(
              height: MediaQuery.of(context).size.height,
              padding: const EdgeInsets.only(top: 6.0),
              child: Column(
                children: [

                  // Search Bar
                  // Container(
                  //   margin: const EdgeInsets.symmetric(horizontal: 20),
                  //   padding: const EdgeInsets.symmetric(horizontal: 20),
                  //   decoration: BoxDecoration(
                  //     borderRadius: BorderRadius.circular(30),
                  //     color: const Color(0xFFF8F7EA),
                  //     border: Border.all(
                  //         color: const Color(0xFF29A7B7),
                  //         width: 2), // Border color
                  //   ),
                  //   child: const TextField(
                  //     decoration: InputDecoration(
                  //       hintText: 'Search Services...',
                  //       hintStyle: TextStyle(color: Color(0xFF29A7B7)),
                  //       border: InputBorder.none,
                  //       icon: Icon(
                  //         Icons.search,
                  //         color: Color(0xFF29A7B7),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                  // // Spacer(flex: 1,),
                  // // Search Bar

                  Padding(
                    padding: EdgeInsets.fromLTRB(16.0,7,0,0),
                    child: Row(
                      children: [
                        Text("To visit in ", style: TextStyle(fontSize: 20, color: Color(0xFF1A737E))),
                        Text(_placeLabels[selectedIndex],
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Color(0xFF1A737E),
                              decoration: TextDecoration.underline, decorationStyle: TextDecorationStyle.solid,
                                decorationThickness: 2, decorationColor: Color(0xFF1A737E)
                            ))
                      ],
                    ),
                  ),
          
                  // Listview of places - Mina
                  _placeHorizontalListView(),
                  // Listview of places - Mina

                  const Divider(
                    thickness: 0.5,
                  ),

                  const SizedBox(height: 14),
          
                  //GridView
                  _gridView(),
                  // const Text("See More..", style: TextStyle(color: Color(0xFF1A737E)), textAlign: TextAlign.left,),
          
                  const SizedBox(height: 14),


                ],

              ),
          ),
              // ID Section
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset('assets/images/Hajj/bg_img3.png', // Make sure the image is added to your assets folder and referenced in pubspec.yaml
                  fit: BoxFit.fitWidth,
                  width: MediaQuery.of(context).size.width,
                ),
              ),]
        ));
  }


  Widget _gridView(){
    // Get the items for the selected place
    List<GridItem> items = _placeItems[_placeLabels[selectedIndex!]]!;
    // GridView
    return Container(
      height: 400,
      child: Padding(
        padding: const EdgeInsets.only(
            top: 2.0, left: 20, right: 20),
        child: GridView.builder(
            itemCount: items.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                    switch (items[index].text) {
                      case 'Camp' :
                        if(_placeLabels[selectedIndex] == _placeLabels[0]) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => RegionsPage()));
                        } else { _showToast(context, "Service Unavailable!"); }
                        break;
                      case 'Clinic' :
                        if(_placeLabels[selectedIndex] == _placeLabels[0]) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => HealthCentre()));
                        } else { _showToast(context, "Service Unavailable!"); }
                        break;
                      case 'Hospital' :
                        if(_placeLabels[selectedIndex] == _placeLabels[0]) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  HospitalsPage(place: _placeLabels[0],
                                      imagePath: "assets/excel/kmcc_hospitals_new.xlsx")));
                        } else { _showToast(context, "Service Unavailable!"); }
                        break;
                      case 'Ambulance' :
                        if(_placeLabels[selectedIndex] == _placeLabels[0]) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const AmbulanceScreen()));
                        } else { _showToast(context, "Service Unavailable!"); }
                        break;
                      case 'Nusuk' :
                        if(_placeLabels[selectedIndex] == _placeLabels[0]) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) =>
                                  const NusukScreen()));
                        } else { _showToast(context, "Service Unavailable!"); }
                        break;
                      case 'Buildings' :
                        if(_placeLabels[selectedIndex] == _placeLabels[1]) {
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => const BuildingsPage()));
                        } else { _showToast(context, "Coming Soon"); }
                        break;
                      default :
                        _showToast(context, "Service Unavailable!");
                    }
                },
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                      // Rounded corners
                      side: const BorderSide(
                        color: Color(0xFF1A737E), // Border color
                        width: 2.0, // Border width
                      ),
                    ),
                    color: const Color(0xFFFFFFFF),
                    child: Center(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              items[index].icon,
                              size: 40,
                              color: Color(0xFF1A737E),
                            ),
                            Text(
                              items[index].text,
                              style: const TextStyle(
                                  color: Color(0xFF1A737E)),
                            )
                          ]),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
    // GridView
  }


  Widget _placeHorizontalListView() {
    return Container(
      height: 70,
      child: Padding(
        padding: const EdgeInsets.all(6),
        child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _placeLabels.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(6.0),
                child: Container(
                    child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          side: selectedIndex == index
                              ? const BorderSide(width: 0.0, color: Color(0xFFFFFFFF))
                              : const BorderSide(width: 2.0, color: Color(0xFF1A737E)), // Color for unselected buttons,
                          backgroundColor: selectedIndex == index
                              ? const Color(
                              0xFF1A737E) // Color for selected button
                              : const Color(
                              0xFFFFFFFF), // Color for unselected buttons
                        ),
                        child: Text(_placeLabels[index],
                            style: selectedIndex == index
                                ? const TextStyle(
                                color: Color(0xFFFFFFFF), fontSize: 16)
                                : const TextStyle(
                                color: Color(0xFF1A737E), fontSize: 16)))),
              );
            }),
      ),
    );
    // Listview of places - Mina
  }


  void _showToast(BuildContext context, String msg) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(msg),
        duration: const Duration(seconds: 1),
      ),
    );
  }
}

//
class GridItem {
  final IconData icon;
  final String text;

  GridItem({required this.icon, required this.text});
}