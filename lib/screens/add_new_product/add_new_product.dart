import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market_place_seller/constant/decoration.dart';
import 'package:market_place_seller/models/product_model.dart';
import 'package:market_place_seller/services/product_services.dart';

class AddNewProduct extends StatefulWidget {
  final ProductModel product;

  AddNewProduct({this.product});

  @override
  _AddNewProductState createState() => _AddNewProductState();
}

class _AddNewProductState extends State<AddNewProduct> {
  final User currentUser = FirebaseAuth.instance.currentUser;
  final formKey = GlobalKey<FormState>();
  final ProductServices productServices = ProductServices();

  List<PickedFile> _listPickedFile = List<PickedFile>();
  final ImagePicker _imagePicker = ImagePicker();

  List<String> types = <String>[
    'Supermarket',
    'Fashion',
    'Mobile & Tablets',
    'Electronics',
    'Health & Beauty',
    'Home & Kitchen',
    'Babies',
    'Toys',
    'Appliances',
    'Sports',
    'Automotive',
    'Tools',
  ];

  String type;
  bool loading;

  String name;
  String price;
  String quantity;
  String description;
  String specifications;

  @override
  void initState() {
    loading = false;
    super.initState();
  }

  void selectImage(ImageSource source) async {
    final PickedFile _file = await _imagePicker.getImage(source: source);
    setState(() => _listPickedFile.add(_file));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Product',
          style: Theme.of(context).textTheme.headline6,
        ),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Form(
          key: formKey,
          child: Column(
            children: <Widget>[
              addImages(size, context),

              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Product Name',
                  ),
                  validator: (value) => value.isEmpty ? 'Enter Product Name ..' : null,
                  initialValue: widget?.product?.productName ?? '',
                  onChanged: (value) => name = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.text,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Price',
                  ),
                  validator: (value) => value.isEmpty ? 'Enter Product price ..' : null,
                  initialValue: widget?.product?.price ?? '',
                  onChanged: (value) => price = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Quantity',
                  ),
                  validator: (value) => value.isEmpty ? 'Enter Product Quantity ..' : null,
                  initialValue: widget?.product?.quantity ?? '',
                  onChanged: (value) => quantity = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.number,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                padding: EdgeInsets.symmetric(horizontal: 14.0, vertical: 4.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18.0),
                  boxShadow: [shadow],
                ),
                child: DropdownButton(
                  hint: Text('Type'),
                  isExpanded: true,
                  value: widget?.product?.productType ?? type,
                  underline: SizedBox(),
                  style: TextStyle(color: Colors.black87, fontSize: 18.0),
                  icon: Icon(Icons.arrow_drop_down_circle, color: Colors.green),
                  onChanged: (String onChange) => setState(() => type = onChange),
                  items: types.map(
                    (String value) {
                      return DropdownMenuItem<String>(
                        child: Text(value),
                        value: value,
                      );
                    },
                  ).toList(),
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Description',
                  ),
                  validator: (value) => value.isEmpty ? 'Enter Product Description ..' : null,
                  initialValue: widget?.product?.description ?? '',
                  onChanged: (value) => description = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.text,
                  minLines: 3,
                  maxLines: 5,
                ),
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                decoration: textFaildDecoration,
                child: TextFormField(
                  decoration: inputDecoration.copyWith(
                    hintText: 'Specifications',
                  ),
                  validator: (value) => value.isEmpty ? 'Enter Product Specifications ..' : null,
                  initialValue: widget?.product?.specification ?? '',
                  onChanged: (value) => specifications = value,
                  cursorColor: Theme.of(context).primaryColor,
                  keyboardType: TextInputType.text,
                  minLines: 3,
                  maxLines: 5,
                ),
              ),
              RaisedButton(
                child: Text('Add'),
                color: Theme.of(context).accentColor,
                onPressed: () => addProduct(),
              ),
              // widget.product == null ? addProduct(width, context) : updateProduct(width, context),
            ],
          ),
        ),
      ),
    );
  }

  Container addImages(Size size, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Wrap(
          children: _listPickedFile
              .map<Widget>((image) => Container(
                  margin: EdgeInsets.symmetric(horizontal: 2.0, vertical: 6.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: Image.file(
                      File(image.path),
                      width: size.width * 0.3,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  )))
              .followedBy([
        _listPickedFile.length < 6
            ? SizedBox(
                height: 200,
                width: size.width * 0.3,
                child: OutlineButton(
                  onPressed: () => selectImage(ImageSource.gallery),
                  borderSide: BorderSide(color: Theme.of(context).accentColor, width: 1),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18.0)),
                  child: Icon(Icons.add_a_photo, color: Theme.of(context).accentColor),
                ),
              )
            : Container(),
      ]).toList()),
    );
  }

  // updateProduct(double width, BuildContext context) async {
  //   return WidthButton(
  //     title: 'Update',
  //     loading: loading,
  //     width: width,
  //     onTap: () async {
  //       if (images.isEmpty) {
  //         // show the loading screen
  //         setState(() => loading = true);
  //         // start with uploading the images
  //         await uploadImages().then((onComplete) async {
  //           // whene complete add the product data
  //           await productServices.updateNewProduct(
  //             proId: widget.product.productId,
  //             productName: name ?? widget.product.productName,
  //             price: price ?? widget.product.price,
  //             productType: type ?? widget.product.productType,
  //             description: description ?? widget.product.description,
  //             quantity: quantity ?? widget.product.quantity,
  //             specification: specifications ?? widget.product.specification,
  //             productImages: widget.product.productImages,
  //           );

  //           // if an error happened
  //         }).catchError((onError) {
  //           setState(() => loading = false);
  //           showToast(context, 'Something went wrong: $onError');

  //           // when it finshed clear everything and navigate to home
  //         }).whenComplete(() {
  //           setState(() {
  //             loading = false;
  //             name = '';
  //             price = '';
  //             description = '';
  //             quantity = '';
  //             specifications = '';
  //             images.clear();
  //             type = null;
  //           });
  //           showToast(context, 'Product updated Successfuly');

  //           Navigator.pushReplacement(
  //             context,
  //             CupertinoPageRoute(
  //               builder: (context) => Saller(),
  //             ),
  //           );
  //         });
  //       }
  //     },
  //   );
  // }

  void addProduct() async {
    List<File> _fileList = [];
    _listPickedFile.forEach((element) {
      _fileList.add(File(element.path));
    });
    if (formKey.currentState.validate()) {
      _listPickedFile.forEach((element) {});
      ProductModel productData = ProductModel(
        sallerId: currentUser.uid,
        companyName: currentUser.displayName,
        quantity: quantity,
        description: description,
        price: price,
        productImages: _fileList,
        productName: name,
        productType: type,
        specification: specifications,
      );
      if (_listPickedFile.isNotEmpty) {
        setState(() => loading = true);
        await productServices.addNewProduct(productData).whenComplete(() {
          Navigator.pop(context);
          // setState(() {
          //   loading = false;
          //   name = '';
          //   price = '';
          //   description = '';
          //   quantity = '';
          //   specifications = '';
          //   _listPickedFile.clear();
          //   type = null;
          // });
          // showToast(context, ('Product add Successfully'));
        }).catchError((onError) {
          setState(() => loading = false);
          // showToast(context, ('Somthing went wrong: $onError'));
        });
      }
    }
  }
}
