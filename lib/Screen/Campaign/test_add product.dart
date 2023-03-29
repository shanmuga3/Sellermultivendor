import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Model/ProductModel/Product.dart';
import '../../Provider/ProductListProvider.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/desing.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/simmerEffect.dart';
import '../../Widget/systemChromeSettings.dart';
import '../../Widget/validation.dart';
import '../EditProduct/EditProduct.dart';
import '../HomePage/Widget/commanWidget.dart';
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
  setStateNow() {
    setState(() {});
  }

  @override
  List<Product> selectedProducts = [];

  bool get wantKeepAlive => true;
  bool serachIsEnable = false;
  int currentSelected = 0;

  @override
  void initState() {
    if (widget.flag == "sold") {
      currentSelected = 1;
    }
    if (widget.flag == "low") {
      currentSelected = 2;
    }
    super.initState();
    SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
    SystemChromeSettings.setSystemUIOverlayStyleWithLightBrightNessStyle();
    productListProvider =
        Provider.of<ProductListProvider>(context, listen: false);
    productListProvider!.initializaedVariableWithDefualtValue();

    productListProvider!.controller.addListener(_scrollListener);
    productListProvider!.flag = widget.flag;
    productListProvider!.getProduct("0", context, setStateNow);

    productListProvider!.buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    productListProvider!.buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: productListProvider!.buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
    productListProvider!.controllerForText.addListener(
          () {
        if (productListProvider!.controllerForText.text.isEmpty) {
          productListProvider!.productList.clear();

          if (mounted) {
            setState(
                  () {
                productListProvider!.searchText = "";
              },
            );
          }
        } else {
          if (mounted) {
            setState(
                  () {
                productListProvider!.searchText =
                    productListProvider!.controllerForText.text;
              },
            );
          }
        }

        if (productListProvider!.lastsearch !=
            productListProvider!.searchText &&
            (productListProvider!.searchText == '' ||
                productListProvider!.searchText.isNotEmpty)) {
          productListProvider!.lastsearch = productListProvider!.searchText;
          productListProvider!.isLoading = true;
          productListProvider!.offset = 0;
          productListProvider!.productList.clear();
          productListProvider!.getProduct(
            "0",
            context,
            setStateNow,
          );
        }
      },
    );
  }

  @override
  void dispose() {
    productListProvider!.buttonController!.dispose();
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
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: lightWhite,
      key: productListProvider!.scaffoldKey,
      appBar: AppBar(
        title: Text("Add Products"),
      ),
      body: isNetworkAvail
          ? Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8),
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12)),
                  gradient:
                  LinearGradient(colors: [grad1Color, grad2Color])),
              height: 30,
              width: width / 2,
              child: Center(
                  child: Text(
                    "Selected Products",
                    style: TextStyle(color: Colors.white),
                  )),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Flexible(
            child: ListView.builder(
              itemCount: selectedProducts.length,
              itemBuilder: (context, index) {
                Product product = selectedProducts[index];
                return Padding(
                  padding:
                  const EdgeInsets.only(left: 8, right: 8, bottom: 3),
                  child: Card(
                    child: ListTile(
                        title: Text(product.name.toString()),
                        leading: Hero(
                          tag:
                          "$index${product.id}+ $index${product.name}",
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                circularBorderRadius5),
                            child:
                            DesignConfiguration.getCacheNotworkImage(
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
          // Padding(
          //   padding: const EdgeInsets.only(left: 8.0,right: 8.0,top: 8,bottom: 8),
          //   child: Container(
          //     decoration: BoxDecoration(
          //         borderRadius: BorderRadius.only(topLeft: Radius.circular(12),topRight: Radius.circular(12)),
          //         gradient: LinearGradient(colors: [grad1Color,grad2Color]
          //         )
          //     ),
          //     height: 30,
          //     width: width/2,
          //     child: Center(child: Text("Add Products (Upto 3)",style: TextStyle(color: Colors.white),)),
          //   ),
          // ),
          GestureDetector(
            onTap: () {
              _showModalBottomSheet(context);
            },
            child: Container(
                height: 30,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                    gradient:
                    LinearGradient(colors: [grad2Color, grad1Color])),
                child: Text("Add Products")),
          )

          // Container(
          //   height: height/2,
          //   child: MediaQuery.removePadding(
          //     context: context,
          //     removeTop: true,
          //     child: SingleChildScrollView(
          //       physics: NeverScrollableScrollPhysics(),
          //       child: ListView.builder(
          //         shrinkWrap: true,
          //         controller: productListProvider!.controller,
          //         itemCount: (productListProvider!.offset <
          //             productListProvider!.total)
          //             ? productListProvider!.productList.length + 1
          //             : productListProvider!.productList.length,
          //         physics: const AlwaysScrollableScrollPhysics(),
          //         itemBuilder: (context, index) {
          //           return (index ==
          //               productListProvider!.productList.length &&
          //               isLoadingmore)
          //               ? const Center(
          //             child: CircularProgressIndicator(),
          //           )
          //               : listItem(index);
          //         },
          //       ),
          //     ),
          //   ),
          // ),
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
    double? price;
    if (index < productListProvider!.productList.length) {
      Product? model = productListProvider!.productList[index];
      bool isChecked = false;
      productListProvider!.totalProduct = model.total;
      productListProvider!.items = List<String>.generate(
          model.totalAllow != "" ? int.parse(model.totalAllow!) : 10,
              (i) => (i + 1).toString());

      return Padding(
        padding: const EdgeInsets.only(
          right: 15.0,
          left: 15.0,
          bottom: 13,
        ),
        //       if (!selectedProducts.contains(model)) {
        // selectedProducts.add(model);
        // setState(() {});
        // print("selected products: $selectedProducts");
        // }
        child: Column(
          children: [
            ListTile(
              leading:Hero(
                tag: "$index${model.id}+ $index${model.name}",
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(
                      circularBorderRadius5),
                  child:
                  DesignConfiguration.getCacheNotworkImage(
                    boxFit: BoxFit.cover,
                    context: context,
                    heightvalue: 70.0,
                    placeHolderSize: 70.0,
                    imageurlString: model.image!,
                    widthvalue: 70.0,
                  ),
                ),
              ) ,
              title: Text(
                model.name!,
                style: const TextStyle(
                  color: black,
                  fontWeight: FontWeight.w400,
                  fontFamily: "PlusJakartaSans",
                  fontStyle: FontStyle.normal,
                  fontSize: textFontSize14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.left,
              ),
              subtitle:  Row(
                children: <Widget>[
                  Text(
                      "${getTranslated(context, 'PRICE_LBL')} : ",
                      style: const TextStyle(
                        color: lightBlack2,
                        fontWeight: FontWeight.w400,
                        fontFamily:
                        "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize14,
                      ),
                      textAlign: TextAlign.left),
                  model.prVarientList!.isNotEmpty
                      ? Text(
                    double.parse(model
                        .prVarientList![
                    model
                        .selVarient!]
                        .disPrice!) !=
                        0
                        ? DesignConfiguration
                        .getPriceFormat(
                      context,
                      double.parse(model
                          .prVarientList![
                      model
                          .selVarient!]
                          .disPrice!),
                    )!
                        : "",
                    style: const TextStyle(
                        color: black,
                        fontWeight:
                        FontWeight.w400,
                        fontFamily:
                        "PlusJakartaSans",
                        fontStyle:
                        FontStyle.normal,
                        fontSize:
                        textFontSize14),
                  )
                      : Container(),
                ],
              ),

            )
//             Stack(
//               children: [
//                 Container(
//                   decoration: const BoxDecoration(
//                     boxShadow: [
//                       BoxShadow(
//                           color: blarColor,
//                           offset: Offset(0, 0),
//                           blurRadius: 4,
//                           spreadRadius: 0),
//                     ],
//                     color: white,
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(circularBorderRadius10),
//                     ),
//                   ),
//                   child: InkWell(
//                     borderRadius: BorderRadius.circular(circularBorderRadius5),
//                     child: Column(
//                       children: [
//                         Padding(
//                           padding: const EdgeInsetsDirectional.only(
//                             top: 12.0,
//                             start: 12.0,
//                             end: 12.0,
//                           ),
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Padding(
//                                 padding: const EdgeInsetsDirectional.only(
//                                   end: 12.0,
//                                 ),
//                                 child: Hero(
//                                   tag: "$index${model.id}+ $index${model.name}",
//                                   child: ClipRRect(
//                                     borderRadius: BorderRadius.circular(
//                                         circularBorderRadius5),
//                                     child:
//                                         DesignConfiguration.getCacheNotworkImage(
//                                       boxFit: BoxFit.cover,
//                                       context: context,
//                                       heightvalue: 70.0,
//                                       placeHolderSize: 70.0,
//                                       imageurlString: model.image!,
//                                       widthvalue: 70.0,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                               Expanded(
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: <Widget>[
//                                     Padding(
//                                       padding: const EdgeInsets.only(top: 5.0),
//                                       child: Text(
//                                         model.name!,
//                                         style: const TextStyle(
//                                           color: black,
//                                           fontWeight: FontWeight.w400,
//                                           fontFamily: "PlusJakartaSans",
//                                           fontStyle: FontStyle.normal,
//                                           fontSize: textFontSize14,
//                                         ),
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                         textAlign: TextAlign.left,
//                                       ),
//                                     ),
//                                     model.prVarientList!.isNotEmpty
//                                         ? Padding(
//                                             padding: const EdgeInsets.symmetric(
//                                                 vertical: 4.0),
//                                             child: Row(
//                                               children: <Widget>[
//                                                 Text(
//                                                     "${getTranslated(context, 'PRICE_LBL')} : ",
//                                                     style: const TextStyle(
//                                                       color: lightBlack2,
//                                                       fontWeight: FontWeight.w400,
//                                                       fontFamily:
//                                                           "PlusJakartaSans",
//                                                       fontStyle: FontStyle.normal,
//                                                       fontSize: textFontSize14,
//                                                     ),
//                                                     textAlign: TextAlign.left),
//                                                 model.prVarientList!.isNotEmpty
//                                                     ? Text(
//                                                         double.parse(model
//                                                                     .prVarientList![
//                                                                         model
//                                                                             .selVarient!]
//                                                                     .disPrice!) !=
//                                                                 0
//                                                             ? DesignConfiguration
//                                                                 .getPriceFormat(
//                                                                 context,
//                                                                 double.parse(model
//                                                                     .prVarientList![
//                                                                         model
//                                                                             .selVarient!]
//                                                                     .disPrice!),
//                                                               )!
//                                                             : "",
//                                                         style: const TextStyle(
//                                                             color: black,
//                                                             fontWeight:
//                                                                 FontWeight.w400,
//                                                             fontFamily:
//                                                                 "PlusJakartaSans",
//                                                             fontStyle:
//                                                                 FontStyle.normal,
//                                                             fontSize:
//                                                                 textFontSize14),
//                                                       )
//                                                     : Container(),
//                                               ],
//                                             ),
//                                           )
//                                         : Container(),
//                                   ],
//                                 ),
//                               )
//                             ],
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 Positioned.directional(
//                   textDirection: Directionality.of(context),
//                   end: 15,
//                   top: 12,
// child: Checkbox(
//   value: isChecked,
//   onChanged: (value) {
//     setState(() {
//       isChecked = value!;
//     });
//   },
// ),
//                   // child: Checkbox(
//                   //   checkColor: Colors.pinkAccent,
//                   //   value: isChecked,
//                   //   onChanged: (bool? value) {
//                   //     setState(() {
//                   //       isChecked = value!;
//                   //       if (isChecked) {
//                   //         if (!selectedProducts.contains(model)) {
//                   //           selectedProducts.add(model);
//                   //
//                   //         }
//                   //       } else {
//                   //         setState(() {});
//                   //         selectedProducts.remove(model);
//                   //       }
//                   //     });
//                   //   },
//                   // ),
//                   // child: InkWell(
//                   //   onTap: () {
//                   //     // productDeletDialog(
//                   //     //   model.name!,
//                   //     //   model.id!,
//                   //     //   context,
//                   //     // );
//                   //   },
//                   //   child: SvgPicture.asset(
//                   //     DesignConfiguration.setSvgPath('delete'),
//                   //     width: 20,
//                   //     height: 20,
//                   //   ),
//                   // ),
//                 ),
//               ],
//             ),
          ],
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

  Future<void> _refresh() {
    if (mounted) {
      setState(
            () {
          productListProvider!.isLoading = true;
          isLoadingmore = true;
          productListProvider!.offset = 0;
          productListProvider!.total = 0;
          productListProvider!.productList.clear();
        },
      );
    }
    return productListProvider!.getProduct("0", context, setStateNow);
  }

  // _showForm() {
  //   return productListProvider!.isLoading
  //       ? const ShimmerEffect()
  //       : productListProvider!.productList.isEmpty
  //       ? DesignConfiguration.getNoItem(context)
  //       : RefreshIndicator(
  //     key: productListProvider!.refreshIndicatorKey,
  //     onRefresh: _refresh,
  //     child: Container(
  //       height: height/2,
  //       child: MediaQuery.removePadding(
  //         context: context,
  //         removeTop: true,
  //         child: SingleChildScrollView(
  //           physics: NeverScrollableScrollPhysics(),
  //           child: ListView.builder(
  //             shrinkWrap: true,
  //             controller: productListProvider!.controller,
  //             itemCount: (productListProvider!.offset <
  //                 productListProvider!.total)
  //                 ? productListProvider!.productList.length + 1
  //                 : productListProvider!.productList.length,
  //             physics: const AlwaysScrollableScrollPhysics(),
  //             itemBuilder: (context, index) {
  //               return (index ==
  //                   productListProvider!.productList.length &&
  //                   isLoadingmore)
  //                   ? const Center(
  //                 child: CircularProgressIndicator(),
  //               )
  //                   : listItem(index);
  //             },
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }

  _showModalBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return ListView.builder(
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
        );
      },
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:sellermultivendor/Provider/ProductListProvider.dart';
// import 'package:sellermultivendor/Screen/Campaign/provider/providers.dart';
//
// class Product_List extends StatefulWidget {
//   const Product_List({Key? key}) : super(key: key);
//
//   @override
//   State<Product_List> createState() => _Product_ListState();
// }
//
// class _Product_ListState extends State<Product_List> {
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     Provider.of<ProductListProviderNew>(context,listen: false).productListOfSeller(context);
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Product List'),
//       ),
//       body: Consumer<ProductListProviderNew>(
//         builder: (context, provider, child) {
//           if (provider.productList.isEmpty) {
//             return Center(
//               child: CircularProgressIndicator(),
//             );
//           } else {
//             return ListView.builder(
//               itemCount: provider.productList.length,
//               itemBuilder: (context, index) {
//                 var product = provider.productList[index];
//                 return ListTile(
//                   title: Text(provider.productList[index]["name"]),
//                 //  subtitle: Text('\$${provider.specialPrice[index]['special_price']}'),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
// }
//