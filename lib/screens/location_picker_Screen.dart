// import 'package:flutter/material.dart';
// import 'package:yandex_mapkit/yandex_mapkit.dart';

// class LocationPickerScreen extends StatefulWidget {
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }

// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   late YandexMapController mapController;
//   Point? selectedLocation;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Select Location'),
//         actions: [
//           IconButton(
//             icon: Icon(Icons.check),
//             onPressed: () {
//               if (selectedLocation != null) {
//                 Navigator.pop(context, selectedLocation);
//               } else {
//                 showDialog(
//                   context: context,
//                   builder: (context) => AlertDialog(
//                     title: Text('Location not selected'),
//                     content: Text('Please select a location on the map.'),
//                     actions: <Widget>[
//                       TextButton(
//                         child: Text('OK'),
//                         onPressed: () {
//                           Navigator.of(context).pop();
//                         },
//                       ),
//                     ],
//                   ),
//                 );
//               }
//             },
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: TextField(
//               controller: _searchController,
//               decoration: InputDecoration(
//                 hintText: 'Search for a place',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     _searchPlace(_searchController.text);
//                   },
//                 ),
//               ),
//             ),
//           ),
//           Expanded(
//             child: YandexMap(
//               onMapCreated: (YandexMapController controller) {
//                 mapController = controller;
//               },
//               onMapTap: (Point point, Point screenPoint) {
//                 _selectLocation(point);
//               },
//               onMapLongTap: (Point point) {
//                 _selectLocation(point);
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   void _searchPlace(String query) {
//     // Implement search functionality here
//     // Example: Use Yandex Search API or custom logic to search for places
//     // and update the map accordingly.
//     // For simplicity, you can update the map center to the searched place.
//   }

//   void _selectLocation(Point point) {
//     setState(() {
//       selectedLocation = point;
//     });
//   }

//   // Future method to get location name by coordinates (reverse geocoding) if needed
//   Future<String> _getLocationName(Point point) async {
//     // Implement logic to fetch the location name based on coordinates
//     // For simplicity, you can return a placeholder or implement reverse geocoding.
//     return 'Selected Location'; // Placeholder
//   }
// }
