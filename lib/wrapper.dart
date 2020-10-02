import 'package:animations/animations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_place_seller/models/seller_model.dart';
import 'package:market_place_seller/screens/home/products_list.dart';
import 'package:market_place_seller/services/seller_services.dart';
import 'package:provider/provider.dart';

import 'screens/account/account.dart';
import 'screens/add_new_product/add_new_product.dart';

class Wrapper extends StatefulWidget {
  final String id;

  const Wrapper({Key key, this.id}) : super(key: key);
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  int _selectedIndex = 0;

  List<Widget> _widgetOptions = <Widget>[
    ProductsList(),
    AddNewProduct(),
    Account(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider<SellerModel>.value(
          value: FirebaseFirestore.instance
              .collection('users')
              .doc(widget.id)
              .snapshots()
              .map(SellerServices().sellerData),
        ),
      ],
      child: Scaffold(
        body: PageTransitionSwitcher(
          transitionBuilder: (child, primaryAnimation, secondaryAnimation) {
            return FadeThroughTransition(
              animation: primaryAnimation,
              secondaryAnimation: secondaryAnimation,
              child: child,
            );
          },
          child: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
        ),
        bottomNavigationBar: CupertinoTabBar(
          onTap: (index) => setState(() => _selectedIndex = index),
          currentIndex: _selectedIndex,
          activeColor: Theme.of(context).accentColor,
          border: Border.fromBorderSide(BorderSide.none),
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.show_chart),
              title: Text('Products'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Text('Add'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              title: Text('Account'),
            ),
          ],
        ),
      ),
    );
  }
}
