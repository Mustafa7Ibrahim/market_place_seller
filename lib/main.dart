import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_place_seller/screens/authentication/authentication.dart';
import 'package:market_place_seller/screens/product_list/products_list.dart';
import 'package:market_place_seller/wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
  final String sellerId = _sharedPreferences.getString('userId');
  runApp(App(sellerId: sellerId));
}

class App extends StatelessWidget {
  final String sellerId;
  App({this.sellerId});

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.green,
        accentColor: Colors.green,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
            brightness: Brightness.light,
            color: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            centerTitle: true,
            elevation: 0.0),
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text('Something went wrong!'));
            }

            if (snapshot.connectionState == ConnectionState.done) {
              return sellerId != null ? ProductsList() : Authentication();
            }

            return Center(child: CircularProgressIndicator(backgroundColor: Colors.green));
          },
        ),
      ),
    );
  }
}
