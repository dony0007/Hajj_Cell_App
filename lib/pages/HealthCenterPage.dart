import 'package:excel/excel.dart' as e;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidayath/model/health_center_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

class HealthCentre extends StatefulWidget {
  const HealthCentre({super.key});

  @override
  State<HealthCentre> createState() => _HealthCentreState();
}

class _HealthCentreState extends State<HealthCentre> {
  Box<HealthCenterModel>? healthBox;
  List<HealthCenterModel> filteredClinicData = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    openBox();
    searchController.addListener(_filterClinics);
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    healthBox = await Hive.openBox<HealthCenterModel>('healthBox');
    if (healthBox != null && healthBox!.isEmpty) {
      await loadExcelData();
    } else {
      isLoading = false;
    }
    setState(() {
      filteredClinicData = healthBox!.values.toList();
    });
  }

  Future<void> loadExcelData() async {
    final ByteData data =
        await rootBundle.load('assets/excel/kmcc_health_care_centers.xlsx');
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final e.Excel excel = e.Excel.decodeBytes(bytes);

    List<HealthCenterModel> tempList = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows.skip(1)) {
        tempList.add(HealthCenterModel(
          E: row[0]?.value?.toString() ?? '',
          N: row[1]?.value?.toString() ?? '',
          Street: row[2]?.value?.toString() ?? '',
          Camp: row[3]?.value?.toString() ?? '',
          Centre: row[4]?.value?.toString() ?? '',
          Category: row[5]?.value?.toString() ?? '',
        ));
      }
    }
    for (var healthModel in tempList) {
      await healthBox!.add(healthModel);
    }
    isLoading = false;
    setState(() {});
  }

  void _filterClinics() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredClinicData = healthBox!.values.where((camp) {
        return camp.Centre.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _openMap(HealthCenterModel healthCenter) {
    final String latitude = healthCenter.N;
    final String longitude = healthCenter.E;
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
  void dispose() {
    searchController.removeListener(_filterClinics);
    searchController.dispose();
    super.dispose();
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
                  'Health Care Centers',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF)),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // Search Bar for Poll Number
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFFFFFF),
              border: Border.all(
                  color: const Color(0xFF1A737E), width: 2), // Border color
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search Health Centers...',
                hintStyle: TextStyle(color: Color(0xFF000000)),
                border: InputBorder.none,
                icon: Icon(
                  Icons.search,
                  color: Color(0xFF1A737E),
                ),
              ),
            ),
          ),
          // Search Bar

          const SizedBox(
            height: 8,
          ),

          Container(
            color: Colors.grey[200],
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0, bottom: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    width: 2,
                  ),
                  _buildTableHeader('Category'),
                  const SizedBox(
                    width: 2,
                  ),
                  _buildTableHeader('Centre'),
                  const SizedBox(
                    width: 2,
                  ),
                  _buildTableHeader('Poll'),
                  const SizedBox(
                    width: 80,
                  ),
                ],
              ),
            ),
          ),

          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A737E),
                    ),
                  ),
                )
              : filteredClinicData.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text("No results found!",
                          style: TextStyle(fontSize: 16)))
                  : _campsResult()
        ],
      ),
    );
  }

  Widget _campsResult() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: filteredClinicData.map((healthCare) {
                  return Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTableCell(healthCare.Category),
                            _buildTableCell(healthCare.Centre),
                            _buildTableCell(
                                '${healthCare.Camp}/${healthCare.Street}'),
                            _buildDirectionCell(healthCare)
                          ],
                        ),
                        Divider(color: Colors.grey.withOpacity(0.3)),
                        // Reduced opacity divider
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader(String title) {
    return Container(
      padding: EdgeInsets.all(8.0),
      width: 90,
      child: Center(
        child: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      width: 80,
      child: Center(
        child: Text(
          value,
        ),
      ),
    );
  }

  Widget _buildDirectionCell(clinic) {
    return GestureDetector(
        onTap: () => _openMap(clinic),
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 12.0),
          width: 80,
          child: const Center(
            child: Column(children: [
              Icon(
                Icons.directions_rounded,
                color: Color(0xFF1A737E),
              ),
              Text(
                "Direction",
                style: TextStyle(fontSize: 10),
              )
            ]),
          ),
        ));
  }
}
