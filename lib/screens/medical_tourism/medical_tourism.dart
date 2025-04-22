import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';
import 'medical_tourism_model.dart';

class MedicalTourismScreen extends StatefulWidget {
  const MedicalTourismScreen({super.key});

  @override
  State<MedicalTourismScreen> createState() => _MedicalTourismScreenState();
}

class _MedicalTourismScreenState extends State<MedicalTourismScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final Dio dio = Dio();
  bool isLoading = true;
  List<MedicalTourism> topTreatments = [];
  List<MedicalTourism> facilities = [];
  List<MedicalTourism> insurances = [];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    fetchMedicalTourismData();
  }

  Future<void> fetchMedicalTourismData() async {
    try {
      final response = await dio.get(
        "https://meditrinainstitute.com/report_software/api/get_medical_tourism.php",
      );
      if (response.statusCode == 200) {
        final model = MedicalTourismsModel.fromJson(response.data);
        setState(() {
          topTreatments =
              model.data.where((e) => e.category == "Top Treatments").toList();
          facilities =
              model.data.where((e) => e.category == "Facilities").toList();
          insurances = model.data
              .where((e) => e.category == "Medical Insurance")
              .toList();
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildHtmlList(List<MedicalTourism> items) {
    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Html(data: item.details),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: const Text("Medical Tourism"),
        backgroundColor: const Color(0xFF08A4C4),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: "Top Treatment"),
            Tab(text: "Facilities"),
            Tab(
              text: "Medical Insurance",
            ),
          ],
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : TabBarView(
              controller: _tabController,
              children: [
                buildHtmlList(topTreatments),
                buildHtmlList(facilities),
                buildHtmlList(insurances),
              ],
            ),
    );
  }
}
