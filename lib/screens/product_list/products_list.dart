import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_place_seller/models/product_model.dart';
import 'package:market_place_seller/screens/account/account.dart';
import 'package:market_place_seller/screens/add_new_product/add_new_product.dart';
import 'package:market_place_seller/services/product_services.dart';

import 'components/product.dart';

class ProductsList extends StatefulWidget {
  @override
  _ProductsListState createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Products',
          style: Theme.of(context).textTheme.headline6,
        ),
        leading: IconButton(
          icon: Icon(
            Icons.account_circle,
            color: Theme.of(context).accentColor,
          ),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => Account()),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.add_circle_outline,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNewProduct()),
            ),
          ),
        ],
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: ProductServices().productListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return OpenContainer(
                transitionType: _transitionType,
                onClosed: null,
                closedElevation: 0.0,
                closedBuilder: (context, action) => Product(snapshot.data[index]),
                openBuilder: (context, action) => Container(),
              );
            },
          );
        },
      ),
    );
  }
}
