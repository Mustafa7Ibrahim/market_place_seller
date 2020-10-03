import 'package:flutter/material.dart';
import 'package:market_place_seller/constant/decoration.dart';
import 'package:market_place_seller/models/product_model.dart';

class Product extends StatelessWidget {
  final ProductModel productModel;

  const Product(this.productModel);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        // borderRadius: BorderRadius.circular(18.0),
        boxShadow: [shadow],
      ),
      child: Row(
        children: [
          Flexible(
            flex: 2,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18),
              child: Image.network(
                productModel.productImages.first,
                fit: BoxFit.cover,
                height: 75,
                width: 75,
              ),
            ),
          ),
          SizedBox(width: 14.0),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
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
            child: Center(
              child: Text('\$${productModel.price}'),
            ),
          ),
        ],
      ),
    );
  }
}
