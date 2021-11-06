import 'package:flutter/material.dart';
import 'package:gdscworkshop/src/core/models/crime_location_model.dart';
import 'package:gdscworkshop/src/helpers/widgets/app_cards.dart';
import 'package:gdscworkshop/src/provider/map_provider.dart';
import 'package:provider/provider.dart';
import '../utils/app_extenstions_util.dart';

class CrimeLocationList extends StatefulWidget {
  @override
  _CrimeLocationListState createState() => _CrimeLocationListState();
}

class _CrimeLocationListState extends State<CrimeLocationList> {
  @override
  Widget build(BuildContext context) {
    List<CrimeLocationModel> data = context.watch<MapProvider>().crimeLocations;
    return ListView.builder(
      physics:
          const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      itemCount: data.length,
      itemBuilder: (context, index) => LocationCards(
        imageUrl: data[index].crimeImages!.first,
        coordinates:
            data[index].latitude.toString() & data[index].longitude.toString(),
      ),
    );
  }
}
