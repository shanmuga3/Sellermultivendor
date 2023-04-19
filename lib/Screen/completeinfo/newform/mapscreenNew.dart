// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:sellermultivendor/Screen/completeinfo/newform/completeInformation.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   GoogleMapController? _mapController;
//   LatLng? _selectedLocation;
//   String? _selectedArea;
//   Set<Marker> _markers = Set<Marker>();
//
//   Future<void> _moveToLocation(LatLng location) async {
//     _mapController?.animateCamera(CameraUpdate.newLatLng(location));
//     _selectedLocation = location;
//
//     setState(() {
//       _selectedArea = 'Fetching areas...';
//       _markers.clear();
//       _markers.add(Marker(
//         markerId: MarkerId('selectedLocation'),
//         position: location,
//       ));
//     });
//
//     String area = await getAreaFromLocation(location.latitude, location.longitude);
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
//         markers: _markers,
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
//         color: Colors.white,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Text(
//             'Areas near selected location: $_selectedArea',
//             style: TextStyle(fontSize: 16.0),
//           ),
//         ),
//       )
//           : null,
//     );
//   }
// }
