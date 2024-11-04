// import 'dart:async';
//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
//
// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//       Completer<GoogleMapController>();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(17.4204, 78.4565),
//     zoom: 11,
//   );
//
//   static const CameraPosition _kLake = CameraPosition(
//       bearing: 192.8334901395799,
//       target: LatLng(17.4204, 78.4565),
//       tilt: 59.440717697143555,
//       zoom: 19.151926040649414);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.hybrid,
//             initialCameraPosition: _kGooglePlex,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//           ),
//           Positioned(
//             bottom: 36.0,
//             left: 16.0,
//             child: FloatingActionButton.extended(
//               onPressed: _goToTheLake,
//               label: const Text('To the lake!'),
//               icon: const Icon(Icons.directions_boat),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _goToTheLake() async {
//     final GoogleMapController controller = await _controller.future;
//     await controller.animateCamera(CameraUpdate.newCameraPosition(_kLake));
//   }
// }

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
//
// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   final TextEditingController _locationController = TextEditingController();
//   Location _location = Location();
//   LatLng? _currentPosition;
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(17.4204, 78.4565),
//     zoom: 11,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     LocationData locationData;
//
//     try {
//       locationData = await _location.getLocation();
//       setState(() {
//         _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
//         // Update the TextField with the current location
//         _locationController.text = 'Lat: ${locationData.latitude}, Lng: ${locationData.longitude}';
//       });
//     } on Exception catch (e) {
//       print("Could not get the current location: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.hybrid,
//             initialCameraPosition: _kGooglePlex,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//               if (_currentPosition != null) {
//                 controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//               }
//             },
//             markers: _currentPosition != null
//                 ? {
//               Marker(
//                 markerId: MarkerId('currentLocation'),
//                 position: _currentPosition!,
//               ),
//             }
//                 : {},
//           ),
//           Positioned(
//             top: 50.0,
//             left: 16.0,
//             right: 16.0,
//             child: TextField(
//               controller: _locationController,
//               decoration: InputDecoration(
//                 labelText: 'Current Location',
//                 fillColor: Colors.white,
//                 border: OutlineInputBorder(),
//               ),
//               readOnly: true, // Make it read-only since we are only displaying the location
//             ),
//           ),
//
//
//           Positioned(
//             bottom: 36.0,
//             left: 16.0,
//             child: FloatingActionButton.extended(
//               onPressed: _goToTheCurrentLocation,
//               label: const Text('Current Location'),
//               icon: const Icon(Icons.my_location),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Future<void> _goToTheCurrentLocation() async {
//     final GoogleMapController controller = await _controller.future;
//     if (_currentPosition != null) {
//       await controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//     }
//   }
// }

// impo//////

// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
//
// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller =
//   Completer<GoogleMapController>();
//   LatLng? _currentPosition;
//   LatLng? _searchedPosition; // Store the searched position
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {}; // Store the polylines
//   final TextEditingController _currentLocationController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(17.4204, 78.4565),
//     zoom: 11,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _markers.add(Marker(
//           markerId: MarkerId('currentLocation'),
//           position: _currentPosition!,
//           infoWindow: InfoWindow(title: 'Your Location'),
//         ));
//       });
//
//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//     } else {
//       print("Location permission denied");
//     }
//   }
//
//   Future<void> _searchLocation(String location) async {
//     try {
//       List<Location> locations = await locationFromAddress(location);
//       if (locations.isNotEmpty) {
//         _searchedPosition = LatLng(locations.first.latitude, locations.first.longitude);
//         setState(() {
//           _markers.add(Marker(
//             markerId: MarkerId('searchedLocation'),
//             position: _searchedPosition!,
//             infoWindow: InfoWindow(title: location),
//           ));
//           // Add polyline between current location and searched location
//           if (_currentPosition != null) {
//             _polylines.add(Polyline(
//               polylineId: PolylineId('route'),
//               points: [_currentPosition!, _searchedPosition!],
//               color: Colors.blue,
//               width: 5,
//             ));
//           }
//         });
//
//         final GoogleMapController controller = await _controller.future;
//         controller.animateCamera(CameraUpdate.newLatLng(_searchedPosition!));
//       }
//     } catch (e) {
//       print(e); // Handle the error as needed
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.hybrid,
//             initialCameraPosition: _kGooglePlex,
//             markers: _markers,
//             polylines: _polylines, // Add polylines to the map
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//               if (_currentPosition != null) {
//                 controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//               }
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 // First search box for current location
//                 TextField(
//                   controller: _currentLocationController,
//                   decoration: InputDecoration(
//                     hintText: 'Get Current Location',
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.my_location),
//                       onPressed: () {
//                         _getCurrentLocation();
//                       },
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 SizedBox(height: 16),
//                 // Second search box for user-entered location
//                 TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search Location',
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.search),
//                       onPressed: () {
//                         _searchLocation(_searchController.text);
//                       },
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

