import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Widget/appBar.dart';
import 'package:http/http.dart' as http;
import 'package:sellermultivendor/Widget/parameterString.dart';

import '../../../Provider/settingProvider.dart';
import '../../../Widget/api.dart';
import '../../HomePage/home.dart';


class SelectedSubscription extends StatefulWidget {
  final String index;
  final String title;
  final String? desc1;
  final String? desc2;
  final String? desc3;
  final String? basePrice;
  final String? MainPrice;

  const SelectedSubscription(
      {Key? key,
        required this.index,
        required this.title,
        this.desc1,
        this.desc2,
        this.desc3,
        this.basePrice,
        this.MainPrice})
      : super(key: key);

  @override
  State<SelectedSubscription> createState() => _SelectedSubscriptionState();
}

class _SelectedSubscriptionState extends State<SelectedSubscription> {
  TextEditingController _accountNumber = TextEditingController();
  TextEditingController _accountName = TextEditingController();
  TextEditingController _mmyy = TextEditingController();
  TextEditingController _cvc = TextEditingController();
  bool _isLoading = false;
  Future<void> sendSubscriptionData() async {
    setState(() {
      _isLoading = true;
    });
    final response = await http.post(purchasedSubscription, body: {
      'seller_id': context.read<SettingProvider>().CUR_USERID,
      'seller_name': CUR_USERNAME.toString(),
      'subscription_name':widget.title,
      'subscription_id': widget.index.toString(),
      'transaction_id': '9012',
      'days': '30',
      'start_date': DateTime.now().toString(),
      'expiry_date': DateTime.now().add(Duration(days: 30)).toString(),
    });

    if (response.statusCode == 200) {

      // API call successful
      print('Subscription data sent successfully');
      setState(() {
        _isLoading = false;
      });
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Subscription Successful!'),
            content: Text('You have successfully subscribed.'),
            actions: <Widget>[
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );

    } else {
      // API call failed
      print('Failed to send subscription data');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(

        body: _isLoading ? Center(child: CircularProgressIndicator(),): Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                GradientAppBar1(
                  title: 'Select Your Plan',
                ),
                SizedBox(height: 25,),
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side: BorderSide(
                          color: grad2Color,
                          width: 2.0),
                    ),


                    child: Container(

                      //   height: MediaQuery.of(context).size.height / 4,
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.title,
                                  style: TextStyle(
                                      fontSize: 25, fontWeight: FontWeight.bold),
                                ),
                                Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          widget.MainPrice.toString(),
                                          style: TextStyle(
                                              fontSize: 25,
                                              color: Colors.red, fontWeight: FontWeight.bold),
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
                                      widget.basePrice.toString(),
                                      style: TextStyle(
                                          decoration: TextDecoration.lineThrough,
                                          decorationColor: Colors.red,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
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
                                      widget.desc1.toString(),
                                      style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.bold),
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
                                      widget.desc2.toString(),
                                      style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.bold),
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
                                      widget.desc3.toString(),
                                      style: TextStyle(
                                          fontSize: 12, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _accountNumber,
                        decoration: InputDecoration(
                          labelText: 'Account Number',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account number';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25,),
                      TextFormField(
                        controller: _accountName,
                        decoration: InputDecoration(
                          labelText: 'Account Name',
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.black, width: 2.0),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.blue, width: 2.0),
                          ),
                        ),
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter account name';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 25,),
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _mmyy,
                              decoration: InputDecoration(
                                labelText: 'MM/YY',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                ),
                              ),
                              keyboardType: TextInputType.datetime,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter expiration date';
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(width: 16.0),
                          Expanded(
                            child: TextFormField(
                              controller: _cvc,
                              decoration: InputDecoration(
                                labelText: 'CVC',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.blue, width: 2.0),
                                ),
                              ),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter CVC';
                                }
                                return null;
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 25,),
                GestureDetector(
                  onTap: (){
                    sendSubscriptionData();
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));

                  },
                  child: Container(
                    height: 40,
                    width: MediaQuery.of(context).size.width/2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        gradient: LinearGradient(
                            colors: [
                              grad2Color,grad1Color
                            ]
                        )
                    ),
                    child: Center(child: Text("Make Payment",style: TextStyle(color: Colors.white),)),
                  ),
                ),


              ],
            ),
          ),
        ));
  }

  String generateSubscriptionId() {
    Random random = new Random();
    int randomNumber = random.nextInt(pow(10, 6).toInt()); // generates a random number between 0 and 999,999
    return randomNumber.toString().padLeft(6, '0');
  }
}
