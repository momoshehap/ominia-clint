import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:omnia_client/repository/coupon_repository.dart';

import 'coupon.dart';

class CouponController extends GetxController {
  static CouponController get instance => Get.find();
  List<Coupon> _coupons = [];

  final description = TextEditingController();
  final title = TextEditingController();

  final couponRepo = Get.put(CouponRepository());

  Future<bool> addCoupon(Coupon coupon, File? file) async {
    bool added = false;
    await couponRepo.insertCoupon(coupon, file).then(
      (value) {
        if (value == true) {
          print("added successfully");
          added = true;
        } else {
          print("an error occurred");
        }
      },
    );
    return added;
  }

  Future<bool> removeCoupon(Coupon coupon) async {
    bool deleted = false;
    await couponRepo.removeCoupon(coupon).then(
      (value) {
        if (value == true) {
          print("deleted offer successfully");
          deleted = true;
        } else {
          print("an error occurred");
        }
      },
    );
    return deleted;
  }

  getCouponsFromFirebase() async {
    await couponRepo.getCouponsFromFirebase().whenComplete(() {
      _coupons = couponRepo.getCoupons();
    });
  }

  getCoupons() {
    List<Coupon> copy = [..._coupons];
    return copy;
  }
}