//
// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// class MapSample extends StatefulWidget {
//   const MapSample({super.key});
//
//   @override
//   State<MapSample> createState() => MapSampleState();
// }
//
// class MapSampleState extends State<MapSample> {
//   final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
//   LatLng? _currentPosition;
//   LatLng? _searchedPosition;
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   final TextEditingController _currentLocationController = TextEditingController();
//   final TextEditingController _searchController = TextEditingController();
//   double? _distance; // Variable to hold the distance
//
//   static const CameraPosition _kGooglePlex = CameraPosition(
//     target: LatLng(17.4204, 78.4565),
//     zoom: 11,
//   );
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//     }
//
//     if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
//       Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       setState(() {
//         _currentPosition = LatLng(position.latitude, position.longitude);
//         _markers.add(Marker(
//           markerId: MarkerId('currentLocation'),
//           position: _currentPosition!,
//           infoWindow: InfoWindow(title: 'Your Location'),
//         ));
//
//         // Update the text field with the current location
//         _updateCurrentLocationTextField(position.latitude, position.longitude);
//       });
//
//       final GoogleMapController controller = await _controller.future;
//       controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//     } else {
//       print("Location permission denied");
//     }
//   }
//
//   Future<void> _updateCurrentLocationTextField(double latitude, double longitude) async {
//     List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
//     if (placemarks.isNotEmpty) {
//       Placemark placemark = placemarks.first;
//       String address = '${placemark.name}, ${placemark.locality}, ${placemark.administrativeArea}, ${placemark.country}';
//       _currentLocationController.text = '$address\nLat: $latitude\nLng: $longitude'; // Update with full address and coordinates
//     }
//   }
//
//   Future<void> _searchLocation(String location) async {
//     try {
//       List<Location> locations = await locationFromAddress(location);
//       if (locations.isNotEmpty) {
//         _searchedPosition = LatLng(locations.first.latitude, locations.first.longitude);
//         setState(() {
//           _markers.add(Marker(
//             markerId: MarkerId('searchedLocation'),
//             position: _searchedPosition!,
//             infoWindow: InfoWindow(title: location),
//           ));
//         });
//
//         // Calculate and set distance
//         if (_currentPosition != null) {
//           _distance = Geolocator.distanceBetween(
//             _currentPosition!.latitude,
//             _currentPosition!.longitude,
//             _searchedPosition!.latitude,
//             _searchedPosition!.longitude,
//           );
//
//           // Convert distance from meters to kilometers
//           _distance = _distance! / 1000; // Distance in kilometers
//         }
//
//         // Fetch and draw the route
//         await _drawRoute(_currentPosition!, _searchedPosition!);
//
//         final GoogleMapController controller = await _controller.future;
//         controller.animateCamera(CameraUpdate.newLatLng(_searchedPosition!));
//       }
//     } catch (e) {
//       print(e); // Handle the error as needed
//     }
//   }
//
//   Future<void> _drawRoute(LatLng start, LatLng end) async {
//     // Replace 'YOUR_API_KEY' with your actual Google Directions API key
//     final String apiKey = 'YOUR_API_KEY';
//     final response = await http.get(Uri.parse(
//         'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey'));
//
//     if (response.statusCode == 200) {
//       final data = json.decode(response.body);
//       if (data['routes'].isNotEmpty) {
//         List<PointLatLng> points = _convertToLatLng(data['routes'][0]['polyline']['points']);
//         _polylines.add(Polyline(
//           polylineId: PolylineId('route'),
//           points: points.map((point) => LatLng(point.latitude, point.longitude)).toList(),
//           color: Colors.blue,
//           width: 5,
//         ));
//         setState(() {}); // Update the state to redraw the map with polylines
//       }
//     } else {
//       print('Failed to load route');
//     }
//   }
//
//   List<PointLatLng> _convertToLatLng(String encoded) {
//     List<PointLatLng> result = [];
//     int lat = 0;
//     int lng = 0;
//
//     for (int i = 0; i < encoded.length;) {
//       int b;
//       int shift = 0;
//       int resultLat = 0;
//       do {
//         b = encoded.codeUnitAt(i++) - 63;
//         resultLat |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlat = ((resultLat & 1) == 1 ? ~(resultLat >> 1) : (resultLat >> 1));
//       lat += dlat;
//
//       shift = 0;
//       resultLat = 0;
//       do {
//         b = encoded.codeUnitAt(i++) - 63;
//         resultLat |= (b & 0x1f) << shift;
//         shift += 5;
//       } while (b >= 0x20);
//       int dlng = ((resultLat & 1) == 1 ? ~(resultLat >> 1) : (resultLat >> 1));
//       lng += dlng;
//
//       result.add(PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
//     }
//     return result;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             mapType: MapType.hybrid,
//             initialCameraPosition: _kGooglePlex,
//             markers: _markers,
//             polylines: _polylines,
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//               if (_currentPosition != null) {
//                 controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
//               }
//             },
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               children: [
//                 TextField(
//                   controller: _currentLocationController,
//                   decoration: InputDecoration(
//                     hintText: 'Get Current Location',
//                     fillColor: Colors.white,
//                     filled: true, // Ensure the fill color is applied
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.my_location),
//                       onPressed: () {
//                         _getCurrentLocation();
//                       },
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                   maxLines: 3, // Allow multiple lines for address and coordinates
//                 ),
//                 SizedBox(height: 16),
//                 TextField(
//                   controller: _searchController,
//                   decoration: InputDecoration(
//                     hintText: 'Search Location',
//                     fillColor: Colors.white,
//                     filled: true, // Ensure the fill color is applied
//                     suffixIcon: IconButton(
//                       icon: Icon(Icons.search),
//                       onPressed: () {
//                         _searchLocation(_searchController.text);
//                       },
//                     ),
//                     border: OutlineInputBorder(),
//                   ),
//                 ),
//                 if (_distance != null) // Check if distance is available
//                   Padding(
//                     padding: const EdgeInsets.only(top: 16.0),
//                     child: Text(
//                       'Distance: ${_distance!.toStringAsFixed(2)} km', // Display distance
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MapSample extends StatefulWidget {
  const MapSample({super.key});

  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
  final Completer<GoogleMapController> _controller =
      Completer<GoogleMapController>();
  LatLng? _currentPosition;
  LatLng? _searchedPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final TextEditingController _currentLocationController =
      TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  double? _distance;
  Timer? _locationTimer;
  PolylinePoints polylinePoints = PolylinePoints();
  final List<LatLng> polylinePointsList =
      []; // Final list to hold polyline coordinates
  static const String googleApiKey =
      'YOUR_API_KEY'; // Replace with your actual API key

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.4204, 78.4565),
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTracking();
  }

  void _startTracking() {
    _locationTimer = Timer.periodic(Duration(seconds: 5), (Timer timer) {
      _getCurrentLocation();
    });
  }

  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _getAddressFromLatLng(_currentPosition!);
        _markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentPosition!,
          infoWindow: InfoWindow(title: 'Your Location'),
        ));
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));

      if (_searchedPosition != null) {
        await _drawRoute(_currentPosition!, _searchedPosition!);
      }
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks =
        await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String address =
          "${place.name}, ${place.street}, ${place.locality}, ${place.country}";
      setState(() {
        _currentLocationController.text =
            "$address\n(${latLng.latitude}, ${latLng.longitude})";
      });
    }
  }

  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        _searchedPosition =
            LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId('searchedLocation'),
            position: _searchedPosition!,
            infoWindow: InfoWindow(title: location),
          ));
        });

        if (_currentPosition != null) {
          _distance = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            _searchedPosition!.latitude,
            _searchedPosition!.longitude,
          );
          _distance = _distance! / 1000; // Distance in kilometers
        }

        await _drawRoute(_currentPosition!, _searchedPosition!);
        await _getAddressFromLatLng(_searchedPosition!);

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(_searchedPosition!));
      }
    } catch (e) {
      print(e);
    }
  }

  Future<void> _drawRoute(LatLng start, LatLng end) async {
    final String apiKey = googleApiKey; // Use the defined API key
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        List<PointLatLng> points =
            _convertToLatLng(data['routes'][0]['polyline']['points']);
        polylinePointsList.clear(); // Clear existing polyline points
        polylinePointsList.addAll(
            points.map((point) => LatLng(point.latitude, point.longitude)));
        _polylines.clear(); // Clear existing polylines
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: polylinePointsList,
          color: Colors.red, // Set color for the polyline to red
          width: 5,
        ));
        setState(() {});
      }
    } else {
      print('Failed to load route');
    }
  }

  List<PointLatLng> _convertToLatLng(String encoded) {
    List<PointLatLng> result = [];
    List<int> index = [];
    int lat = 0;
    int lng = 0;

    for (int i = 0; i < encoded.length;) {
      int b;
      int shift = 0;
      int resultLat = 0;
      do {
        b = encoded.codeUnitAt(i++) - 63;
        resultLat |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlat = ((resultLat & 1) == 1 ? ~(resultLat >> 1) : (resultLat >> 1));
      lat += dlat;

      shift = 0;
      resultLat = 0;
      do {
        b = encoded.codeUnitAt(i++) - 63;
        resultLat |= (b & 0x1f) << shift;
        shift += 5;
      } while (b >= 0x20);
      int dlng = ((resultLat & 1) == 1 ? ~(resultLat >> 1) : (resultLat >> 1));
      lng += dlng;

      result.add(PointLatLng((lat / 1E5).toDouble(), (lng / 1E5).toDouble()));
    }
    return result;
  }

  @override
  void dispose() {
    _locationTimer?.cancel(); // Cancel the timer when disposing
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            mapType: MapType.hybrid,
            initialCameraPosition: _kGooglePlex,
            markers: _markers,
            polylines: _polylines,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              if (_currentPosition != null) {
                controller
                    .animateCamera(CameraUpdate.newLatLng(_currentPosition!));
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _currentLocationController,
                  decoration: InputDecoration(
                    hintText: 'Current Location',
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.my_location),
                      onPressed: () {
                        _getCurrentLocation();
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true, // Make it read-only
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search Location',
                    fillColor: Colors.white,
                    filled: true,
                    suffixIcon: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {
                        _searchLocation(_searchController.text);
                      },
                    ),
                    border: OutlineInputBorder(),
                  ),
                ),
                if (_distance != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Text(
                      'Distance: ${_distance!.toStringAsFixed(2)} km',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
