import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:omnia_client/screens/offersApp.dart';

import '../widget/navBar.dart';
import 'couponsApp.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MaterialApp(home: FirstPageApp()));
}

class FirstPageApp extends StatefulWidget {
  @override
  _FirstPageAppState createState() => _FirstPageAppState();
}

class _FirstPageAppState extends State<FirstPageApp> {
  int currentIndex = 0;
  final screens = [OffersApp(), CouponsApp()];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            primary: const Color(0xFFf9bc30),
            secondary: const Color(0xFFFFC107),
          )),
      home: Scaffold(
        drawer: NavBar(),
        body: screens[currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: currentIndex,
          type: BottomNavigationBarType.fixed,
          onTap: (index) => setState(() => currentIndex = index),
          items: const [
            BottomNavigationBarItem(
                icon: Icon(Icons.local_offer), label: 'offers'),
            BottomNavigationBarItem(
                icon: Icon(Icons.data_saver_on_rounded), label: 'coupons'),
          ],
        ),
        appBar: AppBar(title: Text("عروض السعوديه"),),
      ),
    );
  }
}
