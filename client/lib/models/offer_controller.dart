import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:omnia_client/repository/offer_repository.dart';

import 'Offer.dart';

class OfferController extends GetxController{
  static OfferController get instance =>  Get.find();
  List<Offer> _offers = [];

  final description = TextEditingController();
  final title = TextEditingController();

  final offerRepo = Get.put(OfferRepository());

  Future<bool> addOffer(Offer offer,File? file) async{
    bool added = false;
    await offerRepo.insertOffer(offer,file).then((value) {
      if(value == true){
        print("added successfully");
        added = true;
      }
      else{
        print("an error occurred");

      }
    }, );
    return added;
  }
  Future<bool> removeOffer(Offer offer) async{
    bool deleted = false;
    await offerRepo.removeOffer(offer).then((value) {
      if(value == true){
        print("deleted offer successfully");
        deleted = true;
      }
      else{
        print("an error occurred");
      }
    }, );
    return deleted;
  }

  getOffersFromFirebase() async {
    await offerRepo.getOffersFromFirebase().whenComplete(() {
      _offers = offerRepo.getOffers();
    } );
  }
  getOffers(){
    List<Offer> copy = [..._offers];
    return copy;
  }
}