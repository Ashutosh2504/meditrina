import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditrina_01/screens/our_facilities/our_facilities_model.dart';

class OurFacilitiesScreen extends StatefulWidget {
  const OurFacilitiesScreen({super.key});

  @override
  State<OurFacilitiesScreen> createState() => _OurFacilitiesScreenState();
}

class _OurFacilitiesScreenState extends State<OurFacilitiesScreen> {
  List<FacilityModel> facilities = [];
  bool isLoading = true;
  final Dio dio = Dio();
  final Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  void initState() {
    super.initState();
    fetchFacilities();
  }

  Future<void> fetchFacilities() async {
    try {
      final response = await dio.get(
          'https://meditrinainstitute.com/report_software/api/logo_api.php?logo_type=Our Facilities');
      if (response.statusCode == 200) {
        final data = ourFacilitiesModelFromJson(response.toString());
        setState(() {
          facilities = data.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching facilities: $e");
      setState(() => isLoading = false);
    }
  }

  Widget buildGridWithSeparators() {
    if (facilities.isEmpty) {
      return const Center(child: Text("No facilities found"));
    }

    int columnCount =
        facilities.length == 1 ? 1 : (facilities.length == 2 ? 2 : 3);

    return Column(
      children: [
        for (int row = 0;
            row < (facilities.length / columnCount).ceil();
            row++) ...[
          IntrinsicHeight(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(columnCount, (col) {
                int index = row * columnCount + col;

                if (index >= facilities.length) {
                  return Expanded(child: Container());
                }

                final item = facilities[index];

                return Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border(
                        left: col == 0
                            ? BorderSide.none
                            : const BorderSide(color: Colors.black, width: 0.5),
                        bottom:
                            const BorderSide(color: Colors.black, width: 0.5),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Image.network(
                            item.logo,
                            width: 60,
                            height: 60,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.broken_image, size: 50),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            item.logoName,
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12, color: color),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Our Facilities"),
        backgroundColor: color,
        foregroundColor: Colors.white,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  // Header image
                  Container(
                    width: double.infinity,
                    height: 200,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/aabbuuss.jpg"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  // Grid content (no search field)
                  Expanded(
                    child: SingleChildScrollView(
                      child: buildGridWithSeparators(),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
