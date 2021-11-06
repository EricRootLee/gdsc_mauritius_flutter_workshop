import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_place_picker/google_maps_place_picker.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:provider/provider.dart';

import '../core/models/crime_location_model.dart';
import '../core/models/entity/crime_location_update.dart';
import '../helpers/common/app_constants.dart';
import '../helpers/common/color_palette.dart';
import '../helpers/widgets/app_text.dart';
import '../provider/map_provider.dart';
import '../utils/map_utility.dart';
import '../utils/media_utility.dart';

class AddCrimeLocation extends StatefulWidget {
  @override
  _AddCrimeLocationState createState() => _AddCrimeLocationState();
}

class _AddCrimeLocationState extends State<AddCrimeLocation> {
  List<Asset> images = <Asset>[];

  final TextEditingController _latController = TextEditingController();
  LatLng _kInitialMapPosition = LatLng(-25.7585829, 28.0578646);
  final TextEditingController _longController = TextEditingController();
  String? _locationAddress;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CustomTextTitle(
          text: AppConstants.addCrimePageTitle,
          color: Palette.white,
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.35,
              child: PlacePicker(
                apiKey: AppConstants.kGoogleApiKey!,
                selectInitialPosition: true,
                initialPosition: _kInitialMapPosition,
                useCurrentLocation: true,
                usePlaceDetailSearch: true,
                selectedPlaceWidgetBuilder:
                    (context, selectedPlace, state, isSearchBarFocused) {
                  WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
                    final location = selectedPlace?.geometry?.location;
                    if (location != null) {
                      _kInitialMapPosition = LatLng(location.lat, location.lng);
                      _latController.text = location.lat.toString();
                      _longController.text = location.lng.toString();

                      _locationAddress = selectedPlace!.formattedAddress!;
                    }
                  });
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Spacer(),
                      Container(
                        color: Colors.white,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 16.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${selectedPlace?.name ?? ''}",
                              textAlign: TextAlign.start,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "${selectedPlace?.formattedAddress ?? ''}",
                              style: Theme.of(context).textTheme.bodyText1!,
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  child: images.isEmpty
                      ? Stack(
                          children: <Widget>[
                            Container(
                              color: Palette.grey,
                              height: MediaQuery.of(context).size.height * 0.25,
                              child: Center(
                                child: Text(
                                  AppConstants.noImageSelected,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Positioned(
                              top: 20,
                              right: 170,
                              child: Center(
                                child: FloatingActionButton(
                                  backgroundColor: Palette.primaryColor,
                                  onPressed: () {
                                    MediaService.getImages().then((value) =>
                                        setState(() => images = value));
                                  },
                                  child: Icon(
                                    Icons.add,
                                    color: Palette.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                      : Container(
                          height: MediaQuery.of(context).size.height * 0.25,
                          color: Colors.grey.withAlpha(100),
                          child: GridView.builder(
                              itemCount: images.length,
                              scrollDirection: Axis.horizontal,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 1),
                              itemBuilder: (BuildContext context, index) {
                                Asset asset = images[index];

                                return Stack(
                                  fit: StackFit.expand,
                                  children: <Widget>[
                                    Container(
                                      child: AssetThumb(
                                        quality: 100,
                                        height: 120,
                                        width: 150,
                                        asset: asset,
                                      ),
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Center(
                                          child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            images.removeAt(index);
                                          });
                                        },
                                        icon: Icon(
                                          Icons.cancel,
                                          color: Colors.red,
                                        ),
                                      )),
                                    ),
                                  ],
                                );
                              }))),
            ),
            Center(
                child: context.watch<MapProvider>().appBusy
                    ? CircularProgressIndicator.adaptive()
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () async {
                          if (images.isEmpty) {
                            Fluttertoast.showToast(
                                msg: AppConstants.noImageError);
                          } else {
                            context.read<MapProvider>().setBusy(true);

                            MapSerivce.isAreaFrequentFlagged(
                                    _kInitialMapPosition.latitude,
                                    _kInitialMapPosition.longitude,
                                    context.read<MapProvider>().crimeLocations)
                                .then((value) {
                              int resultValue = int.parse(value!.split(" ")[0]);

                              if (resultValue == 0) {
                                context
                                    .read<MapProvider>()
                                    .uploadImages(images)
                                    .then((value) {
                                  if (context
                                      .read<MapProvider>()
                                      .uploadedImages!
                                      .isNotEmpty) {
                                    context
                                        .read<MapProvider>()
                                        .saveLocationToDB(CrimeLocationModel(
                                            latitude:
                                                _kInitialMapPosition.latitude,
                                            longitude:
                                                _kInitialMapPosition.longitude,
                                            location: _locationAddress,
                                            reportNumber: 1,
                                            crimeImages: value!))
                                        .then((value) {
                                      images.clear();
                                      Fluttertoast.showToast(
                                          msg: AppConstants.locationSaved,
                                          toastLength: Toast.LENGTH_LONG);
                                      Navigator.pop(context);
                                    });
                                  }
                                });
                              } else {
                                context
                                    .read<MapProvider>()
                                    .updateLocationToDB(
                                        CrimeLocationUpdateModel(
                                      reportNumber: resultValue,
                                      locationId: value.split(" ")[1],
                                    ))
                                    .then((value) {
                                  images.clear();
                                  Fluttertoast.showToast(
                                      msg: AppConstants
                                          .anotherLocationWithinTheRadiud);
                                  Navigator.pop(context);
                                });
                              }
                            }).catchError((onError) {
                              Fluttertoast.showToast(
                                  msg: AppConstants.locationSaved);
                            });
                          }
                        },
                        child: CustomText(
                          text: AppConstants.saveLocation,
                          color: Palette.white,
                        )))
          ],
        ),
      ),
    );
  }
}
