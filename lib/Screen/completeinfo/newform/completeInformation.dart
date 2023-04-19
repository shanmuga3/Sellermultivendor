import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:location/location.dart' as mylocation;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:sellermultivendor/Helper/Color.dart';
import 'package:sellermultivendor/Screen/AddProduct/Add_Product.dart';
import 'package:sellermultivendor/Screen/DeshBord/dashboard.dart';
import 'package:sellermultivendor/Screen/HomePage/home.dart';
import 'package:sellermultivendor/Screen/completeinfo/newform/city__provider.dart';
import 'package:sellermultivendor/Widget/snackbar.dart';
import 'package:sellermultivendor/Widget/validation.dart';

import '../../../Provider/settingProvider.dart';
import '../../../Widget/api.dart';
import '../../../Widget/routes.dart';
import '../../AddProduct/Widget/Dialogs/countryDialog.dart';
import '../../AddProduct/Widget/getIconSelectionDesingWidget.dart';

class LocationData {
  final double lat;
  final double lng;
  final String address;

  LocationData({required this.lat, required this.lng, required this.address});
}

Future<String> getAreaFromLocation(double lat, double lng) async {
  final apiKey = 'AIzaSyA0OTEj5X-k6NL9P4O-JS-rht0KVjrHZeI';
  final apiUrl =
      'https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$apiKey';

  final response = await http.get(Uri.parse(apiUrl));
  final decodedResponse = json.decode(response.body);

  if (decodedResponse['status'] == 'OK') {
    final results = decodedResponse['results'][0]['address_components'];
    for (var result in results) {
      final types = result['types'];
      if (types.contains('sublocality_level_1') || types.contains('locality')) {
        return result['long_name'];
      }
    }
  }
  return 'Unknown area';
}

Future<List<String>> getNearbyAreas(double lat, double lng) async {
  final apiKey = 'AIzaSyA0OTEj5X-k6NL9P4O-JS-rht0KVjrHZeI';
  final places = GoogleMapsPlaces(apiKey: apiKey);

  final response = await places.searchNearbyWithRadius(
    Location(lat: lat, lng: lng),
    1000, // in meters
    type: 'sublocality_level_1', // type of location to search for
  );

  List<String> areas = [];
  for (var place in response.results) {
    areas.add(place.name);
  }

  return areas;
}

class LocationScreen extends StatefulWidget {
  @override
  _LocationScreenState createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  String? _selectedLocation;
  String? _selectedArea;
  List<String> _nearbyAreas = [];
  final _formKey = GlobalKey<FormState>();
  String? _postCode;
  String? _bankName;
  TextEditingController _bankNameC = TextEditingController();
  String? _ibanNumber;
  TextEditingController _ibanContoller = TextEditingController();
  String? _nationalId;
  TextEditingController _nationalIdC = TextEditingController();
  String? _crNumber;
  TextEditingController _crNumberC = TextEditingController();
  String? _freelancerCertificationNumber;
  TextEditingController _freelancerCertificationNumberC =
      TextEditingController();
  String? _marroofNumber;
  TextEditingController _marroofNumberC = TextEditingController();
  String? _instagramAccountLink;
  TextEditingController _instagramAccountLinkC = TextEditingController();

  Function? updateCity;
   String? _selectedCity;
  var selectedCity;

  String dropdownValue = '';

