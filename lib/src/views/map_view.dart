import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../helpers/common/color_palette.dart';
import '../provider/map_provider.dart';
import '../utils/app_navigation.dart';
import 'add_crime_location.dart';

class MapPage extends StatefulWidget {
  const MapPage({Key? key}) : super(key: key);
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: context.watch<MapProvider>().currentUserLocation == null
            ? const Center(
                child: CircularProgressIndicator.adaptive(),
              )
            : Stack(
                children: [
                  GoogleMap(
                    mapType: MapType.normal,
                    markers: Set.from(context.watch<MapProvider>().markers),
                    circles: Set.from(context.read<MapProvider>().circles),
                    zoomGesturesEnabled: true,
                    myLocationEnabled: true,
                    scrollGesturesEnabled: true,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(-25.7585829, 28.0578646),
                      zoom: 10,
                    ),
                  ),
                  Positioned(
                      bottom: MediaQuery.of(context).size.height * .15,
                      right: MediaQuery.of(context).size.width * .02,
                      child: FloatingActionButton(
                        backgroundColor: Palette.primaryColor,
                        onPressed: () => appNavigatorPush(
                            context: context, path: AddCrimeLocation()),
                        child: Icon(Icons.add),
                      ))
                ],
              ));
  }
}
