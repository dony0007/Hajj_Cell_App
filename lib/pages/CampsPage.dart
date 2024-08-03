import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:excel/excel.dart' as e;
import 'package:hive_flutter/adapters.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/data_model.dart';

class CampsPage extends StatefulWidget {
  final String country, category;

  const CampsPage({super.key, required this.country, required this.category});

  @override
  _CampsPageState createState() => _CampsPageState();
}

class _CampsPageState extends State<CampsPage> {
  Box<DataModel>? dataBox;
  List<DataModel> filteredCampsData = [];
  bool isLoading = true;

  // final List<Map<String, String>> campsData = [
  //   {"Maktab": "1-2B", "Camp": "2/62", "Zone": "2", "latitude":"21.41674", "longitude":"39.89767"},
  //   {"Maktab": "11", "Camp": "12/62", "Zone": "2", "latitude":"21.42393", "longitude":"39.87371"},
  //   {"Maktab": "27A", "Camp": "13/62", "Zone": "2", "latitude":"21.42114", "longitude":"39.89699"},
  //   {"Maktab": "27B", "Camp": "1/513", "Zone": "5", "latitude":"21.41834", "longitude":"39.89599"},
  // ];

  TextEditingController searchController = TextEditingController();
  TextEditingController pollSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    openBox();
    searchController.addListener(_filterCamps);
    pollSearchController.addListener(_filterCamps);
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    final String boxName = '${widget.country}${widget.category.replaceAll(" ", '').replaceAll('–', '')}Box';
    print(boxName);
    dataBox = await Hive.openBox<DataModel>(boxName);
    if ( dataBox != null && dataBox!.isEmpty) {
      await loadExcelData();
    } else {
      isLoading = false;
    }
    setState(() {
      filteredCampsData = dataBox!.values
          .where((data) => data.Country.contains(widget.country) && data.Category.contains(widget.category))
          .toList();
    });
  }

  Future<void> loadExcelData() async {
    final ByteData data =
        await rootBundle.load('assets/excel/kmcc_mina24_new.xlsx');
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final e.Excel excel = e.Excel.decodeBytes(bytes);

    List<DataModel> tempList = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows.skip(1)) {
        tempList.add(DataModel(
          E: row[0]?.value?.toString() ?? '',
          N: row[1]?.value?.toString() ?? '',
          Zone: row[2]?.value?.toString() ?? '',
          Street: row[3]?.value?.toString() ?? '',
          Camp: row[4]?.value?.toString() ?? '',
          Arabic: row[5]?.value?.toString() ?? '',
          Makthab: row[6]?.value?.toString() ?? '',
          Country: row[7]?.value?.toString() ?? '',
          Category: row[8]?.value?.toString() ?? '',
        ));
      }
    }

    for (var dataModel in tempList) {
      await dataBox!.add(dataModel);
    }
    isLoading = false;
    setState(() {});
  }

  void _filterCamps() {
    String query1 = searchController.text.toLowerCase();
    String query2 = pollSearchController.text.toLowerCase();
    setState(() {
      filteredCampsData.clear();
      filteredCampsData = dataBox!.values.where((camp) {
        var cmp = "${camp.Camp}/${camp.Street}";
        return camp.Country.contains(widget.country) &&
            camp.Makthab.toLowerCase().contains(query1) &&
            cmp.toLowerCase().contains(query2);
      }).toList();
    });
  }

  void _onRowTap(BuildContext context, Map<String, String> camp) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CampDetailsPage(camp: camp),
      ),
    );
  }

  void _openMap(DataModel record) {
    final String latitude = record.N;
    final String longitude = record.E;
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
    searchController.removeListener(_filterCamps);
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
          Container(
            color: const Color(0xFF1A737E),
            width: double.infinity,
            padding: const EdgeInsets.only(
                left: 16.0, right: 16.0, bottom: 8.0, top: 8.0),
            child: Row(
              children: [
                GestureDetector(
                  child: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.white,
                  ),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const Text(
                  'Camps Allotted',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFF)),
                ),
              ],
            ),
          ),
          Padding(
              padding: const EdgeInsets.only(top: 8, bottom: 8, left: 0),
              child: Column(
                children: [
                  // Search Bar for Maktab
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(
                          color: const Color(0xFF1A737E),
                          width: 2), // Border color
                    ),
                    child: TextField(
                      controller: searchController,
                      decoration: const InputDecoration(
                        hintText: 'Search Maktabs...',
                        hintStyle: TextStyle(color: Color(0x66000000)),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Color(0xFF1A737E),
                        ),
                      ),
                    ),
                  ),
                  // Spacer(flex: 1,),
                  // Search Bar

                  const SizedBox(
                    height: 10,
                  ),

                  // Search Bar for Poll Number
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFFFFFFFF),
                      border: Border.all(
                          color: const Color(0xFF1A737E),
                          width: 2), // Border color
                    ),
                    child: TextField(
                      controller: pollSearchController,
                      decoration: const InputDecoration(
                        hintText: 'Search Polls...',
                        hintStyle: TextStyle(color: Color(0x66000000)),
                        border: InputBorder.none,
                        icon: Icon(
                          Icons.search,
                          color: Color(0xFF1A737E),
                        ),
                      ),
                    ),
                  ),
                  // Spacer(flex: 1,),
                  // Search Bar
                ],
              )),
          Container(
            color: Colors.grey[200],
            child: Row(
              children: [
                _buildTableHeader('Maktab'),
                _buildTableHeader('Poll'),
                _buildTableHeader('Zone'),
              ],
            ),
          ),
          const SizedBox(
            height: 8,
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
              : filteredCampsData.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.only(top: 12.0),
                      child: Text(
                        "No results found!",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  : _campResults()
        ],
      ),
    );
  }

  Widget _campResults() {
    return Expanded(
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Column(
                children: filteredCampsData.map((camp) {
                  return Column(children: [
                    Row(
                      children: [
                        _buildTableCell(camp.Makthab),
                        _buildTableCell(camp.Camp + "/" + camp.Street),
                        _buildZoneCell(camp.Zone),
                        _buildDirectionCell(camp)
                      ],
                    ),
                    Divider(color: Colors.grey.withOpacity(0.3))
                  ]);
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
      padding: const EdgeInsets.fromLTRB(6, 12, 6, 12.0),
      width: 100,
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildTableCell(String value) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: 100,
      child: Center(
        child: Text(
          value,
        ),
      ),
    );
  }

  Widget _buildDirectionCell(camp) {
    return GestureDetector(
        onTap: () => _openMap(camp),
        child: Container(
          padding: const EdgeInsets.fromLTRB(6, 12, 6, 12.0),
          width: 100,
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

  Widget _buildZoneCell(String value) {
    return Container(
      padding: const EdgeInsets.only(left: 32.0),
      width: 80,
      child: Center(
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          decoration: BoxDecoration(
            color: switch (value) {
              '1' => Colors.yellow,
              '2' => Colors.orange,
              '3' => Colors.red,
              '4' => Colors.purple,
              '5' => Colors.pink,
              '6' => Colors.lightGreen,
              '7' => Colors.green,
              // TODO: Handle this case.
              String() => throw UnimplementedError(),
            },
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: Center(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}

class CampDetailsPage extends StatelessWidget {
  final Map<String, String> camp;

  CampDetailsPage({required this.camp});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Camp Details'),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Maktab: ${camp['Maktab']}',
                style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Camp: ${camp['Camp']}', style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 8),
            Text('Zone: ${camp['Zone']}', style: const TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
