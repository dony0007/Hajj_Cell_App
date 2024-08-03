import 'package:excel/excel.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hidayath/model/building_model.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

class BuildingsPage extends StatefulWidget {
  const BuildingsPage({super.key});

  @override
  State<BuildingsPage> createState() => _BuildingsPageState();
}

class _BuildingsPageState extends State<BuildingsPage> {
  Box<BuildingModel>? buildingBox;
  List<BuildingModel> filteredBuildingsData = [];
  TextEditingController buildingSearchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    openBox();
    buildingSearchController.addListener(_filterBuildings);
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    buildingBox = await Hive.openBox<BuildingModel>('buildingsBox');
    if (buildingBox != null && buildingBox!.isEmpty) {
      await loadExcelData();
    } else {
      isLoading = false;
    }
    setState(() {
      filteredBuildingsData = buildingBox!.values.toList();
    });
  }

  Future<void> loadExcelData() async {
    final ByteData data =
        await rootBundle.load('assets/excel/kmcc_azizia_buildings_new.xlsx');
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final e.Excel excel = e.Excel.decodeBytes(bytes);

    List<BuildingModel> tempList = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows.skip(2)) {
        tempList.add(BuildingModel(
          BuildingNo: row[0]?.value?.toString() ?? '',
          Link: row[1]?.value?.toString() ?? '',
          N: row[2]?.value?.toString() ?? '',
          E: row[3]?.value?.toString() ?? '',
        ));
      }
    }
    for (var healthModel in tempList) {
      await buildingBox!.add(healthModel);
    }
    isLoading = false;
    setState(() {});
  }

  void _filterBuildings() {
    String query = buildingSearchController.text.toLowerCase();
    setState(() {
      filteredBuildingsData.clear();
      filteredBuildingsData = buildingBox!.values.where((camp) {
        return camp.BuildingNo.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _openMap(BuildingModel building) {
    final String latitude = building.N;
    final String longitude = building.E;
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

    final String link = building.Link;
    final String mapsUrl = link;

    if (latitude.isNotEmpty && longitude.isNotEmpty) {
      launchUrl(Uri.parse(googleMapsUrl));
    } else {
      // Show a snackbar or some other error message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location Unavailable!')),
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
          //TitleCard
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
                  'Building',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFF8F7EA)),
                ),
              ],
            ),
          ),

          const SizedBox(
            height: 8,
          ),

          // Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFFFFFF),
              border: Border.all(
                  color: const Color(0xFF29A7B7), width: 2), // Border color
            ),
            child: TextField(
              controller: buildingSearchController,
              decoration: const InputDecoration(
                hintText: 'Search Building Numbers...',
                hintStyle: TextStyle(color: Color(0x66000000)),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF29A7B7)),
              ),
            ),
          ),

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
                  _buildTableHeader('Building Numbers (Azizia)'),
                ],
              ),
            ),
          ),

          // Expanded(
          //   child: SingleChildScrollView(
          //     scrollDirection: Axis.vertical,
          //     child: Column(
          //       crossAxisAlignment: CrossAxisAlignment.start,
          //       children: [
          //         Container(
          //           color: Colors.white,
          //           child: Column(
          //             children: filteredBuildingsData.map((healthCare) {
          //               return GestureDetector(
          //                 onTap: () => _openMap(healthCare),
          //                 child: Card(
          //                   elevation: 0,
          //                   color: Colors.transparent,
          //                   child: Column(
          //                     children: [
          //                       Row(
          //                         mainAxisAlignment: MainAxisAlignment.center,
          //                         children: [
          //                           _buildTableCell(healthCare.BuildingNo),
          //                         ],
          //                       ),
          //                       Divider(color: Colors.grey.withOpacity(0.3)), // Reduced opacity divider
          //                     ],
          //                   ),
          //                 ),
          //               );
          //             }).toList(),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),

          isLoading
              ? const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1A737E),
                    ),
                  ),
                )
              : _gridView(context)
        ],
      ),
    );
  }

  Widget _gridView(BuildContext context) {
    // GridView
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 2.0, left: 20, right: 20),
        child: filteredBuildingsData.isEmpty
            ? const Padding(
                padding: EdgeInsets.only(top: 12.0),
                child: Text(
                  'No results found',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              )
            : _buildingsList(filteredBuildingsData),
      ),
    );
    // GridView
  }

  Widget _buildingsList(filteredBuildingsData) {
    return GridView.builder(
        itemCount: filteredBuildingsData.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (context, index) {
          final items = filteredBuildingsData;
          return GestureDetector(
            onTap: () {
              if (items[index].Link == "") {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Location currently unavailable!"),
                  ),
                );
              } else {
                _openMap(items[index]);
              }
            },
            child: Container(
              height: 50,
              child: Padding(
                padding: const EdgeInsets.all(5.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                    // Rounded corners
                    side: const BorderSide(
                      color: Color(0xFF1A737E), // Border color
                      width: 2.0, // Border width
                    ),
                  ),
                  color: items[index].Link == ""
                        ? const Color(0xFFDCDCDC)
                        : const Color(0xFFFFFFFF),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Building",
                            style: TextStyle(color: Color(0xFF1A737E)),
                          ),
                          Text(
                            items[index].BuildingNo,
                            style: const TextStyle(
                                color: Color(0xFF1A737E),
                                fontSize: 30,
                                fontWeight: FontWeight.bold),
                          )
                        ]),
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget _buildTableHeader(String title) {
    return Container(
      padding: EdgeInsets.all(8.0),
      child: Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Color(0xFF1A737E)),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Container(
      padding: EdgeInsets.fromLTRB(16.0, 5.0, 16.0, 5.0),
      width: 100,
      child: Text(
        value,
      ),
    );
  }
}
