import 'package:flutter/material.dart';

import 'map_view.dart';

class HomeScreen extends StatefulWidget {
  final String? appBarTitle;
  HomeScreen({this.appBarTitle});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.appBarTitle ?? 'AppBar'),
      ),
      body: MapPage(),
    );
  }
}
