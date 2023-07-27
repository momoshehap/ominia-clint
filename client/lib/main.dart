import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:omnia_client/pojo/utils.dart';
import 'package:omnia_client/screens/offersApp.dart';
import 'widget/navBar.dart';
import 'screens/couponsApp.dart';
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  // await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await subscribe_to_notifications();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MaterialApp(debugShowCheckedModeBanner: false,home: MainApp()));
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
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
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: NavBar(),
          body: screens[currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: Colors.blueAccent,
            onTap: (index) => setState(() => currentIndex = index),
            items: const [
              BottomNavigationBarItem(
                  icon: Icon(Icons.local_offer), label: 'العروض'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.shopping_basket), label: 'الكوبونات'),
            ],
          ),
          appBar: AppBar(title: Text("الحق عروض السعوديه",style: TextStyle(fontWeight: FontWeight.bold),),),
        ),
      ),
    );
  }
}
