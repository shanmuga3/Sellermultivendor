
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:my_fatoorah/my_fatoorah.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import '../../../Provider/systemProvider.dart';
import '../provider/paymentProvider.dart';

class HalfYearlyData extends StatefulWidget {
  final List subscriptionList;

  const HalfYearlyData({Key? key, required this.subscriptionList})
      : super(key: key);

  @override
  State<HalfYearlyData> createState() => _HalfYearlyDataState();
}

class _HalfYearlyDataState extends State<HalfYearlyData> {
  int? selectedCardIndex;
  String? selectedTitle;
  String? desc1;
  String? desc2;
  String? desc3;
  String? basePrice;
  String? MainPrice;
  bool isSelected = false;

  SystemProviderNew? systemProvider;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<PaymentProviderFatoora>(context, listen: false).getPaymentMethod(context);
  }
  Widget build(BuildContext context) {
    return Column(children: [
      SizedBox(height: 15,),
      Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [grad2Color, Colors.deepOrange],
          ),
          borderRadius: BorderRadius.all(Radius.circular(20)
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            '6 Months Subscription Plans',
            style: TextStyle(
              color: Colors.white,
              fontSize: 15.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      Expanded(
          child: ListView.builder(
              itemCount: widget.subscriptionList.length,
              itemBuilder: (context, index) {
                int value =
                    int.parse(widget.subscriptionList[index]["price"]) * 6 ;
                return Padding(
                    padding: const EdgeInsets.only(
                        left: 12, right: 12, bottom: 5),
                    child: InkWell(
                        onTap: () {
                          setState(() {
                            isSelected = true;
                            selectedCardIndex = index;
                            selectedTitle =
                            widget.subscriptionList[index]['title'];
                            desc1 = widget.subscriptionList[index]
                            ['discription_one'];
                            desc2 = widget.subscriptionList[index]
                            ['discription_two'];
                            desc3 = widget.subscriptionList[index]
                            ['discription_three'];
                            basePrice = value.toString();
                            MainPrice =
                            widget.subscriptionList[index]['half_yearly_price'];
                          });
                          print(
                              'selectedIndex is ===> ${selectedCardIndex} and title is ${selectedTitle}');
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              side: BorderSide(
                                  color: selectedCardIndex == index
                                      ? grad2Color
                                      : Colors.transparent,
                                  width: 4.0),
                            ),
                            child: Container(
                              //     height: MediaQuery.of(context).size.height / 3,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 12.0,right: 12.0,bottom: 12.0),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          widget.subscriptionList[index]
                                          ["title"],
                                          style: TextStyle(
                                              fontSize: 25,

                                              fontWeight: FontWeight.bold),
                                        ),
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  widget.subscriptionList[index]
                                                  ["half_yearly_price"],
                                                  style: TextStyle(
                                                      fontSize: 25,
                                                      color: Colors.red,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                SizedBox(width: 5,),
                                                Text(
                                                  "SAR",
                                                  style: TextStyle(
                                                      fontSize: 15,
                                                      color: Colors.black,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                            Text(
                                              value.toString(),
                                              style: TextStyle(
                                                  decoration: TextDecoration
                                                      .lineThrough,
                                                  decorationColor: Colors.red,
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.black,
                                              size: 15.0,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.subscriptionList[index]
                                              ["discription_one"],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.black,
                                              size: 15.0,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.subscriptionList[index]
                                              ["discription_two"],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle_outline,
                                              color: Colors.black,
                                              size: 15.0,
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                            Text(
                                              widget.subscriptionList[index]
                                              ["discription_three"],
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ))));
              })),
      isSelected == true ? Consumer<PaymentProviderFatoora>(
        builder: (context,myfatoora, snapshot) {
          return GestureDetector(

            onTap: () async {
              var response = await MyFatoorah.startPayment(
                context: context,
                request: MyfatoorahRequest.live(
                  currencyIso: Country.SaudiArabia,
                  successUrl:myfatoora.successUrl ,
                  errorUrl: myfatoora.errorUrl,
                  invoiceAmount: double.parse(MainPrice.toString()),
                  language: ApiLanguage.English,
                  token:myfatoora.token
                  //'rLtt6JWvbUHDDhsZnfpAhpYk4dxYDQkbcPTyGaKp2TYqQgG7FGZ5Th_WD53Oq8Ebz6A53njUoo1w3pjU1D4vs_ZMqFiz_j0urb_BH9Oq9VZoKFoJEDAbRZepGcQanImyYrry7Kt6MnMdgfG5jn4HngWoRdKduNNyP4kzcp3mRv7x00ahkm9LAK7ZRieg7k1PDAnBIOG3EyVSJ5kK4WLMvYr7sCwHbHcu4A5WwelxYK0GMJy37bNAarSJDFQsJ2ZvJjvMDmfWwDVFEVe_5tOomfVNt6bOg9mexbGjMrnHBnKnZR1vQbBtQieDlQepzTZMuQrSuKn-t5XZM7V6fCW7oP-uXGX-sMOajeX65JOf6XVpk29DP6ro8WTAflCDANC193yof8-f5_EYY-3hXhJj7RBXmizDpneEQDSaSz5sFk0sV5qPcARJ9zGG73vuGFyenjPPmtDtXtpx35A-BVcOSBYVIWe9kndG3nclfefjKEuZ3m4jL9Gg1h2JBvmXSMYiZtp9MR5I6pvbvylU_PP5xJFSjVTIz7IQSjcVGO41npnwIxRXNRxFOdIUHn0tjQ-7LwvEcTXyPsHXcMD8WtgBh-wxR8aKX7WPSsT1O8d8reb2aR7K3rkV3K82K_0OgawImEpwSvp9MNKynEAJQS6ZHe_J_l77652xwPNxMRTMASk1ZsJL',//
                ),
              );
              log(response.paymentId.toString());
             // await doMyFatoorah(price: MainPrice.toString());
              },
            child: Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                height: 40,
                width: MediaQuery.of(context).size.width / 2,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  gradient: LinearGradient(colors: [grad2Color, grad1Color]),
                ),
                child: Center(
                    child: Text(
                      "Subscribe now",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    )),
              ),
            ),
          );
        }
      ) :Container()
    ]);
  }

  // Future<Map<String, dynamic>> doMyFatoorah({
  //   required String price,
  // }) async {
  //   try {
  //     String tranId = '';
  //     String orderID =
  //        'KJHKJHKJHKJ';// 'wallet-refill-user-$context.read<SettingProvider>().CUR_USERID-${DateTime.now().millisecondsSinceEpoch}-${Random().nextInt(900) + 100}';
  //     String amount = price;
  //     String successUrl =
  //         '${systemProvider!.myfatoorahSuccessUrl!}?txn_id=$tranId&order_id=$orderID&amount=$price';
  //     String errorUrl =
  //         '${systemProvider!.myfatoorahErrorUrl!}?txn_id=$tranId&order_id=$orderID&amount=$price';
  //     String token = systemProvider!.myfatoorahToken!;
  //     print("hereiM ===> 2");
  //     try {
  //       var response = await MyFatoorah.startPayment(
  //         context: context,
  //         successChild: InkWell(
  //           onTap: () {
  //             Navigator.pop(context);
  //           },
  //           child: Container(
  //             width: 200,
  //             height: 200,
  //             child: const Icon(
  //               Icons.done,
  //               size: 100,
  //               color: Colors.green,
  //             ),
  //           ),
  //         ),
  //         request: systemProvider!.myfatoorahPaymentMode == 'test'
  //             ? MyfatoorahRequest.test(
  //           userDefinedField: orderID,
  //           currencyIso: () {
  //             if (systemProvider!.myfatoorahCosuntry == 'Kuwait') {
  //               return Country.Kuwait;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'UAE') {
  //               return Country.UAE;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'Egypt') {
  //               return Country.Egypt;
  //             } else if (systemProvider!.myfatoorahCosuntry ==
  //                 'Bahrain') {
  //               return Country.Bahrain;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'Jordan') {
  //               return Country.Jordan;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'Oman') {
  //               return Country.Oman;
  //             } else if (systemProvider!.myfatoorahCosuntry ==
  //                 'SaudiArabia') {
  //               return Country.SaudiArabia;
  //             } else if (systemProvider!.myfatoorahCosuntry ==
  //                 'SaudiArabia') {
  //               return Country.Qatar;
  //             }
  //             return Country.SaudiArabia;
  //           }(),
  //           successUrl: successUrl,
  //           errorUrl: errorUrl,
  //           invoiceAmount: double.parse(amount),
  //           language: () {
  //             if (systemProvider!.myfatoorahLanguage == 'english') {
  //               return ApiLanguage.English;
  //             }
  //             return ApiLanguage.Arabic;
  //           }(),
  //           token: token,
  //         )
  //             : MyfatoorahRequest.live(
  //           userDefinedField: orderID,
  //           currencyIso: () {
  //             if (systemProvider!.myfatoorahCosuntry == 'Kuwait') {
  //               return Country.Kuwait;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'UAE') {
  //               return Country.UAE;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'Egypt') {
  //               return Country.Egypt;
  //             } else if (systemProvider!.myfatoorahCosuntry ==
  //                 'Bahrain') {
  //               return Country.Bahrain;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'Jordan') {
  //               return Country.Jordan;
  //             } else if (systemProvider!.myfatoorahCosuntry == 'Oman') {
  //               return Country.Oman;
  //             } else if (systemProvider!.myfatoorahCosuntry ==
  //                 'SaudiArabia') {
  //               return Country.SaudiArabia;
  //             } else if (systemProvider!.myfatoorahCosuntry ==
  //                 'SaudiArabia') {
  //               return Country.Qatar;
  //             }
  //             return Country.SaudiArabia;
  //           }(),
  //           successUrl: successUrl,
  //           errorUrl: errorUrl,
  //           invoiceAmount: double.parse(amount),
  //           language: () {
  //             if (systemProvider!.myfatoorahLanguage == 'english') {
  //               return ApiLanguage.English;
  //             }
  //             return ApiLanguage.Arabic;
  //           }(),
  //           token: token,
  //         ),
  //       );
  //       if (response.status.toString() == 'PaymentStatus.Success') {
  //         return {
  //           'error': false,
  //           'message': 'Transaction Successful',
  //           'status': true
  //         };
  //       }
  //       if (response.status.toString() == 'PaymentStatus.Error') {
  //         return {'error': true, 'message': e.toString(), 'status': false};
  //       }
  //       if (response.status.toString() == 'PaymentStatus.None') {
  //         return {'error': true, 'message': e.toString(), 'status': false};
  //       }
  //     } on TimeoutException catch (_) {
  //       setSnackbar(getTranslated(context, 'somethingMSg')!, context);
  //     }
  //     return {
  //       'error': false,
  //       'message': 'Transaction Successful',
  //       'status': true
  //     };
  //   } catch (e) {
  //     print("hereiM ===> 3");
  //     return {'error': true, 'message': e.toString(), 'status': false};
  //   }
  // }


}
