import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sellermultivendor/Provider/categoryProvider.dart';
import 'package:http/http.dart' as http;
import 'package:sellermultivendor/Screen/completeinfo/provider/allcat_provider.dart';

import '../../Widget/api.dart';
import '../../Widget/jwtkeySecurity.dart';
import '../../Widget/networkAvailablity.dart';
import '../../Widget/parameterString.dart';

class CompleteInfoPage extends StatefulWidget {
  @override
  _CompleteInfoPageState createState() => _CompleteInfoPageState();
}

class _CompleteInfoPageState extends State<CompleteInfoPage>
    with TickerProviderStateMixin {
  late String _selectedType;
  late String _selectedCategory;
  late String _selectedCity;
  late String _phoneNumber;
  late String _email;
  TextEditingController _storename = TextEditingController();
  TextEditingController _mobileNumber = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  File? _storeLogo;
  String dropdownValue = '';
  final _formKey = GlobalKey<FormState>();
  String _selectedTypeOfBusiness = "";

  AnimationController? buttonController;

  @override
  void initState() {
    // TODO: implement initState
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 //   Provider.of<AllCategoryProvider>(context).fetchCategory(context);
    //final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Complete Your Info'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextFormField(
                  controller: _storename,
                  decoration: InputDecoration(
                    labelText: 'Store Name',
                  ),
                ),
                SizedBox(height: 16.0),
                FutureBuilder<bool>(
                  future: Provider.of<AllCategoryProvider>(context).fetchCategory(context),
                  builder: (context, snapshot) {
                    return Consumer<AllCategoryProvider>(builder: (context, data, index) {
                      return DropdownButtonFormField<String>(
                        hint: Text("Select Category"),
                        value: dropdownValue.isNotEmpty ? dropdownValue : null,
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
                      );
                    });
                  }
                ),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                    hint: Text("Select type of business"),
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
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _mobileNumber,
                  decoration: InputDecoration(
                    labelText: 'Phone Number',
                  ),

                  keyboardType: TextInputType.phone,
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                  ),
                  //validator
                  onSaved: (value) {
                    _email = value.toString();
                  },
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 16.0),
                GestureDetector(
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
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      border: Border.all(
                        width: 1.0,
                        color: Colors.grey,
                      ),
                    ),
                    child: _storeLogo == null
                        ? Center(
                            child: Text('Tap to upload store logo'),
                          )
                        : Image.file(
                            _storeLogo!,
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState != null) {
                      checkNetwork();
                      // _formKey.currentState?.save();
                      // // TODO: Save data to backend
                      // ScaffoldMessenger.of(context).showSnackBar(
                      //   SnackBar(
                      //     content: Text('Info saved'),
                      //   ),
                      // );
                    }
                  },
                  child: Text('Save'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

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

  Future<void> sellerRegisterAPI() async {
    isNetworkAvail = await isNetworkAvailable();
    if (isNetworkAvail) {
      try {
        var request = http.MultipartRequest("POST", updateUserApi);
        request.headers.addAll(headers);
        request.fields[Name] = CUR_USERNAME.toString();
        request.fields[Mobile] = _mobileNumber.text.toString();
        request.fields[StoreName] = _storename.text.toString();
        request.fields['business_type'] = _selectedCategory.toString();
        request.fields['category_name'] = _selectedTypeOfBusiness.toString();
        request.fields[EmailText] = _emailController.text;
        if (_storeLogo != null) {
          final mimeType = lookupMimeType(_storeLogo!.path);
          var extension = mimeType!.split("/");
          var storelogo = await http.MultipartFile.fromPath(
            "store_logo",
            _storeLogo!.path,
            contentType: MediaType('image', extension[0]),
          );
          request.files.add(storelogo);
        }

        for (var key in request.fields.keys) {
          print('here=>>>> $key: ${request.fields[key]}');
        }
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print('Response Data: ' + responseString.toString());
        var getdata = json.decode(responseString);
        bool error = getdata["error"];
        String? msg = getdata['message'];
        if (!error) {
          //showMsgDialog(msg!);
          await buttonController!.reverse();
        } else {
          await buttonController!.reverse();
          // showMsgDialog(msg!);
        }
      } on TimeoutException catch (_) {
        // showOverlay(
        //   getTranslated(context, 'somethingMSg')!,
        //   context,
        // );
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
}
