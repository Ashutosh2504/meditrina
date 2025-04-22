import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/packages/package_details.dart';
import 'package:meditrina_01/screens/packages/packages_model.dart';

class PackagesScreen extends StatefulWidget {
  @override
  _PackagesScreenState createState() => _PackagesScreenState();
}

class _PackagesScreenState extends State<PackagesScreen> {
  late Future<PackagesModel?> futurePackages;
  final Dio _dio = Dio();
  Color color = const Color.fromARGB(
    255,
    8,
    164,
    196,
  );

  @override
  void initState() {
    super.initState();
    futurePackages = fetchPackages();
  }

  Future<PackagesModel?> fetchPackages() async {
    const url =
        'https://meditrinainstitute.com/report_software/api/get_packages.php';

    try {
      final response = await _dio.get(url);
      if (response.statusCode == 200) {
        return PackagesModel.fromJson(response.data);
      }
    } catch (e) {
      print('Dio error: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: color,
        title: Text(
          'Promotions & Packages',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
      body: FutureBuilder<PackagesModel?>(
        future: futurePackages,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null) {
            return Center(child: Text('Failed to load packages.'));
          }
          final packages = snapshot.data!.data;
          return ListView.builder(
            itemCount: packages.length,
            itemBuilder: (context, index) {
              final package = packages[index];
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          PackageDetailScreen(package: package),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  child: Image.network(
                    package.logo,
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
