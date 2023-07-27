import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:omnia_client/models/coupon_controller.dart';

import '../models/coupon.dart';
import '../pojo/utils.dart';
import '../widget/coupon_card.dart';

class CouponsApp extends StatefulWidget {
  const CouponsApp({Key? key}) : super(key: key);

  @override
  State<CouponsApp> createState() => _CouponsAppState();
}

class _CouponsAppState extends State<CouponsApp> {
  List<Coupon> _coupons = [];
  List<Coupon> _allcoupons = [];
  final controller = Get.put(CouponController());
  int selected_filter = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xFFf9bc30),
          secondary: const Color(0xFFFFC107),
        )),
        home: Directionality(
              textDirection: TextDirection.rtl,
              child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: SingleChildScrollView(
                  physics: ScrollPhysics(),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25.0)),
                              hintText: "أبحث هنا"),
                          onChanged: (query) {
                            setState(() {
                              search_in_data(query, "title");
                            });
                          },
                        ),
                        Container(
                            margin: EdgeInsets.only(top: 20, bottom: 10),
                            height: 91,
                            child: ListView.builder(
                              shrinkWrap: true,
                              itemBuilder: (context, index) {
                                return Container(
                                  width: 100,
                                  margin: EdgeInsets.only(left: 20),
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all(
                                                  selected_filter == index
                                                      ? Colors.blue
                                                      : Colors.white)),
                                      onPressed: () {
                                        setState(() {
                                          selected_filter = index;
                                          search_in_data(
                                              categories[index], "category");
                                        });
                                      },
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            filters[index].icon,
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text(
                                            filters[index].filter,
                                            style: TextStyle(
                                                fontSize: 13.5,
                                                color: selected_filter == index
                                                    ? Colors.white
                                                    : Colors.black),
                                          ),
                                        ],
                                      )),
                                );
                              },
                              scrollDirection: Axis.horizontal,
                              itemCount: icons.length,
                            )),
                        ListView.builder(
                          key: UniqueKey(),
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ElevatedButton(
                                onPressed: () => setState(() {
                                      showAlertDialog(context,
                                          _coupons[index].description, true);
                                    }),
                                style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(
                                        Colors.white)),
                                child: CouponCard(_coupons[index]));
                          },
                          itemCount: _coupons.length,
                        ),
                      ],
                    ),
                  ),
                ),
              ))
    );
  }

  Future getData() async {
    _coupons.clear();
    _allcoupons.clear();
    await controller.getCouponsFromFirebase().whenComplete(() {
      setState(() {
        _coupons = controller.getCoupons();
        _allcoupons = controller.getCoupons();
        print("coupons: $_coupons");
      });
    });
  }

  search_in_data(String query, String type) {
    _coupons.clear();
    for (var offer in _allcoupons) {
      if (type == "title") {
        if (selected_filter <= 0) {
          if (offer.title.toLowerCase().contains(query.toLowerCase())) {
            _coupons.add(offer);
          }
        } else {
          if (offer.title.toLowerCase().contains(query.toLowerCase()) &&
              offer.category.toLowerCase() ==
                  categories[selected_filter].toLowerCase()) {
            _coupons.add(offer);
          }
        }
      } else if (type == "category") {
        if (selected_filter > 0) {
          if (offer.category.toLowerCase() == query.toLowerCase()) {
            _coupons.add(offer);
          }
        } else {
          _coupons.add(offer);
        }
      }
    }
  }
}
