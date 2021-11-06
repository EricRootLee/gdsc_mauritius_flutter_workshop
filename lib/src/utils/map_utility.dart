import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_webservice/places.dart';

import '../core/data/network_datasource/database_client.dart';
import '../core/data/service/places_service.dart';
import '../core/models/crime_location_model.dart';
import '../helpers/common/app_constants.dart';
import '../helpers/widgets/adress_search.dart';
import '../utils/app_extenstions.dart';

class MapSerivce {
  MapSerivce(this.dataBase);
  FirebaseClient dataBase;
  GoogleMapsPlaces _places =
      GoogleMapsPlaces(apiKey: AppConstants.kGoogleApiKey);
  Future<Position> getUserCurrentLocation() async {
    return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  Future<PlacesDetailsResponse> searchPlace(context) async {
    final sessionToken = DateTime.now().microsecondsSinceEpoch.toString();
    final Suggestion? result = await showSearch(
      context: context,
      delegate: AddressSearch(sessionToken),
    );
    PlacesDetailsResponse detail =
        await _places.getDetailsByPlaceId(result!.placeId);

    return detail;
  }

  Future<List<Placemark>> getCurrentUserArea(lat, lng) async =>
      await placemarkFromCoordinates(lat, lng);

  static Future<String?> isAreaFrequentFlagged(
      double startLat, double startLng, List<CrimeLocationModel> places) async {
    String? reportCases = AppConstants.reportedCases;
    for (int i = 0; i < places.length; i++) {
      double distanceInMeters = Geolocator.distanceBetween(
          startLat, startLng, places[i].latitude!, places[i].longitude!);
      if (distanceInMeters < 500) {
        reportCases =
            (places[i].reportNumber! + 1).toString() & places[i].locationId!;
        log(AppConstants.reportedLocation & "${places[i].locationId}");
      }
    }
    return reportCases;
  }
}
