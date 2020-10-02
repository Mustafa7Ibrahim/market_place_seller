import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:market_place_seller/models/seller_model.dart';
import 'package:market_place_seller/services/seller_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationServices {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final SellerServices _sellerServices = SellerServices();

  Future signInWithGoogle(BuildContext context) async {
    final GoogleSignInAccount signInAccount = await _googleSignIn.signIn();
    final GoogleSignInAuthentication signInAuthentication = await signInAccount.authentication;
    final AuthCredential credential = GoogleAuthProvider.credential(
      accessToken: signInAuthentication.accessToken,
      idToken: signInAuthentication.idToken,
    );
    final UserCredential _userCredential = await _firebaseAuth.signInWithCredential(credential);
    final User _user = _userCredential.user;

    _sellerServices.addSeller(
      SellerModel(
        sellerId: _user.uid,
        sellerName: _user.displayName,
        sellerEmail: _user.email,
        sellerImg: _user.photoURL,
        sellerAddress: '',
        sellerCompanyName: '',
        sellerGender: '',
        sellerPhoneNamber: '',
      ),
    );
    final User currentUser = _firebaseAuth.currentUser;
    assert(_user.uid == currentUser.uid);
    saveIdToSharedPreferences(currentUser.uid);
    return currentUser;
  }

  Future signOut() async {
    await _googleSignIn.signOut().whenComplete(() => removeIdFromSharedPreferences());
  }

  void removeIdFromSharedPreferences() async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.remove('userId');
  }

  void saveIdToSharedPreferences(String userId) async {
    SharedPreferences _sharedPreferences = await SharedPreferences.getInstance();
    _sharedPreferences.setString('userId', userId);
  }
}
