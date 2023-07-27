import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';

import '../models/coupon.dart';
import '../pojo/constants.dart';

class CouponRepository extends GetxController {
  static CouponRepository get instance => Get.find();
  final _db = FirebaseFirestore.instance;
  List<Coupon> _coupons = [];

  Future<bool> insertCoupon(Coupon coupon, File? image) async {
    bool inserted = false;
    if (image != null) {
      await _upload_image(image, coupon).then((value) async {
        if (value == true) {
          print("successfully uploaded image");
          await _addCoupon(coupon).then((value) {
            if (value == true) {
              print("successfully inserted offer");
              inserted = true;
            }
          });
        }
      });
    } else {
      coupon.pictureUrl = LIMITED_OFFER_IMAGE;
      await _addCoupon(coupon).then((value) {
        if (value == true) {
          inserted = true;
        }
      });
    }
    return inserted;
  }

  Future<bool> _addCoupon(Coupon coupon) async {
    bool added = false;
    Map<String, dynamic> coupon_list = coupon.toJson();
    await _db.collection("offers").doc("coupons_array").update({
      'coupons_array': FieldValue.arrayUnion([coupon_list])
    }).whenComplete(() => added = true);
    return added;
  }

  Future<bool> removeCoupon(Coupon coupon) async {
    bool removed = false;
    Map<String, dynamic> coupon_list = coupon.toJson();
    await _db.collection("offers").doc("coupons_array").update({
      'coupons_array': FieldValue.arrayRemove([coupon_list])
    }).whenComplete(() => removed = true);
    return removed;
  }

  Future<void> getCouponsFromFirebase() async {
    _coupons.clear();
    CollectionReference offers = _db.collection("offers");
    DocumentSnapshot snapshot = await offers.doc("coupons_array").get();
    var data = snapshot.data() as Map;
    var couponsData = data['coupons_array'] as List<dynamic>;
    couponsData.forEach((couponData) {
      Coupon coupon = Coupon.fromJson(couponData);
      _coupons.add(coupon);
    });
  }

  Future<bool> _upload_image(File image, Coupon coupon) async {
    bool uploaded = false;
    final storageRef = FirebaseStorage.instance.ref();
    final offersRef = storageRef.child("offers/" + coupon.id + ".jpg");
    UploadTask uploadTask = offersRef.putFile(image);
    await uploadTask.whenComplete(() async {
      try {
        coupon.pictureUrl = await offersRef.getDownloadURL();
        uploaded = true;
      } catch (onError) {
        print("Error uploading image ");
      }
    });
    return uploaded;
  }

  List<Coupon> getCoupons() {
    return _coupons;
  }
}
