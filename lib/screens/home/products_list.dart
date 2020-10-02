import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_place_seller/models/product_model.dart';
import 'package:market_place_seller/screens/home/components/product.dart';
import 'package:market_place_seller/services/product_services.dart';

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
          'My Product',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: StreamBuilder<List<ProductModel>>(
        stream: ProductServices().productListStream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return CircularProgressIndicator();
          }
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            itemCount: snapshot.data.length,
            itemBuilder: (context, index) {
              return OpenContainer(
                transitionType: _transitionType,
                onClosed: null,
                closedColor: Theme.of(context).scaffoldBackgroundColor,
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
