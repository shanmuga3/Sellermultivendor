import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Screen/Campaign/provider/providers.dart';
import 'package:sellermultivendor/Widget/api.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Provider/ProductListProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/systemChromeSettings.dart';
import '../../Widget/validation.dart';
import '../EditProduct/EditProduct.dart';
import '../HomePage/Widget/commanWidget.dart';
import 'package:http/http.dart' as http;
import '../HomePage/home.dart';
import '../ProductList/widget/getCommanButton.dart';

class Product_List extends StatefulWidget {
  final String? flag;
  bool fromNavbar;

  Product_List({Key? key, this.flag, required this.fromNavbar})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => StateProduct();
}

ProductListProvider? productListProvider;

class StateProduct extends State<Product_List>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<Product_List> {
  bool isChecked = false;
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  List<Product> selectedProducts = [];
  List<Product> finalselectedProducts = [];



  setStateNow() {
    setState(() {});
  }

  @override
  bool get wantKeepAlive => true;
  bool serachIsEnable = false;
  int currentSelected = 0;

  @override
  void initState() {
    super.initState();
    productListProvider =
        Provider.of<ProductListProvider>(context, listen: false);
    productListProvider!.initializaedVariableWithDefualtValue();

    productListProvider!.controller.addListener(_scrollListener);
    productListProvider!.flag = widget.flag;
    productListProvider!.getProduct("0", context, setStateNow);
  }

  @override
  void dispose() {
    productListProvider!.controller.removeListener(() {});
    for (int i = 0; i < productListProvider!.controllers.length; i++) {
      productListProvider!.controllers[i].dispose();
    }
    super.dispose();
  }

