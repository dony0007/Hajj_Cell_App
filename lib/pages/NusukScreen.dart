import 'package:flutter/material.dart';
import 'package:hidayath/model/nusuk_model.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:flutter/services.dart';
import 'package:excel/excel.dart' as e;
import 'package:url_launcher/url_launcher.dart';

class NusukScreen extends StatefulWidget {
  const NusukScreen({super.key});

  @override
  State<NusukScreen> createState() => _NusukScreenState();
}

class _NusukScreenState extends State<NusukScreen> {
  Box<NusukModel>? nusukBox;
  List<NusukModel> filteredNusuksData = [];
  TextEditingController nusukSearchController = TextEditingController();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    openBox();
    nusukSearchController.addListener(_filterNusuks);
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    nusukBox = await Hive.openBox<NusukModel>('nusuksBox');
    if (nusukBox != null && nusukBox!.isEmpty) {
      await loadExcelData();
    } else {
      isLoading = false;
    }
    setState(() {
      filteredNusuksData = nusukBox!.values.toList();
    });
  }

  Future<void> loadExcelData() async {
    final ByteData data =
    await rootBundle.load('assets/excel/kmcc_nusuk.xlsx');
    final List<int> bytes =
    data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final e.Excel excel = e.Excel.decodeBytes(bytes);

    List<NusukModel> tempList = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      for (var row in sheet!.rows.skip(2)) {
        tempList.add(NusukModel(
            E: row[0]?.value?.toString() ?? '',
            N: row[1]?.value?.toString() ?? '',
            Street: row[2]?.value?.toString() ?? '',
            Camp: row[3]?.value?.toString() ?? '',
            Category: row[4]?.value?.toString() ?? '',
            Arabic: row[5]?.value?.toString() ?? '',
            Centre: row[6]?.value?.toString() ?? ''
        ));
      }
    }
    for (var nusukModel in tempList) {
      await nusukBox!.add(nusukModel);
    }
    isLoading = false;
    setState(() {});
  }

  void _filterNusuks() {
    String query = nusukSearchController.text.toLowerCase();
    setState(() {
      filteredNusuksData.clear();
      filteredNusuksData = nusukBox!.values.where((camp) {
        return camp.Centre.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _openMap(NusukModel building) {
    final String latitude = building.N;
    final String longitude = building.E;
    final String googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=$latitude,$longitude";

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
                  'Nusuk Care Center',
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
              controller: nusukSearchController,
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
                  _buildTableHeader('Nusuk Care Center (Mina)'),
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
        child: filteredNusuksData.isEmpty
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
            : _buildingsList(filteredNusuksData),
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
              if (items[index].E == "" || items[index].N == "") {
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
                  color: items[index].E == "" || items[index].N == ""
                      ? const Color(0xFFDCDCDC)
                      : const Color(0xFFFFFFFF),
                  child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Nusuk No.",
                            style: TextStyle(color: Color(0xFF1A737E)),
                          ),
                          Text(
                            items[index].Centre,
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
}
