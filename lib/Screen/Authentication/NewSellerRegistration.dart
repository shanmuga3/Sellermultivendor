import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Screen/Authentication/Login.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import '../../Helper/ApiBaseHelper.dart';
import '../../Helper/Color.dart';
import '../../Helper/Constant.dart';
import '../../Widget/ButtonDesing.dart';
import '../../Provider/settingProvider.dart';
import '../../Widget/jwtkeySecurity.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/overylay.dart';
import '../../Widget/parameterString.dart';
import '../../Widget/api.dart';
import '../../Widget/desing.dart';
import '../../Widget/validation.dart';
import '../../Widget/noNetwork.dart';
import '../completeinfo/provider/allcat_provider.dart';

class SellerRegister extends StatefulWidget {
  final String mobileno;
  const SellerRegister({Key? key, required this.mobileno}) : super(key: key);

  @override
  _SellerRegisterState createState() => _SellerRegisterState();
}

class _SellerRegisterState extends State<SellerRegister>
    with TickerProviderStateMixin {
//==============================================================================
//============================= Variables Declaration ==========================

  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController _storename = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  File? _storeLogo;
   FocusNode? nameFocus,
   storenamefocus,
      emailFocus,
      passFocus,
      confirmPassFocus,

      monumberFocus = FocusNode();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  ApiBaseHelper apiBaseHelper = ApiBaseHelper();
  final mobileController = TextEditingController();
  var addressProfFile, nationalIdentityCardFile, storeLogoFile;
  String? mobile,
      name,
  storename,
      email,
      password,
      confirmpassword;
  String _selectedTypeOfBusiness = "";

  String dropdownValue = '';
  late String _selectedCategory;

//==============================================================================
//============================= INIT Method ====================================

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: width * 0.7,
      end: 50.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController!,
        curve: const Interval(
          0.0,
          0.150,
        ),
      ),
    );
  }

//==============================================================================
//============================= For API Call ==================================

  Future<void> sellerRegisterAPI() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
    //  if(passwordController.text.toString() == confirmPasswordController.text.toString()){
        try {
          var request = http.MultipartRequest("POST", registerApi);
          request.headers.addAll(headers);
          request.fields[MOBILE] = widget.mobileno.toString();
          request.fields[Name] = nameController.text.toString() ;
        //  request.fields["user_id"] =  context.read<SettingProvider>().CUR_USERID!;
          request.fields[StoreName] = _storename.text.toString();
          request.fields['business_type'] = _selectedTypeOfBusiness.toString();
          request.fields['category_name'] = _selectedCategory.toString();
          request.fields[pan_number] = "";
          //request.fields[Mobile] = mobile!;
          request.fields[Address] = "";
          request.fields[tax_name] = "";
          request.fields[tax_number] = "";
          request.fields[Password] = password!;
          request.fields[EmailText] = email!;
          request.fields[ConfirmPassword] = confirmpassword!;
          if (_storeLogo != null) {
            final mimeType = lookupMimeType(_storeLogo!.path);
            var extension = mimeType!.split("/");
            var storelogo = await http.MultipartFile.fromPath(
              "store_logo",
              _storeLogo!.path,
              contentType: MediaType('image', extension[1]),
            );
            request.files.add(storelogo);
          }
          for (var key in request.fields.keys) {
            print('here=>>>> $key: ${request.fields[key]}');
          }
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print('Response Data: ' + responseString.toString() + registerApi.toString());
          var getdata = json.decode(responseString);
          bool error = getdata["error"];
          String? msg = getdata['message'];
          if (!error) {
            if(passwordController.text.toString() == confirmPasswordController.text.toString()){
              Navigator.push(context, MaterialPageRoute(builder: (context) => Login()));
              Future.delayed(Duration(seconds: 2)).then((value) => setSnackbar("Seller registered successfully",context));
           //   Future.delayed(Duration(seconds: 2)).then((value) => showMsgDialog(msg!));
              await buttonController!.reverse();
          }
            else{
              showDialog(context: context, builder: (context) => AlertDialog(
                content: Text("Password does not matched !"),

              )

              );
              await buttonController!.reverse();
            }

          } else {
            await buttonController!.reverse();
            showMsgDialog(msg!);
          }
        } on TimeoutException catch (_) {
          showOverlay(
            getTranslated(context, 'somethingMSg')!,
            context,
          );
        }

    } else {
      if (mounted) {
        setState(
              () {
            isNetworkAvail = false;
          },
        );
      }
    }
  }

  showMsgDialog(String msg) async {
    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(circularBorderRadius5),
                ),
              ),
              content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            msg,
                            style: Theme.of(this.context)
                                .textTheme
                                .subtitle1!
                                .copyWith(color: fontColor),
                            maxLines: 5,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

//==============================================================================
//============================= For Animation ==================================

  Future<void> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

