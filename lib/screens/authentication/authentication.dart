import 'package:flutter/material.dart';
import 'package:market_place_seller/services/authentication_services.dart';
import 'package:market_place_seller/wrapper.dart';

class Authentication extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authentication> {
  AuthenticationServices _authenticationServices = AuthenticationServices();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset('assets/icon.png', height: size.height * 0.3),
          SizedBox(height: 50.0),
          signInButton(context),
        ],
      ),
    );
  }

  signInButton(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 24.0),
      child: OutlineButton(
        splashColor: Colors.grey,
        onPressed: () => _authenticationServices.signInWithGoogle(context).whenComplete(
              () => Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Wrapper(),
                ),
              ),
            ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey[400]),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Sign in with Google',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              )
            ],
          ),
        ),
      ),
    );
  }
}
