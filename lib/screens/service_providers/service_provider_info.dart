import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditrina_01/screens/service_providers/service_providers_model.dart';

class ServiceProvidersInfo extends StatefulWidget {
  final String logoType;

  const ServiceProvidersInfo({super.key, required this.logoType});

  @override
  State<ServiceProvidersInfo> createState() => _ServiceProvidersInfoState();
}

class _ServiceProvidersInfoState extends State<ServiceProvidersInfo> {
  List<ServiceProvider> providers = [];
  bool isLoading = true;
  Dio dio = Dio();
  Color color = const Color.fromARGB(255, 8, 164, 196);

  @override
  void initState() {
    super.initState();
    fetchProviders();
  }

  Future<void> fetchProviders() async {
    try {
      final response = await dio.get(
        "https://meditrinainstitute.com/report_software/api/get_service_provider_details.php?service_type=${widget.logoType}",
      );
      if (response.statusCode == 200) {
        final model = ServiceProvidersModel.fromJson(response.data);
        setState(() {
          providers = model.data;
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching service providers: $e');
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int crossAxisCount = 3;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text("${widget.logoType}",
            softWrap: true, style: const TextStyle(color: Colors.white)),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: GridView.builder(
                      padding: const EdgeInsets.all(0),
                      itemCount: providers.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 1,
                        mainAxisSpacing: 1,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (context, index) {
                        final item = providers[index];
                        final hasImage =
                            item.logo.isNotEmpty && item.logo != "null";

                        return Container(
                          color: Colors.white,
                          child: InkWell(
                            onTap: () {
                              // Handle tap
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border(
                                  top: BorderSide(
                                      color: (index < crossAxisCount)
                                          ? Colors.black
                                          : Colors.transparent,
                                      width: 0.5),
                                  left: BorderSide(
                                      color: (index % crossAxisCount == 0)
                                          ? Colors.black
                                          : Colors.transparent,
                                      width: 0.5),
                                  right: const BorderSide(
                                      color: Colors.black, width: 0.5),
                                  bottom: const BorderSide(
                                      color: Colors.black, width: 0.5),
                                ),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (hasImage)
                                      Image.network(
                                        item.logo,
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.contain,
                                        errorBuilder:
                                            (context, error, stackTrace) {
                                          // If image fails, skip rendering image
                                          return const SizedBox.shrink();
                                        },
                                      ),
                                    if (hasImage)
                                      const SizedBox(
                                        height: 8,
                                      ),
                                    Text(
                                      item.logoName,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: color,
                                      ),
                                      softWrap: true,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