  Future<void> _playAnimation() async {
    try {
      await productListProvider!.buttonController!.forward();
    } on TickerCanceled {}
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    height = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.white,
      key: productListProvider!.scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.purple,
        title: Text(
          "Add Products",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : isNetworkAvail
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Title',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _titleController,
                            decoration: InputDecoration(
                              hintText: 'Enter title',
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                            ),
                            validator: (value) {
                              if (_titleController.text.isEmpty ?? true) {

                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 16.0),
                          Text(
                            'Description',
                            style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          TextFormField(
                            controller: _descriptionController,
                            maxLines: null,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(4.0))),
                              hintText: 'Enter description',
                            ),
                            validator: (value) {
                              if (_descriptionController.text.isEmpty ?? true) {
                                return 'Please enter a description';
                              }
                              return null;
                            },
                          ),

                        ],
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: selectedProducts.length,
                        itemBuilder: (context, index) {
                          Product product = selectedProducts[index];
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, bottom: 3),
                            child: Card(
                              color: Colors.purple.shade100,
                              child: ListTile(
                                  title: Text(product.name.toString()  ,   style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize14,
                                  ),),
                                  subtitle: Row(
                                    children: <Widget>[
                                      Text(
                                          "${getTranslated(context, 'PRICE_LBL')} : ",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontWeight: FontWeight.bold,
                                            fontFamily: "PlusJakartaSans",
                                            fontStyle: FontStyle.normal,
                                            fontSize: textFontSize14,
                                          ),
                                          textAlign: TextAlign.left),
                                      product.prVarientList!.isNotEmpty
                                          ? Text(
                                              double.parse(product
                                                          .prVarientList![
                                                              product
                                                                  .selVarient!]
                                                          .disPrice!) !=
                                                      0
                                                  ? DesignConfiguration
                                                      .getPriceFormat(
                                                      context,
                                                      double.parse(product
                                                          .prVarientList![
                                                              product
                                                                  .selVarient!]
                                                          .disPrice!),
                                                    )!
                                                  : "",
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: "PlusJakartaSans",
                                                  fontStyle: FontStyle.normal,
                                                  fontSize: textFontSize14),
                                            )
                                          : Container(),
                                    ],
                                  ),
                                  trailing: IconButton(
                                    icon: Icon(Icons.close),
                                    onPressed: () {
                                      setState(() {
                                        selectedProducts.remove(product);
                                      });
                                    },
                                  ),
                                  leading: Hero(
                                    tag:
                                        "$index${product.id}+ $index${product.name}",
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(
                                          circularBorderRadius5),
                                      child: DesignConfiguration
                                          .getCacheNotworkImage(
                                        boxFit: BoxFit.cover,
                                        context: context,
                                        heightvalue: 70.0,
                                        placeHolderSize: 70.0,
                                        imageurlString: product.image!,
                                        widthvalue: 70.0,
                                      ),
                                    ),
                                  )),
                            ),
                          );
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    Padding(
                      padding: const EdgeInsets.only(left: 12,right: 12),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            _showModalBottomSheet(context);
                          },
                          child: Container(
                              height: 40,
                              width: MediaQuery.of(context).size.width / 1,
                              decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                                  gradient: LinearGradient(
                                      colors: [grad2Color, grad1Color])),
                              child: Center(
                                  child: Text(
                                    "Add Products",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold),
                                  ))),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 30),
                      child: Center(
                        child: GestureDetector(
                          onTap: () {
                            if(_titleController.text.isEmpty || _descriptionController.text.isEmpty || selectedProducts.isEmpty){
                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please fill all the fields first"),dismissDirection: DismissDirection.down,));
                            }else{
                              sendCampaignData();
                            }

                            //Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
                          },
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12,right: 12),
                            child: Container(
                                height: 40,
                                width: MediaQuery.of(context).size.width / 1,
                                decoration: BoxDecoration(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    gradient: LinearGradient(
                                        colors: [Colors.purple, Colors.pink])),
                                child: Center(
                                    child: Text(
                                  "Start your campaign",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ))),
                          ),
                        ),
                      ),
                    )
                  ],
                )
              : noInternet(
                  context,
                  setStateNoInternate,
                  productListProvider!.buttonSqueezeanimation,
                  productListProvider!.buttonController,
                ),
    );
  }

  Future<void> sendCampaignData() async {
    print('sendataa here ==> 1');
    setState(() {
      _isLoading = true;
    });
    var parameter = {
      'seller_id': context.read<SettingProvider>().CUR_USERID,
      'seller_name': CUR_USERNAME.toString(),
      'title': _titleController.text.toString(),
      'description': _descriptionController.text.toString(),
      'p_id1': selectedProducts.first.id.toString(),
      //selectedProducts.toString(),
      'p_id2': selectedProducts[1].id.toString(),
      //selectedProducts[2].id.toString() ?? "0",
      'p_id3':selectedProducts[2].id.toString(),
      "start_date" : DateTime.now().toString(),
      //selectedProducts[3].id.toString() ?? "0"
    };
    print('sendataa here ==>2');
    final reposnse = await http.post(addCampaignApi, body: parameter);
    print('responseeeee ${parameter}');
    if (reposnse.statusCode == 200) {
      print('sendataa here ==> 3');
      print('campaign added succesfully');
      setState(() {
        _isLoading = false;
      });
    } else {
      print('sendataa here ==> 4');
      print('campaign not addedd');
    }
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          productListProvider!.offset = 0;
          productListProvider!.total = 0;
          productListProvider!.flag = '';
          productListProvider!.getProduct("0", context, setStateNow);
        } else {
          await productListProvider!.buttonController!.reverse();
          if (mounted) setState(() {});
        }
      },
    );
  }

  Widget listItem(int index) {
    if (index < productListProvider!.productList.length) {
      Product? model = productListProvider!.productList[index];
      productListProvider!.totalProduct = model.total;
      productListProvider!.items = List<String>.generate(
          model.totalAllow != "" ? int.parse(model.totalAllow!) : 10,
          (i) => (i + 1).toString());

      return productListProvider!.isLoading
          ? Container(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.only(right: 15.0, left: 15.0, top: 13),
              child: SingleChildScrollView(
                child: Consumer<ListTileColorProvider>(
                    builder: (context, provider, index1) {
                  bool isSelectedIndex =
                      provider.selectedTileIndexes.contains(index);
                  return Column(
                    children: [
                      Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                        ),
                        margin: EdgeInsets.all(0),

                        child: ListTile(
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(12))),
                          onTap: () {
                            if (isSelectedIndex) {
                              provider.deselectTile(index);
                            } else {
                              // Check if the maximum number of selected products has been reached
                              if (selectedProducts.length >= 3) {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        content: Text("You can select only 3 products"),
                                        actions: [
                                          TextButton(
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                              child: Text("Ok")
                                          )
                                        ],
                                      );
                                    }
                                );
                                return;
                              }
                              provider.selectTile(index);
                            }

                            setState(() {
                              model.isSelected = !model.isSelected; // toggle the isSelected flag
                              // Check if the maximum number of selected products has been reached
                              if (model.isSelected && selectedProducts.length < 3) {
                                selectedProducts.add(model);

                              } else if (!model.isSelected) {
                                selectedProducts.remove(model);
                              }
                             // print("finalllll $finalSelectedProducts");
                            });
                          },

                          selected: model.isSelected,
                          selectedTileColor: !selectedProducts.contains(model)
                              ? null
                              : model.isSelected
                                  ? Colors.green
                                  : null,
                          //model.isSelected ? Colors.green : null,
                          leading: Hero(
                            tag: "$index${model.id}+ $index${model.name}",
                            child: ClipRRect(
                              borderRadius:
                                  BorderRadius.circular(circularBorderRadius5),
                              child: DesignConfiguration.getCacheNotworkImage(
                                boxFit: BoxFit.cover,
                                context: context,
                                heightvalue: 70.0,
                                placeHolderSize: 70.0,
                                imageurlString: model.image!,
                                widthvalue: 70.0,
                              ),
                            ),
                          ),
                          title: Text(
                            model.name!,
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontFamily: "PlusJakartaSans",
                              fontStyle: FontStyle.normal,
                              fontSize: textFontSize14,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                          ),
                          subtitle: Row(
                            children: <Widget>[
                              Text("${getTranslated(context, 'PRICE_LBL')} : ",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "PlusJakartaSans",
                                    fontStyle: FontStyle.normal,
                                    fontSize: textFontSize14,
                                  ),
                                  textAlign: TextAlign.left),
                              model.prVarientList!.isNotEmpty
                                  ? Text(
                                      double.parse(model
                                                  .prVarientList![
                                                      model.selVarient!]
                                                  .disPrice!) !=
                                              0
                                          ? DesignConfiguration.getPriceFormat(
                                              context,
                                              double.parse(model
                                                  .prVarientList![
                                                      model.selVarient!]
                                                  .disPrice!),
                                            )!
                                          : "",
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.w400,
                                          fontFamily: "PlusJakartaSans",
                                          fontStyle: FontStyle.normal,
                                          fontSize: textFontSize14),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
            );
    } else {
      return Container();
    }
  }

  _scrollListener() {
    if (productListProvider!.controller.offset >=
            productListProvider!.controller.position.maxScrollExtent &&
        !productListProvider!.controller.position.outOfRange) {
      if (mounted) {
        if (mounted) {
          setState(
            () {
              isLoadingmore = true;

              if (productListProvider!.offset < productListProvider!.total)
                productListProvider!.getProduct("0", context, setStateNow);
            },
          );
        }
      }
    }
  }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: height / 2,
          child: ListView.builder(
            shrinkWrap: false,
            controller: productListProvider!.controller,
            itemCount:
                (productListProvider!.offset < productListProvider!.total)
                    ? productListProvider!.productList.length + 1
                    : productListProvider!.productList.length,
            physics: const AlwaysScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return (index == productListProvider!.productList.length &&
                      isLoadingmore)
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : listItem(index);
            },
          ),
        );
      },
    );
  }
}
