import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../customicons_icons.dart';
import 'package:hidayath/model/hospital_model.dart';
import 'package:hive/hive.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart' as e;
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalsPage extends StatefulWidget {
  final String place;
  final String imagePath;

  const HospitalsPage({super.key, required this.place, required this.imagePath});

  @override
  State<HospitalsPage> createState() => _HospitalsPageState();
}

class _HospitalsPageState extends State<HospitalsPage> {
  Box<HospitalModel>? hospitalBox;
  List<HospitalModel> filteredHospitalsData = [];

  @override
  void initState() {
    super.initState();
    openBox();
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    hospitalBox = await Hive.openBox<HospitalModel>(widget.place);
    if (hospitalBox!.isEmpty) {
      await loadExcelData();
    }
    setState(() {
      filteredHospitalsData = hospitalBox!.values.toList();
    });
  }

  Future<void> loadExcelData() async {
    final ByteData data =
        await rootBundle.load(widget.imagePath);
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final e.Excel excel = e.Excel.decodeBytes(bytes);

    List<HospitalModel> tempList = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows.skip(1)) {
        tempList.add(HospitalModel(
          E: row[0]?.value?.toString() ?? '',
          N: row[1]?.value?.toString() ?? '',
          Street: row[2]?.value?.toString() ?? '',
          Camp: row[3]?.value?.toString() ?? '',
          Hospital: row[4]?.value?.toString() ?? '',
          ArabicName: row[5]?.value?.toString() ?? '',
        ));
      }
    }

    for (var hospitalModel in tempList) {
      await hospitalBox!.add(hospitalModel);
    }
  }

  void _openMap(HospitalModel hospital) {
    final String latitude = hospital.N;
    final String longitude = hospital.E;
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      launchUrl(Uri.parse(googleMapsUrl));
    } else {
      // Show a snackbar or some other error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter both latitude and longitude')),
      );
    }
  }

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
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Title Card
          Container(
            color: const Color(0xFF1A737E),
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
            child: Row(
              children: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child:
                        const Icon(Icons.arrow_back_ios, color: Colors.white)),
                const Text(
                  'Hospital',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF8F7EA)),
                ),
              ],
            ),
          ),


          Container(
            color: Colors.grey[200],
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Customicons.ph_hospital_fill,
                      color: Color(0xFF1A737E),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text("Hospitals",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Color(0xFF1A737E)))
                  ],
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
                child: Container(
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: filteredHospitalsData.asMap().entries.map((row) {
                    int index = row.key;
                    var hospital = row.value;
                    return Card(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0)),
                      color: index % 2 == 0
                          ? Color(0xFFE7EFF1)
                          : Color(0xFFCBDDE1),
                      elevation: 0,
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(
                                  15.0, 10.0, 15.0, 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      _customEllipseText(hospital.Hospital, 25),
                                      Text(hospital.ArabicName, maxLines: 2),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _openMap(hospital);
                                    },
                                    child: const Column(
                                      children: [
                                        Icon(Icons.directions_rounded),
                                        Text(
                                          "Direction",
                                          style: TextStyle(fontSize: 10),
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _customEllipseText(final String text, final int maxLength) {
    return Container(
      width: 200, // Set a fixed width to demonstrate ellipsize
      child: Text(
        text,
        overflow: text.length > maxLength ? TextOverflow.ellipsis : TextOverflow.visible,
        maxLines: 1, // You can change this to allow more lines
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }

}
