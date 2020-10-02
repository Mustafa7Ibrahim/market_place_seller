import 'package:flutter/material.dart';
import 'package:market_place_seller/models/product_model.dart';

class Product extends StatelessWidget {
  final ProductModel productModel;

  const Product(this.productModel);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.0),
      margin: EdgeInsets.all(6.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: Theme.of(context).appBarTheme.color,
        // boxShadow: [shadow],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Image.network(productModel.productImages.first),
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  productModel.productName,
                  style: Theme.of(context).textTheme.subtitle1,
                ),
                Text(
                  productModel.productType,
                  style: Theme.of(context).textTheme.overline,
                ),
                Text(
                  productModel.quantity,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Center(child: Text(productModel.price)),
          ),
        ],
      ),
    );
  }
}
