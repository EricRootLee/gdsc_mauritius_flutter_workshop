import 'dart:developer';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:gdscworkshop/src/helpers/common/app_constants.dart';
import 'package:multi_image_picker/multi_image_picker.dart';

import '../../models/crime_location_model.dart';
import '../../models/entity/crime_location_update.dart';

class FirebaseClient {
  FirebaseClient(this._firestore);

  final FirebaseFirestore _firestore;
  final FirebaseStorage _firebaseStorage = FirebaseStorage.instance;

  Future<void> saveCrimeLocation(CrimeLocationModel data) => _firestore
      .collection(AppConstants.crimesLocationCollections)
      .add(data.toJson());

  Future<void> updateCrimeLocation(CrimeLocationUpdateModel data) => _firestore
      .collection(AppConstants.crimesLocationCollections)
      .doc(data.locationId)
      .update(data.toJson());
  Stream<QuerySnapshot<Map<String, dynamic>>> getCrimeLocations() =>
      _firestore.collection(AppConstants.crimesLocationCollections).snapshots();

  Future<List<String>> uploadFiles(List<Asset> _images) async {
    var imageUrls = await Future.wait(
        _images.map((_image) => uploadFile(_image, _firebaseStorage)));
    print(imageUrls);
    return imageUrls;
  }

  Future<String> uploadFile(
      Asset _image, FirebaseStorage _firebaseStorage) async {
    ByteData byteData = await _image.getByteData();
    Uint8List imageData = byteData.buffer.asUint8List();
    Reference reference = _firebaseStorage.ref().child(
        AppConstants.firebaseStorageBucket + "/${DateTime.now().toString()}");
    UploadTask uploadTask = reference.putData(imageData);
    await uploadTask.then((TaskSnapshot snapshot) {
      log(AppConstants.uploadComplete);
    });
    return await reference.getDownloadURL();
  }
}
