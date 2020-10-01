import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_place_seller/wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(App());
}

class App extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.white,
        accentColor: Colors.green,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          centerTitle: true,
        ),
      ),
      home: Scaffold(
        body: FutureBuilder(
          future: _initialization,
          builder: (context, snapshot) {
            if (snapshot.hasError) return Center(child: Text('Something went wrong!'));

            if (snapshot.connectionState == ConnectionState.done) return Wrapper();

            return Center(child: CircularProgressIndicator(backgroundColor: Colors.green));
          },
        ),
      ),
    );
  }
}
