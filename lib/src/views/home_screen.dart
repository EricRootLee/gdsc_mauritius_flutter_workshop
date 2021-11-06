import 'package:flutter/material.dart';
import 'package:gdscworkshop/src/views/crime_location_list.dart';

import 'map_view.dart';

class HomeScreen extends StatefulWidget {
  final String? appBarTitle;
  HomeScreen({this.appBarTitle});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool showingMap = true;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(widget.appBarTitle ?? 'Crime Mapper'),
        actions: [
          IconButton(
              onPressed: () {
                setState(() {
                  showingMap = !showingMap;
                });
              },
              icon: Icon(Icons.switch_left_outlined))
        ],
      ),
      body:showingMap? MapPage():CrimeLocationList(),
    );
  }
}
