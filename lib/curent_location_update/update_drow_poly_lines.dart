// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'dart:math' as math;
//
// class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({Key? key}) : super(key: key);
//
//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }
//
// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   final Completer<GoogleMapController> _controller = Completer();
//   Location location = Location();
//   LatLng? currentLocation; // User's current location
//   LatLng? destination; // Destination will be set by user input
//   final List<LatLng> polylinePoints = [];
//
//   TextEditingController latController = TextEditingController();
//   TextEditingController lngController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _startLocationUpdates();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     var locationData = await location.getLocation();
//     setState(() {
//       currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
//       polylinePoints.add(currentLocation!);
//     });
//   }
//
//   void _startLocationUpdates() {
//     location.onLocationChanged.listen((LocationData currentData) {
//       if (currentData.latitude != null && currentData.longitude != null) {
//         setState(() {
//           currentLocation = LatLng(currentData.latitude!, currentData.longitude!);
//           // Add the new location to the polyline points
//           polylinePoints.add(currentLocation!);
//         });
//       }
//     });
//   }
//
//   double _calculateDistance(LatLng point1, LatLng point2) {
//     const double radius = 6371000; // Radius of the Earth in meters
//     double lat1 = point1.latitude * math.pi / 180;
//     double lat2 = point2.latitude * math.pi / 180;
//     double deltaLat = (point2.latitude - point1.latitude) * math.pi / 180;
//     double deltaLon = (point2.longitude - point1.longitude) * math.pi / 180;
//
//     double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
//         math.cos(lat1) * math.cos(lat2) *
//             math.sin(deltaLon / 2) * math.sin(deltaLon / 2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//
//     return radius * c; // Distance in meters
//   }
//
//   void _updateDestination() {
//     double? lat = double.tryParse(latController.text);
//     double? lng = double.tryParse(lngController.text);
//     if (lat != null && lng != null) {
//       setState(() {
//         destination = LatLng(lat, lng);
//         polylinePoints.clear();
//         polylinePoints.add(currentLocation!);
//         polylinePoints.add(destination!);
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (currentLocation == null) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     double distanceCurrentToDestination = destination != null
//         ? _calculateDistance(currentLocation!, destination!)
//         : 0.0;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//             initialCameraPosition: CameraPosition(
//               target: currentLocation!,
//               zoom: 12,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId('current'),
//                 position: currentLocation!,
//                 infoWindow: InfoWindow(title: 'Current Location'),
//               ),
//               if (destination != null) // Only show if destination is set
//                 Marker(
//                   markerId: MarkerId('destination'),
//                   position: destination!,
//                   infoWindow: InfoWindow(title: 'Destination'),
//                 ),
//             },
//             polylines: {
//               Polyline(
//                 polylineId: PolylineId('route'),
//                 points: polylinePoints,
//                 color: Colors.blue,
//                 width: 5,
//               ),
//             },
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Card(
//               elevation: 8,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: latController,
//                       decoration: const InputDecoration(
//                         labelText: 'Latitude',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     SizedBox(height: 8),
//                     TextField(
//                       controller: lngController,
//                       decoration: const InputDecoration(
//                         labelText: 'Longitude',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     SizedBox(height: 8),
//                     ElevatedButton(
//                       onPressed: _updateDestination,
//                       child: Text('Set Destination'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             child: Text(
//               destination != null
//                   ? 'Distance to Destination: ${distanceCurrentToDestination.toStringAsFixed(2)} meters'
//                   : 'Set a Destination to Calculate Distance',
//               style: TextStyle(fontSize: 16, backgroundColor: Colors.white),
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
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location/location.dart';
// import 'dart:math' as math;
//
// class OrderTrackingPage extends StatefulWidget {
//   const OrderTrackingPage({Key? key}) : super(key: key);
//
//   @override
//   State<OrderTrackingPage> createState() => OrderTrackingPageState();
// }
//
// class OrderTrackingPageState extends State<OrderTrackingPage> {
//   final Completer<GoogleMapController> _controller = Completer();
//   Location location = Location();
//   LatLng? currentLocation; // User's current location
//   LatLng? destination; // Destination will be set by user input
//   final List<LatLng> polylinePoints = [];
//   bool isMoving = false; // Track whether the user is moving
//
//   TextEditingController latController = TextEditingController();
//   TextEditingController lngController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//     _startLocationUpdates();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     var locationData = await location.getLocation();
//     setState(() {
//       currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
//     });
//   }
//
//   void _startLocationUpdates() {
//     location.onLocationChanged.listen((LocationData currentData) {
//       if (currentData.latitude != null && currentData.longitude != null) {
//         setState(() {
//           LatLng newLocation = LatLng(currentData.latitude!, currentData.longitude!);
//           if (currentLocation != null && newLocation != currentLocation) {
//             isMoving = true; // User is moving
//             polylinePoints.add(newLocation);
//           }
//           currentLocation = newLocation;
//         });
//       }
//     });
//   }
//
//   double _calculateDistance(LatLng point1, LatLng point2) {
//     const double radius = 6371000; // Radius of the Earth in meters
//     double lat1 = point1.latitude * math.pi / 180;
//     double lat2 = point2.latitude * math.pi / 180;
//     double deltaLat = (point2.latitude - point1.latitude) * math.pi / 180;
//     double deltaLon = (point2.longitude - point1.longitude) * math.pi / 180;
//
//     double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
//         math.cos(lat1) * math.cos(lat2) *
//             math.sin(deltaLon / 2) * math.sin(deltaLon / 2);
//     double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
//
//     return radius * c; // Distance in meters
//   }
//
//   void _updateDestination() {
//     double? lat = double.tryParse(latController.text);
//     double? lng = double.tryParse(lngController.text);
//     if (lat != null && lng != null) {
//       setState(() {
//         destination = LatLng(lat, lng);
//         // Clear previous polyline points but keep the current one
//         polylinePoints.clear();
//         polylinePoints.add(currentLocation!);
//         if (destination != null) {
//           polylinePoints.add(destination!);
//         }
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     if (currentLocation == null) {
//       return Center(child: CircularProgressIndicator());
//     }
//
//     double distanceCurrentToDestination = destination != null
//         ? _calculateDistance(currentLocation!, destination!)
//         : 0.0;
//
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             onMapCreated: (GoogleMapController controller) {
//               _controller.complete(controller);
//             },
//             initialCameraPosition: CameraPosition(
//               target: currentLocation!,
//               zoom: 12,
//             ),
//             markers: {
//               Marker(
//                 markerId: MarkerId('current'),
//                 position: currentLocation!,
//                 infoWindow: InfoWindow(title: 'Current Location'),
//               ),
//               if (destination != null) // Only show if destination is set
//                 Marker(
//                   markerId: MarkerId('destination'),
//                   position: destination!,
//                   infoWindow: InfoWindow(title: 'Destination'),
//                 ),
//             },
//             polylines: {
//               Polyline(
//                 polylineId: PolylineId('route'),
//                 points: polylinePoints,
//                 color: isMoving ? Colors.red : Colors.blue, // Change color based on movement
//                 width: 5,
//               ),
//             },
//           ),
//           Positioned(
//             top: 40,
//             left: 16,
//             right: 16,
//             child: Card(
//               elevation: 8,
//               child: Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Column(
//                   children: [
//                     TextField(
//                       controller: latController,
//                       decoration: const InputDecoration(
//                         labelText: 'Latitude',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     SizedBox(height: 8),
//                     TextField(
//                       controller: lngController,
//                       decoration: const InputDecoration(
//                         labelText: 'Longitude',
//                         border: OutlineInputBorder(),
//                       ),
//                       keyboardType: TextInputType.number,
//                     ),
//                     SizedBox(height: 8),
//                     ElevatedButton(
//                       onPressed: _updateDestination,
//                       child: Text('Set Destination'),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             bottom: 16,
//             left: 16,
//             child: Text(
//               destination != null
//                   ? 'Distance to Destination: ${distanceCurrentToDestination.toStringAsFixed(2)} meters'
//                   : 'Set a Destination to Calculate Distance',
//               style: TextStyle(fontSize: 16, backgroundColor: Colors.white),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'dart:math' as math;

class OrderTracking_page extends StatefulWidget {
  const OrderTracking_page({Key? key}) : super(key: key);

  @override
  State<OrderTracking_page> createState() => OrderTracking_pageState();
}

class OrderTracking_pageState extends State<OrderTracking_page> {
  final Completer<GoogleMapController> _controller = Completer();
  Location location = Location();
  LatLng? currentLocation; // User's current location
  LatLng? destination; // Destination will be set by user input
  final List<LatLng> polylinePoints = [];
  bool isMoving = false; // Track whether the user is moving

  TextEditingController latController = TextEditingController();
  TextEditingController lngController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startLocationUpdates();
  }

  Future<void> _getCurrentLocation() async {
    var locationData = await location.getLocation();
    setState(() {
      currentLocation = LatLng(locationData.latitude!, locationData.longitude!);
    });
  }

  void _startLocationUpdates() {
    location.onLocationChanged.listen((LocationData currentData) {
      if (currentData.latitude != null && currentData.longitude != null) {
        setState(() {
          LatLng newLocation = LatLng(currentData.latitude!, currentData.longitude!);
          if (currentLocation != null && newLocation != currentLocation) {
            isMoving = true; // User is moving
            polylinePoints.add(newLocation); // Add new point to polyline
          }
          currentLocation = newLocation;
        });
      }
    });
  }

  double _calculateDistance(LatLng point1, LatLng point2) {
    const double radius = 6371000; // Radius of the Earth in meters
    double lat1 = point1.latitude * math.pi / 180;
    double lat2 = point2.latitude * math.pi / 180;
    double deltaLat = (point2.latitude - point1.latitude) * math.pi / 180;
    double deltaLon = (point2.longitude - point1.longitude) * math.pi / 180;

    double a = math.sin(deltaLat / 2) * math.sin(deltaLat / 2) +
        math.cos(lat1) * math.cos(lat2) *
            math.sin(deltaLon / 2) * math.sin(deltaLon / 2);
    double c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return radius * c; // Distance in meters
  }

  void _updateDestination() {
    double? lat = double.tryParse(latController.text);
    double? lng = double.tryParse(lngController.text);
    if (lat != null && lng != null) {
      setState(() {
        destination = LatLng(lat, lng);
        // Clear previous polyline points but keep the current one
        polylinePoints.clear();
        polylinePoints.add(currentLocation!);
        if (destination != null) {
          polylinePoints.add(destination!);
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (currentLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    double distanceCurrentToDestination = destination != null
        ? _calculateDistance(currentLocation!, destination!)
        : 0.0;

    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            initialCameraPosition: CameraPosition(
              target: currentLocation!,
              zoom: 12,
            ),
            markers: {
              Marker(
                markerId: MarkerId('current'),
                position: currentLocation!,
                infoWindow: InfoWindow(title: 'Current Location'),
              ),
              if (destination != null) // Only show if destination is set
                Marker(
                  markerId: MarkerId('destination'),
                  position: destination!,
                  infoWindow: InfoWindow(title: 'Destination'),
                ),
            },
            polylines: {
              Polyline(
                polylineId: PolylineId('route'),
                points: polylinePoints,
                color: Colors.blue, // Set color for the polyline
                width: 5,
              ),
            },
          ),
          Positioned(
            top: 40,
            left: 16,
            right: 16,
            child: Card(
              elevation: 8,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    TextField(
                      controller: latController,
                      decoration: const InputDecoration(
                        labelText: 'Latitude',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: lngController,
                      decoration: const InputDecoration(
                        labelText: 'Longitude',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _updateDestination,
                      child: Text('Set Destination'),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 16,
            left: 16,
            child: Text(
              destination != null
                  ? 'Distance to Destination: ${distanceCurrentToDestination.toStringAsFixed(2)} meters'
                  : 'Set a Destination to Calculate Distance',
              style: TextStyle(fontSize: 16, backgroundColor: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
