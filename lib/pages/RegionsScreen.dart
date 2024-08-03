import 'dart:ui';

import 'package:excel/excel.dart' as e;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:hidayath/pages/CampsPage.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

import '../model/country_model.dart';
import '../model/regions_model.dart';

class RegionsPage extends StatefulWidget {
  const RegionsPage({super.key});

  @override
  State<RegionsPage> createState() => _RegionsPageState();
}

class _RegionsPageState extends State<RegionsPage> {
  Box<CountryModel>? regionsBox;
  Map<String, List<CountryModel>> categorizedRegionsData = {};
  TextEditingController searchController = TextEditingController();
  String searchQuery = '';
  bool isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    openBox();
    searchController.addListener(onSearchTextChanged);
  }

  @override
  void dispose() {
    searchController.removeListener(onSearchTextChanged);
    searchController.dispose();
    super.dispose();
  }

  Future<void> openBox() async {
    await Hive.initFlutter();
    regionsBox = await Hive.openBox<CountryModel>('regionBoxx');
    if (regionsBox != null && regionsBox!.isEmpty) {
      await loadExcelData();
    } else {
      isLoading = false;
    }
    categorizeData();
    setState(() {});
    print('Loaded from Hive:');
    categorizedRegionsData.forEach((category, regions) {
      print('Category: $category');
      for (var item in regions) {
        print('  ${item.Country}');
      }
    });
  }

  Future<void> loadExcelData() async {
    final ByteData data =
        await rootBundle.load('assets/excel/kmcc_regions_new.xlsx');
    final List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
    final e.Excel excel = e.Excel.decodeBytes(bytes);

    List<CountryModel> tempList = [];
    for (var table in excel.tables.keys) {
      var sheet = excel.tables[table];
      if (sheet == null) continue;
      for (var row in sheet.rows.skip(1)) {
        tempList.add(CountryModel(
          Arabic: row[0]?.value?.toString() ?? '',
          Country: row[1]?.value?.toString() ?? '',
          Category: row[2]?.value?.toString() ?? '',
        ));
        print(
            'Loaded row: ${row[0]?.value?.toString()} - ${row[1]?.value?.toString()} - ${row[2]?.value?.toString()}');
      }
    }
    for (var CountryModel in tempList) {
      await regionsBox?.add(CountryModel);
      print(
          'Saved to Hive: ${CountryModel.Category} - ${CountryModel.Country}');
    }
    categorizeData();
    isLoading = false;
    setState(() {});
  }

  void categorizeData() {
    categorizedRegionsData.clear();
    if (regionsBox != null) {
      for (var region in regionsBox!.values) {
        if (categorizedRegionsData.containsKey(region.Category)) {
          categorizedRegionsData[region.Category]!.add(region);
        } else {
          categorizedRegionsData[region.Category] = [region];
        }
      }
    }
  }

  void onSearchTextChanged() {
    setState(() {
      searchQuery = searchController.text.toLowerCase();
    });
  }

  List<CountryModel> getFilteredRegions() {
    if (searchQuery.isEmpty) {
      return regionsBox?.values.toList() ?? [];
    } else {
      return regionsBox?.values
              .where((region) =>
                  region.Country.toLowerCase().contains(searchQuery))
              .toList() ??
          [];
    }
  }

  Map<String, List<CountryModel>> getCategorizedFilteredRegions() {
    Map<String, List<CountryModel>> filteredData = {};
    var filteredRegions = getFilteredRegions();
    for (var region in filteredRegions) {
      if (filteredData.containsKey(region.Category)) {
        filteredData[region.Category]!.add(region);
      } else {
        filteredData[region.Category] = [region];
      }
    }
    return filteredData;
  }

  Future<bool> doesAssetExist(String assetPath) async {
    try {
      await rootBundle.load(assetPath);
      return true;
    } catch (_) {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    var categorizedFilteredRegionsData = getCategorizedFilteredRegions();

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
          //Title Card
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
                  child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                ),
                const SizedBox(width: 8.0),
                const Text(
                  'Select Regions',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFFFFFF)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          //Search Bar
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFFFFFFFFF),
              border: Border.all(
                  color: const Color(0xFF1A737E), width: 2), // Border color
            ),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search Regions...',
                hintStyle: TextStyle(color: Color(0x66000000)),
                border: InputBorder.none,
                icon: Icon(Icons.search, color: Color(0xFF1A737E)),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  isLoading
                      ? const Padding(
                          padding: EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(
                              color: Color(0xFF1A737E),
                            ),
                          ),
                        )
                      : categorizedFilteredRegionsData.isEmpty
                          ? const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  'No results found',
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            )
                          : buildCategoryView(categorizedFilteredRegionsData),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCategoryView(Map<String, List<CountryModel>> categorizedRegions) {
    if (categorizedRegions.isEmpty) {
      return const Center(
        child: Text(
          'No results found',
          style: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
        ),
      );
    }

    return Column(
      children: categorizedRegions.entries.map((entry) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 24.0, top: 16, bottom: 8),
              child: Text(
                entry.key,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            buildHorizontalGridView(entry.value),
          ],
        );
      }).toList(),
    );
  }

  Widget buildHorizontalGridView(List<CountryModel> regions) {
    return SizedBox(
      height: 160, // Set a fixed height for the horizontal scroll view
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: regions.length,
        itemBuilder: (context, index) {
          final region = regions[index];
          final isFirst = index == 0;
          final isLast = index == regions.length - 1;
          print("regions/${region.Country.trim().toLowerCase()}.png");

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => CampsPage(country: region.Country.trim(), category: region.Category.trim(),)),
              );
            },
            child: Container(
              width: 120,
              // Set a fixed width for each container
              margin: EdgeInsets.only(
                left: isFirst ? 22.0 : 8.0,
                right: isLast ? 22.0 : 8.0,
                top: 4.0,
                bottom: 4.0,
              ),
              padding: const EdgeInsets.fromLTRB(11, 14, 11, 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFF1A737E), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFFFF),
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(
                            color: const Color(0x80777777), width: 1),
                      ),

                      //Image Loading
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/regions/${regions[index].Country.trim().toLowerCase()}.png',
                          width: 55,
                          height: 55,
                          fit: BoxFit.cover,
                          errorBuilder: (BuildContext context, Object exception,
                              StackTrace? stackTrace) {
                            return Image.asset(
                              'assets/images/regions/error.png',
                              width: 55,
                              height: 55,
                              fit: BoxFit.cover,
                            );
                          },
                        ),
                      )),
                  const SizedBox(height: 8.0),
                  Text(
                    region.Country,
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontSize: 16),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    region.Arabic,
                    style: const TextStyle(color: Colors.black),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
