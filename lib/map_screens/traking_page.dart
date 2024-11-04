// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
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
//   Set<Marker> _markers = {};
//   Set<Polyline> _polylines = {};
//   List<LatLng> polylineCoordinates = []; // To hold polyline coordinates
//
//   static const LatLng sourceLocation = LatLng(37.33500926, -122.03272188);
//   static const LatLng destination = LatLng(37.33429383, -122.06600055);
//   static const String googleApiKey = 'YOUR_API_KEY'; // Replace with your actual API key
//
//   @override
//   void initState() {
//     super.initState();
//     _setMarkers();
//     getPolyPoints(); // Call to get polyline points
//   }
//
//   void _setMarkers() {
//     _markers.add(Marker(
//       markerId: MarkerId('source'),
//       position: sourceLocation,
//       infoWindow: InfoWindow(title: 'Source Location'),
//     ));
//     _markers.add(Marker(
//       markerId: MarkerId('destination'),
//       position: destination,
//       infoWindow: InfoWindow(title: 'Destination'),
//     ));
//   }
//
//   void getPolyPoints() async {
//     PolylinePoints polylinePoints = PolylinePoints();
//
//     // Get route between coordinates with required parameters
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       googleApiKey: googleApiKey,
//        PointLatLng(sourceLocation.latitude, sourceLocation.longitude), // Changed to 'origin'
//       PointLatLng(destination.latitude, destination.longitude), // Changed to 'destination'
//        TravelMode.driving, // Specify the travel mode (driving, walking, etc.)
//     );
//
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//       _addPolyLine(); // Call to add the polyline to the map
//     } else {
//       print('No points found for the route.');
//     }
//   }
//
//   void _addPolyLine() {
//     _polylines.add(Polyline(
//       polylineId: PolylineId('route'),
//       color: Colors.blue,
//       points: polylineCoordinates,
//       width: 5,
//     ));
//     setState(() {}); // Update the state to redraw the map with the new polyline
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           "Track Order",
//           style: TextStyle(color: Colors.black, fontSize: 16),
//         ),
//       ),
//       body: GoogleMap(
//         mapType: MapType.normal,
//         initialCameraPosition: CameraPosition(
//           target: sourceLocation,
//           zoom: 14,
//         ),
//         markers: _markers,
//         polylines: _polylines,
//         onMapCreated: (GoogleMapController controller) {
//           _controller.complete(controller);
//         },
//       ),
//     );
//   }
// }


