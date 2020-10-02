import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:market_place_seller/models/product_model.dart';

class ProductServices {
  User currentUser = FirebaseAuth.instance.currentUser;

  addNewProduct({ProductModel productModel}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('products')
        .doc()
        .set({
      'sallerId': currentUser.uid,
      'productName': productModel.productName,
      'productType': productModel.productType,
      'price': productModel.price,
      'quantity': productModel.quantity,
      'description': productModel.description,
      'specification': productModel.specification,
      'productImages': productModel.productImages,
      'CompanyName': currentUser.displayName,
    });
  }

  updateNewProduct({ProductModel productModel}) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('products')
        .doc()
        .update({
      'sallerId': currentUser.uid,
      'productName': productModel.productName,
      'productType': productModel.productType,
      'price': productModel.price,
      'quantity': productModel.quantity,
      'description': productModel.description,
      'specification': productModel.specification,
      'productImages': productModel.productImages,
      'CompanyName': currentUser.displayName,
    });
  }

  List<ProductModel> productList(QuerySnapshot snapshot) {
    return snapshot.docs.map((pro) {
      return ProductModel(
        productId: pro.id,
        sallerId: pro.data()['sallerId'],
        productName: pro.data()['productName'],
        productType: pro.data()['productType'],
        price: pro.data()['price'],
        quantity: pro.data()['quantity'],
        description: pro.data()['description'],
        specification: pro.data()['specification'],
        productImages: pro.data()['productImages'],
        companyName: pro.data()['CompanyName'],
      );
    }).toList();
  }

  Stream<List<ProductModel>> get productListStream {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(currentUser.uid)
        .collection('products')
        .snapshots()
        .map(productList);
  }
}
