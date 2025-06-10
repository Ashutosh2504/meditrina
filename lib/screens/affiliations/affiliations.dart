import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:meditrina_01/screens/affiliations/affiliations_info.dart';
import 'package:meditrina_01/screens/affiliations/affiliations_model.dart';
// Ensure this is the file where your model is defined

class AffiliationsScreen extends StatefulWidget {
  const AffiliationsScreen({super.key});

  @override
  State<AffiliationsScreen> createState() => _AffiliationsScreenState();
}

class _AffiliationsScreenState extends State<AffiliationsScreen> {
  List<Affiliation> _affiliations = [];
  Color color = const Color.fromARGB(255, 8, 164, 196);

  bool _isLoading = true;

  void fetchAffiliations() async {
    try {
      final response = await Dio().get(
        'https://meditrinainstitute.com/report_software/api/logo_api.php?logo_type=Affiliations',
      );

      if (response.statusCode == 200) {
        final model = affiliationsModelFromJson(jsonEncode(response.data));
        setState(() {
          _affiliations = model.data;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load affiliations');
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAffiliations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
          backgroundColor: color,
          title: Text(
            'Affiliations',
            style: TextStyle(color: Colors.white),
          )),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _affiliations.isEmpty
              ? Center(child: Text('No data found'))
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _affiliations.length,
                  itemBuilder: (context, index) {
                    final item = _affiliations[index];
                    return GestureDetector(
                      onTap: () {
                        // Navigator.push(
                        //   context,
                        //   MaterialPageRoute(
                        //     builder: (context) =>
                        //         AffiliationDetailsScreen(affiliation: item),
                        //   ),
                        // );
                      },
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 4,
                              offset: Offset(0, 2),
                            ),
                          ],
                        ),
                        padding: const EdgeInsets.all(12),
                        child: AspectRatio(
                          aspectRatio: 2 / 1,
                          child: Image.network(
                            item.logo,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) =>
                                Icon(Icons.broken_image),
                          ),
                        ),
                        // const SizedBox(height: 8),
                        // Text(
                        //   item.logoName,
                        //   style: TextStyle(
                        //     fontSize: 16,
                        //     fontWeight: FontWeight.w500,
                        //   ),
                        //   textAlign: TextAlign.center,
                        // ),
                      ),
                    );
                  },
                ),
    );
  }
}