//==============================================================================
//============================= Network Checking ===============================

  Future<void> checkNetwork() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      sellerRegisterAPI();
    } else {
      Future.delayed(
        const Duration(seconds: 2),
      ).then(
            (_) async {
          await buttonController!.reverse();
          setState(
                () {
              isNetworkAvail = false;
            },
          );
        },
      );
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

//==============================================================================
//============================= Dispose Method =================================

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

//==============================================================================
//============================= No Internet Widget =============================
  setStateNoInternate() async {
    _playAnimation();

    Future.delayed(const Duration(seconds: 2)).then(
          (_) async {
        isNetworkAvail = await isNetworkAvailable();
        if (isNetworkAvail) {
          Navigator.pushReplacement(
            context,
            CupertinoPageRoute(builder: (BuildContext context) => super.widget),
          );
        } else {
          await buttonController!.reverse();
          setState(
                () {},
          );
        }
      },
    );
  }

//==============================================================================
//============================= Build Method ===================================

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return ScaffoldMessenger(
      key: scaffoldMessengerKey,
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: white,
        body: isNetworkAvail
            ? getLoginContainer()
            : noInternet(
          context,
          setStateNoInternate,
          buttonSqueezeanimation,
          buttonController,
        ),
      ),
    );
  }

//==============================================================================
//============================= Login Container widget =========================

  getLoginContainer() {
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Form(
        key: _formkey,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  getLogo(),
                  setSignInLabel(),
                  setName(),
                  setMobileNo(),
                  storeName(),

                  setEmail(),
                  setPass(),
                  confirmPassword(),
                  typeofBusiness(),
                  category(),
                  storeLogo(),
                  loginBtn(),

                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  uploadStoreLogo(String title, int number) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
          ),
          InkWell(
            child: Container(
              decoration: BoxDecoration(
                color: primary,
                borderRadius: BorderRadius.circular(circularBorderRadius5),
              ),
              width: 90,
              height: 40,
              child: Center(
                child: Text(
                  getTranslated(context, "Upload")!,
                  style: const TextStyle(
                    color: white,
                  ),
                ),
              ),
            ),
            onTap: () {
              mainImageFromGallery(number);
            },
          ),
        ],
      ),
    );
  }

  mainImageFromGallery(int number) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'png', 'gif', 'bmp', 'eps'],
    );
    if (result != null) {
      File image = File(result.files.single.path!);

      setState(
            () {
          if (number == 1) {
            addressProfFile = image;
          }
          if (number == 2) {
            nationalIdentityCardFile = image;
          }
          if (number == 3) {
            storeLogoFile = image;
          }
        },
      );
    } else {
      // User canceled the picker
    }
  }

  selectedMainImageShow(File? name) {
    return name == null
        ? Container()
        : Image.file(
      name,
      width: 100,
      height: 100,
    );
  }

  Widget setSignInLabel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Align(
        alignment: Alignment.center,
        child: Text(
          getTranslated(context, "Seller Registration")!,
          style: const TextStyle(
            color: primary,
            fontSize: textFontSize30,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  setName() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(nameFocus);
        },
        keyboardType: TextInputType.text,
        controller: nameController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: nameFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          name = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.person,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "Name")!,
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }
storeLogo(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: GestureDetector(
        onTap: () async {
          // TODO: Implement image upload
          final pickedFile = await ImagePicker()
              .getImage(source: ImageSource.gallery);
          if (pickedFile != null) {
            setState(() {
              _storeLogo = File(pickedFile.path);
            });
          }
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Upload Store Logo :"),
            Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                border: Border.all(
                  width: 1.0,
                  color: Colors.grey,
                ),
              ),
              child: _storeLogo == null
                  ? Center(
                child: Text('Tap to upload store logo',style: TextStyle(fontSize: 10),),
              )
                  : Image.file(
                _storeLogo!,
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );
}
  storeName(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(storenamefocus);
        },
        keyboardType: TextInputType.text,
        controller: _storename,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: storenamefocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) =>
            StringValidation.validateThisFieldRequered(val!, context),
        onSaved: (String? value) {
          storename = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.store,
            color: lightBlack2,
            size: 20,
          ),
          hintText: "Store Name",
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }
  typeofBusiness(){
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: DropdownButtonFormField<String>(
 decoration: InputDecoration(
   prefixIcon: const Icon(Icons.business,color: lightBlack2,size: 20,)
 ),
          hint: Text("Select type of business",style:  Theme.of(context).textTheme.subtitle2!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return "    Please select a type of business";
            }
            return null;
          },
          value: _selectedTypeOfBusiness.isNotEmpty
              ? _selectedTypeOfBusiness
              : null,
          items: [
            DropdownMenuItem(
              value: 'company',
              child: Text("Company"),
            ),
            DropdownMenuItem(
              value: 'Individual',
              child: Text("Individual"),
            ),
          ],
          onChanged: (value) {
            setState(() {
              _selectedTypeOfBusiness = value.toString();
              //   _selectedCategory = _selectedTypeOfBusiness;
            });
          }),
    );
  }
  category(){
   return FutureBuilder<bool>(
        future: Provider.of<AllCategoryProvider>(context)
            .fetchCategory(context),
        builder: (context, snapshot) {
          return Consumer<AllCategoryProvider>(
              builder: (context, data, index) {
                return Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  padding: const EdgeInsets.only(
                    top: 30.0,
                  ),
                  child: DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.category_outlined,color: lightBlack2,size: 20,)
                    ),
                    hint: Text("Select Category",style:  Theme.of(context).textTheme.subtitle2!.copyWith(
                      color: lightBlack2,
                      fontWeight: FontWeight.normal,
                    ),),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "     Please select a category";
                      }
                      return null;
                    },
                    value:
                    dropdownValue.isNotEmpty ? dropdownValue : null,
                    items: data.categoryName.map((item) {
                      return DropdownMenuItem<String>(
                        value: item,
                        child: Text(item),
                      );
                    }).toList(),
                    onChanged: (newValue) {
                      setState(() {
                        dropdownValue = newValue.toString();
                        _selectedCategory = dropdownValue;
                        print("selected dropdown value: $dropdownValue");
                      });
                    },
                  ),
                );
              });
        });
  }












  setEmail() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(emailFocus);
        },
        keyboardType: TextInputType.text,
        controller: emailController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: emailFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.singleLineFormatter],
        validator: (val) => StringValidation.validateEmail(val!, context),
        onSaved: (String? value) {
          email = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: const Icon(
            Icons.email,
            color: lightBlack2,
            size: 20,
          ),
          hintText: getTranslated(context, "E-mail")!,
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  setMobileNo() {
    return Container(
      decoration: BoxDecoration(
      border: Border(
        bottom: BorderSide(
          color: Colors.grey,
          width: 0.5,
        ),
      )
      ),
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        enabled: false,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),

        decoration: InputDecoration(
          border: UnderlineInputBorder(
              borderSide: const BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),

          prefixIcon: const Icon(
            Icons.phone_android,
            color: lightBlack2,
            size: 20,
          ),
          hintText: "${widget.mobileno.toString()}",
          hintStyle: Theme.of(context).textTheme.subtitle2!.copyWith(
            color: lightBlack2,
            fontWeight: FontWeight.normal,
          ),
          filled: true,
          fillColor: white,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 10,
            vertical: 5,
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 40,
            maxHeight: 20,
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  setPass() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passFocus);
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: passwordController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: passFocus,
        textInputAction: TextInputAction.next,
        validator: (val) => StringValidation.validatePass(val!, context),
        onSaved: (String? value) {
          password = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: SvgPicture.asset(
            DesignConfiguration.setSvgPath('password'),
          ),
          hintText: getTranslated(context, "PASSHINT_LBL"),
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: lightBlack2, fontWeight: FontWeight.normal),
          fillColor: white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          suffixIconConstraints:
          const BoxConstraints(minWidth: 40, maxHeight: 20),
          prefixIconConstraints:
          const BoxConstraints(minWidth: 40, maxHeight: 20),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  confirmPassword() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.85,
      padding: const EdgeInsets.only(
        top: 15.0,
      ),
      child: TextFormField(
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(confirmPassFocus);
        },
        keyboardType: TextInputType.text,
        obscureText: true,
        controller: confirmPasswordController,
        style: const TextStyle(
          color: fontColor,
          fontWeight: FontWeight.normal,
        ),
        focusNode: confirmPassFocus,
        textInputAction: TextInputAction.next,
        validator: (val) => StringValidation.validatePass(val!, context),
        onSaved: (String? value) {
          confirmpassword = value;
        },
        decoration: InputDecoration(
          focusedBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: primary),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
          prefixIcon: SvgPicture.asset(
            DesignConfiguration.setSvgPath('password'),
          ),
          hintText: getTranslated(context, "CONFIRMPASSHINT_LBL")!,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: lightBlack2, fontWeight: FontWeight.normal),
          fillColor: white,
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          suffixIconConstraints:
          const BoxConstraints(minWidth: 40, maxHeight: 20),
          prefixIconConstraints:
          const BoxConstraints(minWidth: 40, maxHeight: 20),
          enabledBorder: UnderlineInputBorder(
            borderSide: const BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(circularBorderRadius7),
          ),
        ),
      ),
    );
  }

  loginBtn() {
    return AppBtn(
      title: getTranslated(context, "Apply Now")!,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        validateAndSubmit();
      },
    );
  }

  Widget getLogo() {
    return SizedBox(
      width: 100,
      height: 100,
      child: SvgPicture.asset(
        DesignConfiguration.setSvgPath('loginlogo'),
      ),
    );
  }


}


