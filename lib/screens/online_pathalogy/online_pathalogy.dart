import 'package:flutter/material.dart';
import 'package:meditrina_01/screens/drawers/drawer.dart';

class OnlinePathalogy extends StatefulWidget {
  const OnlinePathalogy({super.key});

  @override
  State<OnlinePathalogy> createState() => _OnlinePathalogyState();
}

class _OnlinePathalogyState extends State<OnlinePathalogy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text("Online Pathalogy"),
      ),
    );
  }
}
