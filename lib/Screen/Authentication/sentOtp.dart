// import 'package:country_code_picker/country_code_picker.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:provider/city__provider.dart';
//
// import 'package:sellermultivendor/Helper/Constant.dart';
// import 'package:sellermultivendor/Screen/Authentication/provider/authenticationProvider.dart';
//
// import '../../Provider/settingProvider.dart';
//
// import '../../Widget/networkAvailablity.dart';
// import '../../Widget/snackbar.dart';
// import '../../Widget/systemChromeSettings.dart';
// import '../../Widget/validation.dart';
// import 'VerifyOTP.dart';
// class SendOtp extends StatefulWidget {
//   String? title;
//
//   SendOtp({Key? key, this.title}) : super(key: key);
//
//   @override
//   _SendOtpState createState() => _SendOtpState();
// }
//
// class _SendOtpState extends State<SendOtp> with TickerProviderStateMixin {
//   bool visible = false;
//   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
//   final mobileController = TextEditingController();
//   final ccodeController = TextEditingController();
//   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
//   String? mobile, id, countrycode, countryName, mobileno;
//   Animation? buttonSqueezeanimation;
//   AnimationController? buttonController;
//
//   late double deviceHeight;
//   late double deviceWidth ;
//   void validateAndSubmit() async {
//     if (validateAndSave()) {
//       _playAnimation();
//       checkNetwork();
//     }
//   }
//
//   Future<void> _playAnimation() async {
//     try {
//       await buttonController!.forward();
//     } on TickerCanceled {}
//   }
//
//   Future<void> checkNetwork() async {
//     isNetworkAvail = await isNetworkAvailable();
//     if (isNetworkAvail) {
//       Future.delayed(Duration.zero).then(
//             (value) => context.read<AuthenticationProvider>().getVerifyUser().then(
//               (
//               value,
//               ) async {
//             bool? error = value['error'];
//             String? msg = value['message'];
//             await buttonController!.reverse();
//             SettingProvider settingsProvider =
//             Provider.of<SettingProvider>(context, listen: false);
//             if (widget.title == getTranslated(context, 'SEND_OTP_TITLE')) {
//               if (!error!) {
//                 setSnackbar(msg!, context);
//                 Future.delayed(const Duration(seconds: 1)).then(
//                       (_) {
//                     Navigator.pushReplacement(
//                       context,
//                       CupertinoPageRoute(
//                         builder: (context) => VerifyOtp(
//                           mobileNumber: mobile!,
//                           countryCode: countrycode,
//                           title: getTranslated(context, 'SEND_OTP_TITLE'),
//                         ),
//                       ),
//                     );
//                   },
//                 );
//               } else {
//                 setSnackbar(msg!, context);
//               }
//             }
//             // if (widget.title == getTranslated(context, 'FORGOT_PASS_TITLE')) {
//             //   if (error!) {
//             //     // settingsProvider.setPrefrence(MOBILE,
//             //     //     context.read<AuthenticationProvider>().mobilenumbervalue);
//             //     // settingsProvider.setPrefrence(COUNTRY_CODE, countrycode!);
//             //     Future.delayed(const Duration(seconds: 1)).then(
//             //           (_) {
//             //         Navigator.pushReplacement(
//             //           context,
//             //           CupertinoPageRoute(
//             //             builder: (context) => VerifyOtp(
//             //               mobileNumber: context
//             //                   .read<AuthenticationProvider>()
//             //                   .mobilenumbervalue,
//             //               countryCode: countrycode,
//             //               title: getTranslated(context, 'FORGOT_PASS_TITLE'),
//             //             ),
//             //           ),
//             //         );
//             //       },
//             //     );
//             //   } else {
//             //     setSnackbar(
//             //         getTranslated(context, 'FIRSTSIGNUP_MSG')!, context);
//             //   }
//             // }
//           },
//         ),
//       );
//     } else {
//       Future.delayed(const Duration(seconds: 2)).then(
//             (_) async {
//           if (mounted) {
//             setState(
//                   () {
//                 isNetworkAvail = false;
//               },
//             );
//           }
//           await buttonController!.reverse();
//         },
//       );
//     }
//   }
//
//   bool validateAndSave() {
//     final form = _formkey.currentState!;
//     form.save();
//     if (form.validate()) {
//       return true;
//     }
//     return false;
//   }
//
//   @override
//   void dispose() {
//     SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
//    // SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();
//
//     buttonController!.dispose();
//     super.dispose();
//   }
//
//   setStateNoInternate() async {
//     _playAnimation();
//
//     Future.delayed(const Duration(seconds: 2)).then(
//           (_) async {
//         isNetworkAvail = await isNetworkAvailable();
//         if (isNetworkAvail) {
//           Navigator.pushReplacement(
//             context,
//             CupertinoPageRoute(builder: (BuildContext context) => super.widget),
//           );
//         } else {
//           await buttonController!.reverse();
//           if (mounted) {
//             setState(
//                   () {},
//             );
//           }
//         }
//       },
//     );
//   }
//
//   Widget verifyCodeTxt() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 13.0),
//       child: Text(
//         getTranslated(context, 'SEND_VERIFY_CODE_LBL')!,
//         style: Theme.of(context).textTheme.subtitle2!.copyWith(
//           color: Color(0xff222222).withOpacity(0.4),
//           fontWeight: FontWeight.bold,
//           fontFamily: 'ubuntu',
//         ),
//         overflow: TextOverflow.ellipsis,
//         softWrap: true,
//         maxLines: 3,
//       ),
//     );
//   }
//
//   Widget setCodeWithMono() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 45),
//       child: Container(
//         height: 53,
//         width: double.maxFinite,
//         decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(circularBorderRadius10),
//         ),
//         child: Row(
//           mainAxisSize: MainAxisSize.min,
//           children: <Widget>[
//             Expanded(
//               flex: 2,
//               child: setCountryCode(),
//             ),
//             Expanded(
//               flex: 4,
//               child: setMono(),
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget setCountryCode() {
//     double width = deviceWidth!;
//     double height = deviceHeight! * 0.9;
//     return CountryCodePicker(
//       showCountryOnly: false,
//       searchStyle: TextStyle(
//         color: Color(0xff222222),
//       ),
//       flagWidth: 20,
//       boxDecoration: BoxDecoration(
//         color: Colors.white,
//       ),
//       searchDecoration: InputDecoration(
//         hintText: getTranslated(context, 'COUNTRY_CODE_LBL'),
//         hintStyle: TextStyle(color: Theme.of(context).colorScheme.fontColor),
//         fillColor: Color(0xff222222),
//       ),
//       showOnlyCountryWhenClosed: false,
//       initialSelection: defaultCountryCode,
//       dialogSize: Size(width, height),
//       alignLeft: true,
//       textStyle: TextStyle(
//           color:Color(0xff222222),
//           fontWeight: FontWeight.bold),
//       onChanged: (CountryCode countryCode) {
//         countrycode = countryCode.toString().replaceFirst('+', '');
//         countryName = countryCode.name;
//       },
//       onInit: (code) {
//         countrycode = code.toString().replaceFirst('+', '');
//       },
//     );
//   }
//
//   Widget setMono() {
//     return TextFormField(
//       keyboardType: TextInputType.number,
//       controller: mobileController,
//       style: Theme.of(context).textTheme.subtitle2!.copyWith(
//           color: Color(0xff222222),
//           fontWeight: FontWeight.normal),
//       inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//       validator: (val) => StringValidation.validateMob(
//           val!,
//           getTranslated(context, 'MOB_REQUIRED'),
//           getTranslated(context, 'VALID_MOB')),
//       onSaved: (String? value) {
//         context.read<AuthenticationProvider>().setMobileNumber(value);
//         mobile = value;
//       },
//       decoration: InputDecoration(
//         hintText: getTranslated(context, 'MOBILEHINT_LBL'),
//         hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
//             color: Theme.of(context).colorScheme.fontColor,
//             fontWeight: FontWeight.normal),
//         contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
//         focusedBorder: UnderlineInputBorder(
//           borderSide: const BorderSide(color: colors.primary),
//           borderRadius: BorderRadius.circular(circularBorderRadius7),
//         ),
//         border: InputBorder.none,
//         enabledBorder: UnderlineInputBorder(
//           borderSide: BorderSide(
//             color: Theme.of(context).colorScheme.lightWhite,
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget verifyBtn() {
//     return Padding(
//       padding: const EdgeInsets.only(top: 20.0),
//       child: Center(
//         child: AppBtn(
//           title: widget.title == getTranslated(context, 'SEND_OTP_TITLE')
//               ? getTranslated(context, 'SEND_OTP')
//               : getTranslated(context, 'GET_PASSWORD'),
//           btnAnim: buttonSqueezeanimation,
//           btnCntrl: buttonController,
//           onBtnSelected: () async {
//             validateAndSubmit();
//           },
//         ),
//       ),
//     );
//   }
//
//   Widget termAndPolicyTxt() {
//     return widget.title == getTranslated(context, 'SEND_OTP_TITLE')
//         ? SizedBox(
//       height: deviceHeight! * 0.18,
//       width: double.maxFinite,
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             getTranslated(context, 'CONTINUE_AGREE_LBL')!,
//             style: Theme.of(context).textTheme.caption!.copyWith(
//               color: Theme.of(context).colorScheme.fontColor,
//               fontWeight: FontWeight.normal,
//               fontFamily: 'ubuntu',
//             ),
//           ),
//           const SizedBox(
//             height: 3.0,
//           ),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     CupertinoPageRoute(
//                       builder: (context) => PrivacyPolicy(
//                         title: getTranslated(context, 'TERM'),
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   getTranslated(context, 'TERMS_SERVICE_LBL')!,
//                   style: Theme.of(context).textTheme.caption!.copyWith(
//                     color: Theme.of(context).colorScheme.fontColor,
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.normal,
//                     fontFamily: 'ubuntu',
//                   ),
//                   overflow: TextOverflow.clip,
//                   softWrap: true,
//                   maxLines: 1,
//                 ),
//               ),
//               const SizedBox(
//                 width: 5.0,
//               ),
//               Text(
//                 getTranslated(context, 'AND_LBL')!,
//                 style: Theme.of(context).textTheme.caption!.copyWith(
//                   color: Theme.of(context).colorScheme.fontColor,
//                   fontWeight: FontWeight.normal,
//                   fontFamily: 'ubuntu',
//                 ),
//               ),
//               const SizedBox(
//                 width: 5.0,
//               ),
//               InkWell(
//                 onTap: () {
//                   Navigator.push(
//                     context,
//                     CupertinoPageRoute(
//                       builder: (context) => PrivacyPolicy(
//                         title: getTranslated(context, 'PRIVACY'),
//                       ),
//                     ),
//                   );
//                 },
//                 child: Text(
//                   getTranslated(context, 'PRIVACY')!,
//                   style: Theme.of(context).textTheme.caption!.copyWith(
//                     color: Theme.of(context).colorScheme.fontColor,
//                     decoration: TextDecoration.underline,
//                     fontWeight: FontWeight.normal,
//                     fontFamily: 'ubuntu',
//                   ),
//                   overflow: TextOverflow.clip,
//                   softWrap: true,
//                   maxLines: 1,
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     )
//         : const SizedBox();
//   }
//
//   @override
//   void initState() {
//     SystemChromeSettings.setSystemButtomNavigationBarithTopAndButtom();
//     SystemChromeSettings.setSystemUIOverlayStyleWithNoSpecification();
//
//     super.initState();
//     buttonController = AnimationController(
//         duration: const Duration(milliseconds: 2000), vsync: this);
//
//     buttonSqueezeanimation = Tween(
//       begin: deviceWidth! * 0.7,
//       end: 50.0,
//     ).animate(
//       CurvedAnimation(
//         parent: buttonController!,
//         curve: const Interval(
//           0.0,
//           0.150,
//         ),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     deviceHeight = MediaQuery.of(context).size.height;
//     deviceWidth = MediaQuery.of(context).size.width;
//     return Scaffold(
//       resizeToAvoidBottomInset: true,
//       key: _scaffoldKey,
//       backgroundColor: Theme.of(context).colorScheme.white,
//       bottomNavigationBar: termAndPolicyTxt(),
//       body: isNetworkAvail
//           ? Center(
//         child: SingleChildScrollView(
//           padding: EdgeInsets.only(
//             top: 23,
//             left: 23,
//             right: 23,
//             bottom: MediaQuery.of(context).viewInsets.bottom,
//           ),
//           child: Form(
//             key: _formkey,
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 getLogo(),
//                 signUpTxt(),
//                 verifyCodeTxt(),
//                 setCodeWithMono(),
//                 verifyBtn(),
//               ],
//             ),
//           ),
//         ),
//       )
//           : NoInterNet(
//         setStateNoInternate: setStateNoInternate,
//         buttonSqueezeanimation: buttonSqueezeanimation,
//         buttonController: buttonController,
//       ),
//     );
//   }
//
//   Widget getLogo() {
//     return Container(
//       alignment: Alignment.center,
//       padding: const EdgeInsets.only(top: 60),
//       child: SvgPicture.asset(
//         DesignConfiguration.setSvgPath('homelogo'),
//         alignment: Alignment.center,
//         height: 90,
//         width: 90,
//         fit: BoxFit.contain,
//       ),
//     );
//   }
//
//   Widget signUpTxt() {
//     return Padding(
//       padding: const EdgeInsetsDirectional.only(
//         top: 40.0,
//       ),
//       child: Text(
//         widget.title == getTranslated(context, 'SEND_OTP_TITLE')
//             ? getTranslated(context, 'SIGN_UP_LBL')!
//             : getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
//         style: Theme.of(context).textTheme.headline6!.copyWith(
//           color: Theme.of(context).colorScheme.fontColor,
//           fontWeight: FontWeight.bold,
//           fontSize: textFontSize23,
//           fontFamily: 'ubuntu',
//           letterSpacing: 0.8,
//         ),
//       ),
//     );
//   }
// }
//
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter_svg/svg.dart';
// // import 'package:sellermultivendor/Helper/ApiBaseHelper.dart';
// // import 'package:sellermultivendor/Screen/Authentication/NewSellerRegistration.dart';
// // import 'package:sellermultivendor/Widget/ContainerDesing.dart';
// // import 'package:sellermultivendor/Widget/networkAvailablity.dart';
// // import 'package:sellermultivendor/Widget/snackbar.dart';
// //
// // import '../../Helper/Color.dart';
// // import '../../Helper/Constant.dart';
// // import '../../Provider/settingProvider.dart';
// // import '../../Widget/ButtonDesing.dart';
// // import '../../Widget/api.dart';
// // import '../../Widget/desing.dart';
// // import '../../Widget/noNetwork.dart';
// // import '../../Widget/parameterString.dart';
// // import '../../Widget/scrollBehavior.dart';
// // import '../../Widget/validation.dart';
// // class SetPass extends StatefulWidget {
// //   final String mobileNumber;
// //
// //   const SetPass({
// //     Key? key,
// //     required this.mobileNumber,
// //   }) : super(key: key);
// //
// //   @override
// //   _LoginPageState createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<SetPass> with TickerProviderStateMixin {
// //   final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
// //   final confirmpassController = TextEditingController();
// //   final passwordController = TextEditingController();
// //   final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
// //   String? password, comfirmpass;
// //   Animation? buttonSqueezeanimation;
// //   ApiBaseHelper apiBaseHelper = ApiBaseHelper();
// //   AnimationController? buttonController;
// //
// //   void validateAndSubmit() async {
// //     if (validateAndSave()) {
// //       _playAnimation();
// //       checkNetwork();
// //     }
// //   }
// //
// //   Future<void> checkNetwork() async {
// //     bool avail = await isNetworkAvailable();
// //     if (avail) {
// //       getResetPass();
// //     } else {
// //       Future.delayed(const Duration(seconds: 2)).then(
// //             (_) async {
// //           setState(
// //                 () {
// //               isNetworkAvail = false;
// //             },
// //           );
// //           await buttonController!.reverse();
// //         },
// //       );
// //     }
// //   }
// //
// //   bool validateAndSave() {
// //     final form = _formkey.currentState!;
// //     form.save();
// //     if (form.validate()) {
// //       return true;
// //     }
// //     return false;
// //   }
// //
// //   setStateNoInternate() async {
// //     _playAnimation();
// //
// //     Future.delayed(const Duration(seconds: 2)).then(
// //           (_) async {
// //         isNetworkAvail = await isNetworkAvailable();
// //         if (isNetworkAvail) {
// //           Navigator.pushReplacement(
// //             context,
// //             CupertinoPageRoute(builder: (BuildContext context) => super.widget),
// //           );
// //         } else {
// //           await buttonController!.reverse();
// //           setState(
// //                 () {},
// //           );
// //         }
// //       },
// //     );
// //   }
// //
// //   Future<void> getResetPass() async {
// //     var data = {
// //       mobileno: widget.mobileNumber,
// //       NEWPASS: password,
// //     };
// //     apiBaseHelper.postAPICall(getVerifyUserApi, data).then(
// //           (getdata) async {
// //         bool error = getdata["error"];
// //         String? msg = getdata["message"];
// //         await buttonController!.reverse();
// //         if (!error) {
// //           setSnackbar(
// //             getTranslated(context, "PASS_SUCCESS_MSG")!,
// //             context,
// //           );
// //           Future.delayed(
// //             const Duration(seconds: 1),
// //           ).then(
// //                 (_) {
// //               Navigator.of(context).pushReplacement(
// //                 CupertinoPageRoute(
// //                   builder: (BuildContext context) => const SellerRegister(),
// //                 ),
// //               );
// //             },
// //           );
// //         } else {
// //           setSnackbar(
// //             msg!,
// //             context,
// //           );
// //         }
// //       },
// //       onError: (error) {
// //         setSnackbar(
// //           error.toString(),
// //           context,
// //         );
// //       },
// //     );
// //   }
// //
// //   forgotpassTxt() {
// //     return Padding(
// //       padding: const EdgeInsetsDirectional.only(
// //         top: 40.0,
// //       ),
// //       child: Align(
// //         alignment: Alignment.topLeft,
// //         child: Text(
// //           getTranslated(context, 'FORGOT_PASSWORDTITILE')!,
// //           style: Theme.of(context).textTheme.headline6!.copyWith(
// //             color: black,
// //             fontWeight: FontWeight.bold,
// //             fontSize: textFontSize23,
// //             letterSpacing: 0.8,
// //             fontFamily: 'ubuntu',
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void dispose() {
// //     buttonController!.dispose();
// //     super.dispose();
// //   }
// //
// //   setPass() {
// //     return Padding(
// //       padding: const EdgeInsets.only(top: 40),
// //       child: Container(
// //         height: 53,
// //         width: double.maxFinite,
// //         decoration: BoxDecoration(
// //           color: lightWhite,
// //           borderRadius: BorderRadius.circular(circularBorderRadius10),
// //         ),
// //         alignment: Alignment.center,
// //         child: TextFormField(
// //           style: TextStyle(
// //               color: black.withOpacity(0.7),
// //               fontWeight: FontWeight.bold,
// //               fontSize: textFontSize13),
// //           keyboardType: TextInputType.text,
// //           obscureText: true,
// //           controller: passwordController,
// //           textInputAction: TextInputAction.next,
// //           validator: (val) => StringValidation.validatePass(val, context),
// //           onSaved: (String? value) {
// //             password = value;
// //           },
// //           decoration: InputDecoration(
// //             contentPadding: const EdgeInsets.symmetric(
// //               horizontal: 13,
// //               vertical: 5,
// //             ),
// //             hintText: getTranslated(context, 'PASSHINT_LBL')!,
// //             hintStyle: TextStyle(
// //                 color: black.withOpacity(0.3),
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: textFontSize13),
// //             fillColor: lightWhite,
// //             border: InputBorder.none,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   setConfirmpss() {
// //     return Padding(
// //       padding: const EdgeInsets.only(top: 18),
// //       child: Container(
// //         height: 53,
// //         width: double.maxFinite,
// //         decoration: BoxDecoration(
// //           color: lightWhite,
// //           borderRadius: BorderRadius.circular(circularBorderRadius10),
// //         ),
// //         alignment: Alignment.center,
// //         child: TextFormField(
// //           style: TextStyle(
// //               color: black.withOpacity(0.7),
// //               fontWeight: FontWeight.bold,
// //               fontSize: textFontSize13),
// //           keyboardType: TextInputType.text,
// //           obscureText: true,
// //           controller: confirmpassController,
// //           validator: (value) {
// //             if (value!.isEmpty) {
// //               return getTranslated(context, "CON_PASS_REQUIRED_MSG")!;
// //             }
// //             if (value != password) {
// //               return getTranslated(context, "CON_PASS_NOT_MATCH_MSG")!;
// //             } else {
// //               return null;
// //             }
// //           },
// //           onSaved: (String? value) {
// //             comfirmpass = value;
// //           },
// //           decoration: InputDecoration(
// //             contentPadding: const EdgeInsets.symmetric(
// //               horizontal: 13,
// //               vertical: 5,
// //             ),
// //             hintText: getTranslated(context, 'CONFIRMPASSHINT_LBL')!,
// //             hintStyle: TextStyle(
// //                 color: black.withOpacity(0.3),
// //                 fontWeight: FontWeight.bold,
// //                 fontSize: textFontSize13),
// //             fillColor: lightWhite,
// //             border: InputBorder.none,
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     buttonController = AnimationController(
// //       duration: const Duration(milliseconds: 2000),
// //       vsync: this,
// //     );
// //
// //     buttonSqueezeanimation = Tween(
// //       begin: width * 0.7,
// //       end: 50.0,
// //     ).animate(
// //       CurvedAnimation(
// //         parent: buttonController!,
// //         curve: const Interval(
// //           0.0,
// //           0.150,
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Future<void> _playAnimation() async {
// //     try {
// //       await buttonController!.forward();
// //     } on TickerCanceled {}
// //   }
// //
// //   setPassBtn() {
// //     return Center(
// //       child: Padding(
// //         padding: const EdgeInsetsDirectional.only(top: 20.0, bottom: 20.0),
// //         child: AppBtn(
// //           title: getTranslated(context, 'SET_PASSWORD'),
// //           btnAnim: buttonSqueezeanimation,
// //           btnCntrl: buttonController,
// //           onBtnSelected: () async {
// //             validateAndSubmit();
// //           },
// //         ),
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     height = MediaQuery.of(context).size.height;
// //     width = MediaQuery.of(context).size.width;
// //     return Scaffold(
// //       key: _scaffoldKey,
// //       body: isNetworkAvail
// //           ? Center(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.only(
// //               top: 23,
// //               left: 23,
// //               right: 23,
// //               bottom: MediaQuery.of(context).viewInsets.bottom),
// //           child: Form(
// //             key: _formkey,
// //             child: Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 getLogo(),
// //                 forgotpassTxt(),
// //                 setPass(),
// //                 setConfirmpss(),
// //                 setPassBtn(),
// //               ],
// //             ),
// //           ),
// //         ),
// //       )
// //           : noInternet(context, setStateNoInternate, buttonSqueezeanimation,
// //           buttonController),
// //     );
// //   }
// //
// //   getLoginContainer() {
// //     return Positioned.directional(
// //       start: MediaQuery.of(context).size.width * 0.025,
// //       top: MediaQuery.of(context).size.height * 0.2, //original
// //       textDirection: Directionality.of(context),
// //       child: ClipPath(
// //         clipper: ContainerClipper(),
// //         child: Container(
// //           alignment: Alignment.center,
// //           padding: EdgeInsets.only(
// //               bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
// //           height: MediaQuery.of(context).size.height * 0.7,
// //           width: MediaQuery.of(context).size.width * 0.95,
// //           color: white,
// //           child: Form(
// //             key: _formkey,
// //             child: ScrollConfiguration(
// //               behavior: MyBehavior(),
// //               child: SingleChildScrollView(
// //                 child: ConstrainedBox(
// //                   constraints: BoxConstraints(
// //                     maxHeight: MediaQuery.of(context).size.height * 2,
// //                   ),
// //                   child: Column(
// //                     mainAxisSize: MainAxisSize.min,
// //                     children: [
// //                       SizedBox(
// //                         height: MediaQuery.of(context).size.height * 0.10,
// //                       ),
// //                       forgotpassTxt(),
// //                       setPass(),
// //                       setConfirmpss(),
// //                       setPassBtn(),
// //                       SizedBox(
// //                         height: MediaQuery.of(context).size.height * 0.10,
// //                       ),
// //                     ],
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget getLogo() {
// //     return Container(
// //       alignment: Alignment.center,
// //       padding: const EdgeInsets.only(top: 60),
// //       child: SvgPicture.asset(
// //         DesignConfiguration.setSvgPath('loginlogo'),
// //         alignment: Alignment.center,
// //         height: 90,
// //         width: 90,
// //         fit: BoxFit.contain,
// //       ),
// //     );
// //   }
// // }
