import 'package:flutter/material.dart';
import 'package:hidayath/model/ambulance_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart' as e;
import 'package:url_launcher/url_launcher.dart';

class AmbulanceScreen extends StatefulWidget {
  const AmbulanceScreen({super.key});

  @override
  State<AmbulanceScreen> createState() => _AmbulanceScreenState();
}

class _AmbulanceScreenState extends State<AmbulanceScreen> {
  Box<AmbulanceModel>? ambulanceBox;
  List<AmbulanceModel> filteredAmbulanceData = [];
  TextEditingController searchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    openBox();
    searchController.addListener(_filterAmbulances);
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    ambulanceBox = await Hive.openBox<AmbulanceModel>('ambulanceBox');
    if (ambulanceBox != null && ambulanceBox!.isEmpty) {
      await loadExcelData();
    } else {
      isLoading = false;
    }
    setState(() {
      filteredAmbulanceData = ambulanceBox!.values.toList();
    });
  }

  Future<void> loadExcelData() async {
    final ByteData data =
    await rootBundle.load('assets/excel/kmcc_ambulance.xlsx');
    final List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final e.Excel excel = e.Excel.decodeBytes(bytes);

    List<AmbulanceModel> tempList = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows.skip(1)) {
        tempList.add(AmbulanceModel(
          E: row[0]?.value?.toString() ?? '',
          N: row[1]?.value?.toString() ?? '',
          Street: row[2]?.value?.toString() ?? '',
          Camp: row[3]?.value?.toString() ?? '',
          Centre: row[4]?.value?.toString() ?? '',
          Category: row[5]?.value?.toString() ?? '',
        ));
      }
    }
    for (var ambulanceModel in tempList) {
      await ambulanceBox!.add(ambulanceModel);
    }
    isLoading = false;
    setState(() {});
  }

  void _filterAmbulances() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredAmbulanceData = ambulanceBox!.values.where((camp) {
        return camp.Centre.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _openMap(AmbulanceModel ambulance) {
    final String latitude = ambulance.N;
    final String longitude = ambulance.E;
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
    searchController.removeListener(_filterAmbulances);
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
                  ' Red Crescent Ambulance Station',
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
                hintText: 'Search Ambulance...',
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
              : filteredAmbulanceData.isEmpty
              ? const Padding(
              padding: EdgeInsets.only(top: 12.0),
              child: Text("No results found!",
                  style: TextStyle(fontSize: 16)))
              : _ambulanceResult()
        ],
      ),
    );
  }

  Widget _ambulanceResult() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: Colors.white,
              child: Column(
                children: filteredAmbulanceData.map((ambulance) {
                  return Card(
                    elevation: 0,
                    color: Colors.transparent,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _buildTableCategoryCell(ambulance.Category.trim()),
                            _buildTableCell(ambulance.Centre),
                            _buildTableCell(
                                '${ambulance.Camp}/${ambulance.Street}'),
                            _buildDirectionCell(ambulance)
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

  Widget _buildTableCategoryCell(String value) {
    return Container(
      padding: EdgeInsets.fromLTRB(8.0, 5.0, 8.0, 5.0),
      width: 100,
      child: Center(
        child: Text(
          value,
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

  Widget _buildDirectionCell(ambulance) {
    return GestureDetector(
        onTap: () => _openMap(ambulance),
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
