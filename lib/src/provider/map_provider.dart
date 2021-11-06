import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import 'package:permission_handler/permission_handler.dart';

import '../core/data/network_datasource/database_client.dart';
import '../core/models/crime_location_model.dart';
import '../core/models/entity/crime_location_update.dart';
import '../helpers/common/color_palette.dart';
import '../helpers/widgets/map_widgets.dart';
import '../utils/map_utility.dart';
import 'config/base_provider.dart';

class MapProvider extends BaseProvider {
  final _mapSerivce = MapSerivce(FirebaseClient(FirebaseFirestore.instance));
  BuildContext? context;

  Position? currentUserLocation;
  PlacesDetailsResponse? placedetails; //From Search
//From Gecoding
  List<DocumentSnapshot>? locationData;
  List<CrimeLocationModel> crimeLocations = <CrimeLocationModel>[];
  List<Marker> markers = [];
  List<Circle> circles = [];
  List<String>? uploadedImages;
  MapProvider() {
    fetchLocations();
  }

  Future<void> updateCurrentLocation() async {
    try {
      await Permission.location.request();
      if (await Permission.location.request().isGranted) {
        currentUserLocation = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);
        print(' BASE Provider = > ${this.currentUserLocation!.latitude}');
        markers.add(Marker(
          draggable: false,
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          markerId: MarkerId(this.currentUserLocation!.latitude.toString()),
          position: LatLng(this.currentUserLocation!.latitude,
              this.currentUserLocation!.longitude),
        ));
        notifyListeners();
      } else {
        currentUserLocation = null;
        notifyListeners();
      }
    } catch (e) {
      print(e);
      currentUserLocation = null;
      notifyListeners();
    }
    notifyListeners();
  }

  Future<void> getUserPlaceSearch(context) async {
    this.placedetails = await _mapSerivce.searchPlace(context);
    notifyListeners();
  }

  Future<void> saveLocationToDB(CrimeLocationModel data) async {
    _mapSerivce.dataBase
        .saveCrimeLocation(data)
        .then((value) => setBusy(false));
  }

  Future<List<String>?> uploadImages(List<Asset> data) async {
    return _mapSerivce.dataBase.uploadFiles(data).then((value) {
      this.uploadedImages = value;
      notifyListeners();
      return this.uploadedImages;
    });
  }

  Future<void> updateLocationToDB(CrimeLocationUpdateModel data) async {
    _mapSerivce.dataBase
        .updateCrimeLocation(data)
        .then((value) => setBusy(false));
  }

  Future<void>? fetchLocations() {
    _mapSerivce.dataBase.getCrimeLocations().listen((event) {
      this.crimeLocations.clear();
      this.markers.clear();
      this.circles.clear();
      event.docs.forEach((element) => crimeLocations
          .add(CrimeLocationModel.fromFirestore(element, element.id)));
      crimeLocations.forEach((element) {
        //Add Markers
        markers.add(Marker(
          onTap: () => mapWidgets(element, context!),
          draggable: false,
          icon: element.reportNumber! < 5
              ? BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen)
              : (element.reportNumber! >= 5 && element.reportNumber! < 20)
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueYellow)
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed),
          markerId: MarkerId(element.locationId.toString()),
          position: LatLng(element.latitude!, element.longitude!),
        ));
        //Add Circles
        circles.add(Circle(
          circleId: CircleId(element.locationId.toString()),
          center: LatLng(element.latitude!, element.longitude!),
          radius: 500,
          strokeColor: element.reportNumber! < 5
              ? Palette.green
              : (element.reportNumber! >= 5 && element.reportNumber! < 20)
                  ? Palette.yellow
                  : Palette.red,
          fillColor: element.reportNumber! < 5
              ? Palette.green
              : (element.reportNumber! >= 5 && element.reportNumber! < 20)
                  ? Palette.yellow
                  : Palette.red,
        ));
      });
      notifyListeners();
    });
    notifyListeners();
  }
}
