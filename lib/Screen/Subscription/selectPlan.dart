import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/Screen/Subscription/plans/halfyearly.dart';
import 'package:sellermultivendor/Screen/Subscription/plans/monthly.dart';
import 'package:sellermultivendor/Screen/Subscription/plans/yearly.dart';
import 'package:sellermultivendor/Screen/Subscription/provider/subscriptionProvider.dart';
import 'package:sellermultivendor/Screen/Subscription/provider/tabProvider.dart';
import 'package:sellermultivendor/Widget/api.dart';

import '../../Helper/Color.dart';

import '../../Provider/settingProvider.dart';
import '../../Provider/walletProvider.dart';
import '../../Widget/appBar.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/noNetwork.dart';
import '../../Widget/sharedPreferances.dart';

class SelectYourPlan extends StatefulWidget {
  const SelectYourPlan({Key? key}) : super(key: key);

  @override
  State<SelectYourPlan> createState() => _SelectYourPlanState();
}

class _SelectYourPlanState extends State<SelectYourPlan>
    with TickerProviderStateMixin {
 // List _subscriptionList = [];
  late TabController _tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(
      length: 3,
      vsync: this,
    );
   // Provider.of<SubscriptionProvider>(context, listen: false).checkSubscriptionofSeller(context);
    Provider.of<SubscriptionProvider>(context, listen: false).fetchSubscriptionData();

  }

  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  int offset = 0;
  int total = 0;
  AnimationController? buttonController;
  Animation? buttonSqueezeanimation;
  //

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;

    bool _isLoading = false;
    return Scaffold(
      backgroundColor: lightWhite,
      body: isNetworkAvail
          ?
          // Your tab view content goes here
          Consumer<TabColor>(builder: (context, tabColor, child) {
            if(Provider.of<SubscriptionProvider>(context).checkSubscriptionData.isEmpty){
              if(Provider.of<SubscriptionProvider>(context).subscriptionList.isEmpty){
                return Center(
                  child: CircularProgressIndicator(),
                );
              }else{
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    GradientAppBar1(
                      title: 'Select Your Plan',
                    ),
                    Container(
                      height: 50,
                      child: TabBar(
                       indicatorColor: grad2Color,
                        indicatorWeight: 2,
                        indicatorSize: TabBarIndicatorSize.tab,

                        labelPadding: EdgeInsets.only(bottom: 3),
                       //  indicator: BoxDecoration(
                       //    color: Colors.red,
                       //  ),
                        indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.6),
                              blurRadius: 10,
                              offset: Offset(0, 3),
                            ),
                          ],
                          color: Colors.blue,
                        ),
                        controller: _tabController,
                        tabs: [
                          InkWell(
                            onTap: () {
                              _tabController.animateTo(0);
                              tabColor.updateSelectedColorPurple(Colors.purple);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0)),
                                color: _tabController.index == 0
                                    ? Colors.purple
                                    : Colors.purple, //.withOpacity(0.5),

                                //color: Colors.purple
                              ),
                              child: Center(
                                child: Text(
                                  "Yearly",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              tabColor.updateSelectedColorOrange(grad2Color);
                              _tabController.animateTo(1);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0)),
                                color: _tabController.index == 1
                                    ? grad2Color
                                    : grad2Color //.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  "6 Months",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              _tabController.animateTo(2);
                              tabColor.updateSelectedColorAqua(Colors.purple); //tabColor.updateSelectedColorAqua(Colors.cyanAccent);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    bottomLeft: Radius.circular(12.0),
                                    bottomRight: Radius.circular(12.0)),
                                color: _tabController.index == 2
                                    ? Colors.purple
                                    : Colors.purple //.withOpacity(0.5),
                              ),
                              child: Center(
                                child: Text(
                                  "Monthly",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: TabBarView(
                        controller: _tabController,
                        children: [
                          YearlyData(subscriptionList: Provider.of<SubscriptionProvider>(context).subscriptionList),
                          HalfYearlyData(subscriptionList: Provider.of<SubscriptionProvider>(context).subscriptionList,),
                          MonthlyData(subscriptionList: Provider.of<SubscriptionProvider>(context).subscriptionList),

                        ],
                      ),
                    ),
                  ],
                ) ;
            }

            }else{
              return Center(
                child: Card(
                  child: Container(
                      height: 200,
                      width: 200,
                      child: Center(child: Text("You have already subscribed",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: grad2Color,fontWeight: FontWeight.bold,fontSize: 20),))),
                ),
              );
            }

            })
          : noInternet(
              context,
              setStateNoInternate,
              buttonSqueezeanimation,
              buttonController,
            ),
    );
  }

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  setStateNoInternate() async {
    _playAnimation();
    Future.delayed(const Duration(seconds: 2)).then(
      (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Future.delayed(Duration.zero).then((value) => context
              .read<WalletTransactionProvider>()
              .getUserTransaction(context));
        } else {
          await buttonController!.reverse();
          setState(
            () {},
          );
        }
      },
    );
  }

  Future<void> _refresh() async {
    Completer<void> completer = Completer<void>();
    await Future.delayed(const Duration(seconds: 3)).then(
      (onvalue) {
        completer.complete();
        offset = 0;
        total = 0;
        setState(
          () {},
        );
        Future.delayed(Duration.zero).then((value) => context
            .read<WalletTransactionProvider>()
            .getUserTransaction(context));
        // getSallerBalance();
      },
    );
    return completer.future;
  }
}


