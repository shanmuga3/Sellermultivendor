import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:provider/provider.dart';
import 'package:http_parser/http_parser.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Provider/categoryProvider.dart';
import 'package:http/http.dart' as http;
import 'package:sellermultivendor/Screen/completeinfo/provider/allcat_provider.dart';

import '../../Provider/settingProvider.dart';
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
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.keyboard_arrow_left,
            color: Colors.white,
          ),
        ),
        backgroundColor: newPrimary,
        title: Text(
          'Complete Your Info',
          style: TextStyle(color: Colors.white),
        ),
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
                labelText: 'Update store name',
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.grey),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.blue),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                filled: true,
                fillColor: Colors.white,
                prefixIcon: Icon(Icons.person),
              ),

                ),
                SizedBox(height: 16.0),
                FutureBuilder<bool>(
                    future: Provider.of<AllCategoryProvider>(context)
                        .fetchCategory(context),
                    builder: (context, snapshot) {
                      return Consumer<AllCategoryProvider>(
                          builder: (context, data, index) {
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select category',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.blue),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.red),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          hint: Text("Select Category"),
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
                        );
                      });
                    }),
                SizedBox(height: 16.0),
                DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Type of business',
                      labelStyle: TextStyle(
                        color: Colors.grey,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.red),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
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
                    labelText: 'Update mobile number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person),
                  ),


                  keyboardType: TextInputType.phone,

                ),
                SizedBox(height: 16.0),
                TextFormField(

                  controller: _emailController,
                  // decoration: InputDecoration(
                  //   labelText: 'Email',
                  //
                  // ),
                  decoration: InputDecoration(
                    labelText: 'Enter email',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.person),
                  ),

                  validator: (value) {
                    if (value?.length != 10) {
                      return 'Please enter a store name';
                    }
                    return null;
                  },
                  //validator
                  // onSaved: (value) {
                  //   _email = value.toString();
                  // },
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
                    height: 150,
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
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.grey),
                      ),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState != null) {
                      checkNetwork();
                    }
                  },
                  child: Text('Update Information',style: TextStyle(color: Colors.white),),
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

      sellerUpdateAPI();
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
  bool isUpdating = false;
  Future<void> sellerUpdateAPI() async {
    isNetworkAvail = await isNetworkAvailable();

    if (isNetworkAvail) {
      setState(() {
        isUpdating = true;
      });

      try {
        if (isUpdating == true) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: Container(
                  height: 20,
                  width: 20,
                  child: Center(child: CircularProgressIndicator())),
            ),
          );
        }
        var request = http.MultipartRequest("POST", updateUserApi);
        request.headers.addAll(headers);
        request.fields["id"] =
            context.read<SettingProvider>().CUR_USERID.toString();
        request.fields[Name] = CUR_USERNAME.toString();
        request.fields[Mobile] = _mobileNumber.text.toString();
        request.fields[StoreName] = _storename.text.toString();
        request.fields['business_type'] = _selectedTypeOfBusiness.toString();
        request.fields['category_name'] = _selectedCategory.toString();
        request.fields[EmailText] = _emailController.text.toString();
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

        print('here=>>>> ${request.headers}');
        for (var key in request.fields.keys) {
          print('here=>>>> $key: ${request.fields[key]}');
        }
        var response = await request.send();
        print('Response Data: 1 ' + response.statusCode.toString());
        var responseData = await response.stream.toBytes();
        print('Response Data: 2 ' + responseData.toString());
        var responseString = String.fromCharCodes(responseData);
        print('Response Data:  3' + responseString.toString());
        var getdata = jsonDecode(responseString.toString());
        bool error = getdata["error"];
        String? msg = getdata['message'];
        if (!error) {

          setState(() {
            isUpdating = false;
            //   Navigator.push(context, MaterialPageRoute(builder: (context)))
            if (!error) {
              Navigator.pop(context); // dismiss any existing dialogs
              if (!isUpdating) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      AlertDialog(
                        content: Text("Seller data Updated Successfully"),
                      ),
                );
              }
            }});
          //showMsgDialog(msg!);
          await buttonController!.reverse();
        } else {
          await buttonController!.reverse();
          // showMsgDialog(msg!);
        }
      } on TimeoutException catch (_) {
        print("errooeesis here ${_}");
      }finally {
        if (mounted) {
          setState(() {
            isUpdating = false;
          });
        }
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