  @override
  Widget build(BuildContext context) {
    Provider.of<CityProvider>(context).fetchCity(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_arrow_left),
    color: Colors.white,
    onPressed: (){
            Navigator.pop(context);
    },
        ),
        backgroundColor: primary,
        title: Text('Complete your information',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        validator: (value){
                          if(value!.isEmpty){
                            return getTranslated(context, "This Field is Required!");
                          }
                        },
                        decoration: InputDecoration(
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          hintText: _selectedLocation == null
                              ? 'Enter location *'
                              : _selectedArea,
                          suffixIcon: IconButton(
                            icon: Icon(Icons.location_on),
                            onPressed: () async {
                              final LatLng? location = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MapScreen(),
                                ),
                              );
                              if (location != null) {
                                setState(() {
                                  _selectedLocation = '$location';
                                  _selectedArea = 'Fetching areas...';
                                  _nearbyAreas = [];
                                });
                                String area = await getAreaFromLocation(
                                    location.latitude, location.longitude);
                                List<String> nearbyAreas = await getNearbyAreas(
                                    location.latitude, location.longitude);
                                setState(() {
                                  _selectedArea =
                                      area.isNotEmpty ? area : 'No areas found';
                                  _nearbyAreas = nearbyAreas;
                                });
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16.0),
                FutureBuilder<bool>(
                    future:
                        Provider.of<CityProvider>(context).fetchCity(context),
                    builder: (context, snapshot) {
                      return Consumer<CityProvider>(
                          builder: (context, data, index) {
                        return DropdownButtonFormField<String>(
                          decoration: InputDecoration(
                            labelText: 'Select city *',
                            labelStyle: TextStyle(
                              color: Colors.grey,
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.grey),
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                          ),
                          validator: (value){
                            if(value!.isEmpty){
                              return getTranslated(context, "This Field is Required!");
                            }
                          },
                          //hint: Text("Select Category"),
                          value:
                              dropdownValue.isNotEmpty ? dropdownValue : null,
                          items: data.cityName.map((item) {
                            return DropdownMenuItem<String>(
                              value: item,
                              child: Text(item),
                            );
                          }).toList(),
                          onChanged: (newValue) {
                            setState(() {
                              dropdownValue = newValue.toString();
                              _selectedCity = dropdownValue;
                              print("selected dropdown value: $dropdownValue");
                            });
                          },
                        );
                      });
                    }),
                SizedBox(height: 16.0),
                TextFormField(

                  decoration: InputDecoration(
                    labelText: 'Post Code',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    _postCode = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _bankNameC,
                  decoration: InputDecoration(
                    labelText: 'Bank Name *',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value){
                    if(value!.isEmpty){
                      return getTranslated(context, "This Field is Required!");
                    }
                  },
                  onSaved: (value) {
                    _bankName = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _ibanContoller,
                  decoration: InputDecoration(
                    labelText: 'IBAN Number *',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter IBAN number';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _ibanNumber = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _nationalIdC,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'National ID',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    _nationalId = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _crNumberC,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'CR Number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    _crNumber = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _freelancerCertificationNumberC,
                  decoration: InputDecoration(
                    labelText: 'Freelancer Certification Number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    _freelancerCertificationNumber = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  controller: _marroofNumberC,
                  decoration: InputDecoration(
                    labelText: 'Marroof Number',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    _marroofNumber = value;
                  },
                ),
                SizedBox(height: 16.0),
                TextFormField(
                  keyboardType: TextInputType.url,
                  controller: _instagramAccountLinkC,
                  decoration: InputDecoration(
                    labelText: 'Instagram Account Link',
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  onSaved: (value) {
                    _instagramAccountLink = value;
                  },
                ),
                SizedBox(height: 16.0),
                Center(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              Color(0xffFC6A57)),
                        ),
                        onPressed: () {
                          sendUpdateInfo();
                        },
                        child: Text(
                          "Complete your information",
                          style: TextStyle(color: Colors.white),
                        )))
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> sendUpdateInfo() async {
    print('sendataa here ==> 1');
    var paramter = {
      'seller_id': context.read<SettingProvider>().CUR_USERID,
      'location': _selectedArea.toString(),
      'bankname': _bankNameC.text.toString(),
      'city': _selectedCity.toString(),
      'ibn_number': _ibanContoller.text.toString(),
      'national_id': _nationalIdC.text.toString(),
      'cr_number': _crNumberC.text.toString(),
      'free_certi_number': _freelancerCertificationNumberC.text.toString(),
      'maroof_num': _marroofNumberC.text.toString(),
      'insta_link': _instagramAccountLinkC.text.toString()
    };
    print('Data being sent: $paramter');
    final reposnse = await http.post(updateUserApi, body: paramter);
    if (reposnse.statusCode == 200) {
      if( _selectedArea == null || _bankNameC.text.isEmpty || _selectedCity!
          .isEmpty || _ibanContoller.text.isEmpty){
        setSnackbar("Please fill all the required fields", context);
      }
      else{
        print('sendataa here ==> 3' +
            _selectedLocation.toString() +
            _selectedCity.toString());
        print('data added succesfully');

        Navigator.pushReplacement(context,MaterialPageRoute(builder: (context) => Home()));
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Data added succesfully")));
      }

    } else {
      print('sendataa here ==> 4');
      print('data not added succesfully');
    }
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  LatLng? _selectedLocation;
  String? _selectedArea;

  @override
  void initState() {
    super.initState();
    _getLocationPermission();
  }

  Future<void> _getLocationPermission() async {
    print("called==>");
    final status = await Permission.locationWhenInUse.request();
    if (status.isGranted) {
      _getCurrentLocation();
    }
  }

  Future<void> _getCurrentLocation() async {
    final location = await mylocation.Location().getLocation();
    _moveToLocation(LatLng(location.latitude!, location.longitude!));
  }

  Future<void> _moveToLocation(LatLng location) async {
    _mapController?.animateCamera(CameraUpdate.newLatLng(location));
    _selectedLocation = location;

    setState(() {
      _selectedArea = 'Fetching areas...';
    });

    String area =
    await getAreaFromLocation(location.latitude, location.longitude);

    setState(() {
      _selectedArea = area.isNotEmpty ? area : 'No areas found';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Select Location'),
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(37.42796133580664, -122.085749655962),
          zoom: 14.0,
        ),
        onMapCreated: (controller) {
          setState(() {
            _mapController = controller;
          });
        },
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        onTap: (location) {
          _moveToLocation(location);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (_selectedLocation != null) {
            Navigator.pop(context, _selectedLocation);
          } else {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Error'),
                  content: Text('Please select a location'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          }
        },
        child: Icon(Icons.check),
      ),
      bottomSheet: _selectedArea != null
          ? Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Areas near selected location: $_selectedArea',
            style: TextStyle(fontSize: 16.0),
          ),
        ),
      )
          : null,
    );
  }
}

// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _selectedLocation;
//   String? _selectedArea;
//
//
//   @override
//   void initState() {
//     super.initState();
//     _getLocationPermission();
//   }
//
//   Future<void> _getLocationPermission() async {
//     final status = await Permission.locationWhenInUse.request();
//     if (status.isGranted) {
//       _getCurrentLocation();
//     }
//   }
//   Future<void> _getCurrentLocation() async {
//     final location = await mylocation.Location().getLocation();
//     _moveToLocation(LatLng(location.latitude!, location.longitude!));
//   }
//
//   Future<void> _moveToLocation(LatLng location) async {
//     _mapController?.animateCamera(CameraUpdate.newLatLng(location));
//     _selectedLocation = location;
//
//     setState(() {
//       _selectedArea = 'Fetching areas...';
//     });
//
//     String area =
//         await getAreaFromLocation(location.latitude, location.longitude);
//
//     setState(() {
//       _selectedArea = area.isNotEmpty ? area : 'No areas found';
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Location'),
//       ),
//       body: GoogleMap(
//         initialCameraPosition: CameraPosition(
//           target: LatLng(37.42796133580664, -122.085749655962),
//           zoom: 14.0,
//         ),
//         onMapCreated: (controller) {
//           setState(() {
//             _mapController = controller;
//           });
//         },
//         onTap: (location) {
//           _moveToLocation(location);
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () async {
//           if (_selectedLocation != null) {
//             Navigator.pop(context, _selectedLocation);
//           } else {
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text('Error'),
//                   content: Text('Please select a location'),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('OK'),
//                     ),
//                   ],
//                 );
//               },
//             );
//           }
//         },
//         child: Icon(Icons.check),
//       ),
//       bottomSheet: _selectedArea != null
//           ? Container(
//               color: Colors.white,
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Text(
//                   'Areas near selected location: $_selectedArea',
//                   style: TextStyle(fontSize: 16.0),
//                 ),
//               ),
//             )
//           : null,
//     );
//   }
// }
