import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:market_place_seller/models/seller_model.dart';

class SellerServices {
  final CollectionReference userCollection = FirebaseFirestore.instance.collection('users');

  Future addSeller(SellerModel sellerModel) async {
    final path = userCollection.doc(sellerModel.sellerId);
    final user = await path.get();

    if (!user.exists) {
      return await path.set(
        {
          'userId': sellerModel.sellerId,
          'userName': sellerModel.sellerName,
          'userEmail': sellerModel.sellerEmail,
          'userImg': sellerModel.sellerImg,
          'userAddress': sellerModel.sellerAddress,
          'userGender': sellerModel.sellerGender,
          'PhoneNumber': sellerModel.sellerPhoneNamber,
          'sallerCompanyName': sellerModel.sellerCompanyName,
        },
      );
    }
  }

  SellerModel sellerData(DocumentSnapshot doc) {
    return SellerModel(
      sellerId: doc.id,
      sellerName: doc.data()['userName'],
      sellerEmail: doc.data()['userEmail'],
      sellerImg: doc.data()['userImg'],
      sellerAddress: doc.data()['userAddress'],
      sellerGender: doc.data()['userGender'],
      sellerPhoneNamber: doc.data()['PhoneNumber'],
      sellerCompanyName: doc.data()['sallerCompanyName'],
    );
  }
}
