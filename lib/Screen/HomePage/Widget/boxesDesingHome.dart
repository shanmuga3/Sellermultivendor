import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Screen/Campaign/campaign_home.dart';
import '../../../Helper/Color.dart';
import '../../../Helper/Constant.dart';
import '../../../Provider/walletProvider.dart';
import '../../../Widget/desing.dart';
import '../../../Widget/routes.dart';
import '../../ProductList/ProductList.dart';
import '../../Subscription/selectPlan.dart';
import '../../WalletHistory/WalletHistory.dart';

boxesDesingHome(
  String svg,
  String title,
  String? numberCounting,
  int index,
  BuildContext context,
) {
  return Expanded(
    child: InkWell(
      onTap: () {
        if (index == 0) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) =>
                  ChangeNotifierProvider<WalletTransactionProvider>(
                create: (context) => WalletTransactionProvider(),
                child: const WalletHistory(),
              ),
            ),
          );
        } else if (index == 1) {
          Routes.navigateToSalesReport(context);
        } else if (index == 2) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                flag: "sold",
                fromNavbar: false,
              ),
            ),
          );
        } else if (index == 3) {
          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                flag: "low",
                fromNavbar: false,
              ),
            ),
          );
        }
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius:
                BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 141,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsetsDirectional.only(
                    top: 18.0, bottom: 15.0, start: 18.0),
                child: SvgPicture.asset(
                  DesignConfiguration.setSvgPath(svg),
                  width: 30,
                  height: 30,
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 18.0,
                  bottom: 10.0,
                ),
                child: Text(title,
                    style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.w400,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize14),
                    textAlign: TextAlign.left),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.only(
                  start: 18.0,
                  bottom: 10.0,
                ),
                child: Text(numberCounting ?? "",
                    style: const TextStyle(
                        color: black,
                        fontWeight: FontWeight.w700,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize16),
                    textAlign: TextAlign.left),
              )
            ],
          ),
        ),
      ),
    ),
  );
}

boxesDesingHome1(

    String title,
    int index,
    BuildContext context,
    ) {
  return Expanded(
    child: InkWell(
      onTap: () {

          Navigator.push(
            context,
            CupertinoPageRoute(
              builder: (context) => ProductList(
                flag: "sold",
                fromNavbar: false,
              ),
            ),
          );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius:
            BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
               Padding(
                 padding: const EdgeInsets.only(left: 10,right: 10),
                 child: Text(title,

                      style: const TextStyle(
                          color: Color(0xffff9366),
                          fontWeight: FontWeight.bold,
                          fontFamily: "PlusJakartaSans",
                          fontStyle: FontStyle.normal,
                          fontSize: textFontSize12),
                      textAlign: TextAlign.center),
               ),

            ],
          ),
        ),
      ),
    ),
  );
}

boxesDesingHome2(

    String title,
    int index,
    BuildContext context,
    ) {
  return Expanded(
    child: InkWell(
      onTap: () {

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) =>SelectYourPlan()
          ),
        );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [grad1Color, grad2Color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

               Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: "PlusJakartaSans",
                        fontStyle: FontStyle.normal,
                        fontSize: textFontSize14),
                    textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}

boxesDesingHome3(

    String title,
    int index,
    BuildContext context,
    ) {
  return Expanded(
    child: InkWell(
      onTap: () {

        Navigator.push(
          context,
          CupertinoPageRoute(
            builder: (context) => Campaign_List()
          ),
        );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5F0A87), Color(0xFFA4508B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 100,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize20),
                  textAlign: TextAlign.center),
              SizedBox(width: 10,),
              Image.asset("assets/images/PNG/campaign.png",fit: BoxFit.cover,height: 30,width: 30,)
            ],
          ),
        ),
      ),
    ),
  );
}

boxesDesingHome4(

    String title,
    int index,
    BuildContext context,
    ) {
  return InkWell(
    onTap: () {

      Navigator.push(
        context,
        CupertinoPageRoute(
          builder: (context) => ProductList(
            flag: "sold",
            fromNavbar: false,
          ),
        ),
      );
    },
    child: Padding(
      padding: EdgeInsetsDirectional.only(
        top: 20,
         end: index == 0 || index == 2 ? 7.5 : 0.0,
         start: index == 1 || index == 3 ? 7.5 : 0.0,
      ),
      child: Container(
        decoration: const BoxDecoration(
          borderRadius:
          BorderRadius.all(Radius.circular(circularBorderRadius15)),
          color: white,
          boxShadow: [
            BoxShadow(
              color: blarColor,
              offset: Offset(0, 0),
              blurRadius: 4,
              spreadRadius: 0,
            ),
          ],
        ),
        height:200 ,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 10,right: 10),
              child: Text(title,

                  style: const TextStyle(
                      color: Color(0xffff9366),
                      fontWeight: FontWeight.bold,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize12),
                  textAlign: TextAlign.center),
            ),

          ],
        ),
      ),
    ),
  );
}

boxesDesingHome_Advanced(

    String title,
    int index,
    BuildContext context,
    ) {
  return Expanded(
    child: InkWell(
      onTap: () {

        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //       builder: (context) =>SelectYourPlan()
        //   ),
        // );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue, Colors.teal],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize20),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}
boxesDesingHome_Standard(

    String title,
    int index,
    BuildContext context,
    ) {
  return Expanded(
    child: InkWell(
      onTap: () {

        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //       builder: (context) =>SelectYourPlan()
        //   ),
        // );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [grad1Color,grad2Color],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize20),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}
boxesDesingHome_Premium(

    String title,
    int index,
    BuildContext context,
    ) {
  return Expanded(
    child: InkWell(
      onTap: () {

        // Navigator.push(
        //   context,
        //   CupertinoPageRoute(
        //       builder: (context) =>SelectYourPlan()
        //   ),
        // );
      },
      child: Padding(
        padding: EdgeInsetsDirectional.only(
          end: index == 0 || index == 2 ? 7.5 : 0.0,
          start: index == 1 || index == 3 ? 7.5 : 0.0,
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [ Color(0xFFA4508B),Color(0xFF5F0A87)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius:
            BorderRadius.all(Radius.circular(circularBorderRadius15)),
            color: white,
            boxShadow: [
              BoxShadow(
                color: blarColor,
                offset: Offset(0, 0),
                blurRadius: 4,
                spreadRadius: 0,
              ),
            ],
          ),
          height: 100,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: "PlusJakartaSans",
                      fontStyle: FontStyle.normal,
                      fontSize: textFontSize20),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    ),
  );
}