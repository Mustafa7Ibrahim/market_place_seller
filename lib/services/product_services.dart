import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market_place_seller/models/product_model.dart';

class ProductServices {
  User currentUser = FirebaseAuth.instance.currentUser;

  Future addNewProduct(ProductModel productModel) async {
    await uploadImages(productModel.productImages).then(
      (_productImages) => FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser.uid)
          .collection('products')
          .doc()
          .set(
        {
          'sallerId': currentUser.uid,
          'productName': productModel.productName,
          'productType': productModel.productType,
          'price': productModel.price,
          'quantity': productModel.quantity,
          'description': productModel.description,
          'specification': productModel.specification,
          'productImages': _productImages,
          'CompanyName': currentUser.displayName,
        },
      ),
    );
    return;
  }

  Future<List<String>> uploadImages(List<File> images) async {
    List<String> _imageUrls = List();
    await Future.wait(
      images.map((image) async {
        final url = await uploadImageToFirebaseStorage(image);
        _imageUrls.add(url);
      }),
      eagerError: true,
      cleanUp: (_) => print('eager cleaned up'),
    );
    return _imageUrls;
  }

  Future<String> uploadImageToFirebaseStorage(File image) async {
    StorageReference reference =
        FirebaseStorage.instance.ref().child('${currentUser.uid}/${image.uri}');
    StorageUploadTask uploadTask = reference.putFile(image);
    StorageTaskSnapshot snapshot = await uploadTask.onComplete;
    if (snapshot.error == null) {
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Upload success');
      return downloadUrl;
    } else {
      print('Error from image repo ${snapshot.error.toString()}');
      throw ('This file is not an image');
    }
  }

  updateNewProduct(ProductModel productModel) async {
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
