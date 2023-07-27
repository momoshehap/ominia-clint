import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/Offer.dart';
import '../pojo/constants.dart';

class OfferRepository extends GetxController {
  static OfferRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  List<Offer> _offers = [];


  Future<bool> insertOffer(Offer offer, File? image) async {
    bool inserted = false;
    if (image != null) {
      await _upload_image(image, offer).then((value) async {
        if (value == true) {
          print("successfully uploaded image");
          await _addOffer(offer).then((value) {
            if (value == true) {
              print("successfully inserted offer");
              inserted = true;
            }
          });
        }
      });
    } else {
      offer.pictureUrl = LIMITED_OFFER_IMAGE;
      await _addOffer(offer).then((value) {
        if (value == true) {
          inserted = true;
        }
      });
    }
    return inserted;
  }

  Future<bool> _addOffer(Offer offer) async {
    bool added = false;
    Map<String, dynamic> offer_list = offer.toJson();
    await _db.collection("offers").doc("offers_array").update({
      'offers_array': FieldValue.arrayUnion([offer_list])
    }).whenComplete(() => added = true);
    return added;
  }

  Future<bool> removeOffer(Offer offer) async {
    bool removed = false;
    Map<String, dynamic> offer_list = offer.toJson();
    await _db.collection("offers").doc("offers_array").update({
      'offers_array': FieldValue.arrayRemove([offer_list])
    }).whenComplete(() => removed = true);
    return removed;
  }
  Future<void> getOffersFromFirebase() async {
    _offers.clear();
    CollectionReference offers = _db.collection("offers");
    DocumentSnapshot  snapshot = await offers.doc("offers_array").get();
    var data = snapshot.data() as Map;
    var offersData = data['offers_array'] as List<dynamic>;
    offersData.forEach((offerData) {
      Offer offer = Offer.fromJson(offerData);
      _offers.add(offer);

    });
  }
  Future<bool> _upload_image(File image, Offer offer) async {
    bool uploaded = false;
    final storageRef = FirebaseStorage.instance.ref();
    final offersRef = storageRef.child("offers/" + offer.id + ".jpg");
    UploadTask uploadTask = offersRef.putFile(image);
    await uploadTask.whenComplete(() async {
      try {
        offer.pictureUrl = await offersRef.getDownloadURL();
        uploaded = true;
      } catch (onError) {
        print("Error uploading image ");
      }
    });
    return uploaded;
  }
  List<Offer> getOffers() {
    return _offers;
  }
}
