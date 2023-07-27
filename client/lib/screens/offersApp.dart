import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/Offer.dart';
import '../models/offer_controller.dart';
import '../pojo/utils.dart';
import '../pojo/constants.dart';
import '../widget/offer_card.dart';

class OffersApp extends StatefulWidget {
  const OffersApp({Key? key}) : super(key: key);

  @override
  State<OffersApp> createState() => _OffersAppState();
}

class _OffersAppState extends State<OffersApp> {
  List<Offer> _offers = [];

  List<Offer> _alloffers = [];

  int selected_filter = 0;

  final controller = Get.put(OfferController());

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
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)), hintText: "أبحث هنا"),
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
                                    backgroundColor: MaterialStateProperty.all(
                                        selected_filter == index
                                            ? Colors.blue
                                            : Colors.white)),
                                onPressed: () {
                                  setState(() {
                                    selected_filter = index;
                                    search_in_data(categories[index], "category");
                                  });
                                },
                                child: Column(
                                  children: [
                                    SizedBox(height: 15,),
                                    Text(
                                      filters[index].icon,
                                      style: TextStyle(fontSize: 25),
                                    ),
                                    SizedBox(height: 15,),
                                    Text(
                                      filters[index].filter,
                                      style: TextStyle(fontSize: 13.5,color:selected_filter == index
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
                                showAlertDialog(
                                    context, _offers[index].description,false);
                              }),
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.white)),
                          child: OfferCard(_offers[index]));
                    },
                    itemCount: _offers.length,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future getData() async {
    _offers.clear();
    _alloffers.clear();
    await controller.getOffersFromFirebase().whenComplete(() {
      setState(() {
        _offers = controller.getOffers();
        _alloffers = controller.getOffers();
        print("offers: $_alloffers");
      });
    });
  }

  search_in_data(String query, String type) {
    _offers.clear();
    for (var offer in _alloffers) {
      if (type == "title") {
        if (selected_filter <= 0) {
          if (offer.title.toLowerCase().contains(query.toLowerCase())) {
            _offers.add(offer);
          }
        } else {
          if (offer.title.toLowerCase().contains(query.toLowerCase()) &&
              offer.category.toLowerCase() ==
                  categories[selected_filter].toLowerCase()) {
            _offers.add(offer);
          }
        }
      } else if (type == "category") {
        if (selected_filter > 0) {
          if (offer.category.toLowerCase() == query.toLowerCase()) {
            _offers.add(offer);
          }
        } else {
          _offers.add(offer);
        }
      }
    }
  }
}
