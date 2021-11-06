import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';

import 'provider/map_provider.dart';
import 'views/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Future<void>? initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) async {
      await _route();
    });
  }

  Future<void>? _route() {
    Timer(Duration(seconds: 2), () async {
      _checkPermission(HomeScreen());
    });
  }

  void _checkPermission(Widget navigateTo) async {
    LocationPermission permission = await Geolocator.checkPermission();

    await context.read<MapProvider>().updateCurrentLocation();
    if (permission == LocationPermission.denied) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (_) => AlertDialog(
                title: Text('Alert!'),
                content: Text(
                    'You have to allow all time permission to use this app. Please allow location permission for all the time.'),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                actions: [
                  ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      await Geolocator.requestPermission();

                      _checkPermission(navigateTo);
                    },
                    child: Text('Ok'),
                  )
                ],
              ));
    } else if (permission == LocationPermission.deniedForever) {
      await Geolocator.openLocationSettings();
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => navigateTo));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(
        child: SizedBox(
          height: 125,
          width: 125,
          child: FlutterLogo(
            size: 20,
          ),
        ),
      ),
    );
  }
}
