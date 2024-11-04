// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// // import 'package:osm_flutter/osm_flutter.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late MapController mapController;
//
//   @override
//   void initState() {
//     super.initState();
//     mapController = MapController(
//       initPosition: GeoPoint(latitude: 17.7749, longitude: 73.4194), // Set your desired coordinates
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('OSMFlutter Map'),
//       ),
//       body: OSMFlutter(
//         controller: mapController,
//         // initMapWithUserPosition: false, // Disable this line
//         osmOption: OSMOption(
//           userTrackingOption: UserTrackingOption(
//             enableTracking: true,
//             unFollowUser: false,
//           ),
//           zoomOption: ZoomOption(
//             initZoom: 8,
//             minZoomLevel: 3,
//             maxZoomLevel: 19,
//             stepZoom: 1.0,
//           ),
//           userLocationMarker: UserLocationMaker(
//             personMarker: MarkerIcon(
//               icon: Icon(
//                 Icons.location_history_rounded,
//                 color: Colors.red,
//                 size: 48,
//               ),
//             ),
//             directionArrowMarker: MarkerIcon(
//               icon: Icon(
//                 Icons.double_arrow,
//                 size: 48,
//               ),
//             ),
//           ),
//           roadConfiguration: RoadOption(
//             roadColor: Colors.yellowAccent,
//           ),
//           // markerOption: MarkerOption(
//           //   defaultMarker: MarkerIcon(
//           //     icon: Icon(
//           //       Icons.person_pin_circle,
//           //       color: Colors.blue,
//           //       size: 56,
//           //     ),
//           //   ),
//           // ),
//         ),
//       ),
//     );
//   }
// }



// import 'package:flutter/material.dart';
// import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
// import 'package:geocoding/geocoding.dart';
// import 'package:geolocator/geolocator.dart';
//
// class MapScreen extends StatefulWidget {
//   @override
//   _MapScreenState createState() => _MapScreenState();
// }
//
// class _MapScreenState extends State<MapScreen> {
//   late MapController mapController;
//   TextEditingController searchController = TextEditingController();
//   TextEditingController currentLocationController = TextEditingController();
//   Position? currentPosition;
//
//   // List to keep track of markers
//   List<GeoPoint> markers = [];
//
//   @override
//   void initState() {
//     super.initState();
//     mapController = MapController(
//       initPosition: GeoPoint(latitude: 17.7749, longitude: 73.4194),
//     );
//     _getCurrentLocation();
//   }
//
//   Future<void> _getCurrentLocation() async {
//     try {
//       currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
//       mapController.moveTo(
//         GeoPoint(latitude: currentPosition!.latitude, longitude: currentPosition!.longitude),
//       );
//       await _updateCurrentLocationAddress();
//       _addCurrentLocationMarker();
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Unable to get current location')),
//       );
//     }
//   }
//
//   Future<void> _updateCurrentLocationAddress() async {
//     if (currentPosition != null) {
//       List<Placemark> placemarks = await placemarkFromCoordinates(
//         currentPosition!.latitude,
//         currentPosition!.longitude,
//       );
//       if (placemarks.isNotEmpty) {
//         currentLocationController.text = '${placemarks.first.name}, ${placemarks.first.locality}';
//       }
//     }
//   }
//
//   Future<void> searchLocation(String location) async {
//     try {
//       List<Location> locations = await locationFromAddress(location);
//       if (locations.isNotEmpty) {
//         final lat = locations.first.latitude;
//         final lng = locations.first.longitude;
//
//         // Clear previous markers
//         await _clearMarkers();
//
//         // Move the map to the searched location with a specific zoom level
//         mapController.moveTo(GeoPoint(latitude: lat, longitude: lng ));
//
//         // Add marker for searched location
//         await mapController.addMarker(
//           GeoPoint(latitude: lat, longitude: lng),
//           markerIcon: MarkerIcon(
//             icon: Icon(Icons.location_on, color: Colors.green, size: 48),
//           ),
//         );
//
//         // Add to markers list
//         markers.add(GeoPoint(latitude: lat, longitude: lng));
//
//         double distanceInMeters = Geolocator.distanceBetween(
//           currentPosition!.latitude,
//           currentPosition!.longitude,
//           lat,
//           lng,
//         );
//
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text('Distance: ${distanceInMeters.toStringAsFixed(2)} meters')),
//         );
//
//         await mapController.drawRoute(
//           GeoPoint(latitude: currentPosition!.latitude, longitude: currentPosition!.longitude),
//           GeoPoint(latitude: lat, longitude: lng),
//         );
//       }
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Location not found')),
//       );
//     }
//   }
//
//   Future<void> _addCurrentLocationMarker() async {
//     if (currentPosition != null) {
//       await mapController.addMarker(
//         GeoPoint(latitude: currentPosition!.latitude, longitude: currentPosition!.longitude),
//         markerIcon: MarkerIcon(
//           icon: Icon(Icons.my_location, color: Colors.red, size: 48),
//         ),
//       );
//     }
//   }
//
//   // Method to clear markers
//   Future<void> _clearMarkers() async {
//     // Clear the list of markers
//     markers.clear();
//     // Optionally, you can remove markers from the map if required
//     // await mapController.clearMarkers(); // Ensure this method exists in your version
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           OSMFlutter(
//             controller: mapController,
//             osmOption: OSMOption(
//               userTrackingOption: UserTrackingOption(
//                 enableTracking: true,
//                 unFollowUser: true,
//               ),
//               zoomOption: ZoomOption(
//                 initZoom: 8,
//                 minZoomLevel: 3,
//                 maxZoomLevel: 19,
//                 stepZoom: 1.0,
//               ),
//               userLocationMarker: UserLocationMaker(
//                 personMarker: MarkerIcon(
//                   icon: Icon(
//                     Icons.location_history_rounded,
//                     color: Colors.red,
//                     size: 48,
//                   ),
//                 ),
//                 directionArrowMarker: MarkerIcon(
//                   icon: Icon(
//                     Icons.arrow_forward,
//                     color: Colors.blue,
//                     size: 20,
//                   ),
//                 ),
//               ),
//               roadConfiguration: RoadOption(
//                 roadColor: Colors.yellowAccent,
//               ),
//             ),
//           ),
//           Positioned(
//             top: 40,
//             left: 8,
//             right: 8,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: TextField(
//                 controller: searchController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide.none,
//                   ),
//                   labelText: 'Search Location',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.search),
//                     onPressed: () {
//                       searchLocation(searchController.text);
//                     },
//                   ),
//                 ),
//               ),
//             ),
//           ),
//           Positioned(
//             top: 100,
//             left: 8,
//             right: 8,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 8.0),
//               child: TextField(
//                 controller: currentLocationController,
//                 decoration: InputDecoration(
//                   filled: true,
//                   fillColor: Colors.white,
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.circular(8.0),
//                     borderSide: BorderSide.none,
//                   ),
//                   labelText: 'Current Location',
//                   enabled: false, // Make it read-only
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
// // Extension for MapController to draw a route
// extension MapControllerExtensions on MapController {
//   Future<void> drawRoute(GeoPoint start, GeoPoint end) async {
//     await clearRoute();
//     List<GeoPoint> routePoints = [start, end];
//     // await drawRoad(routePoints ); // Uncomment as needed
//     await drawRoad(start, end);
//   }
//
//   Future<void> clearRoute() async {
//     await removeRoad(roadKey: ''); // Assuming removeRoad exists to clear drawn routes
//   }
// }



import 'package:flutter/material.dart';
import 'package:flutter_osm_plugin/flutter_osm_plugin.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late MapController mapController;
  TextEditingController searchController = TextEditingController();
  TextEditingController currentLocationController = TextEditingController();
  Position? currentPosition;

  // List to keep track of markers and user path
  List<GeoPoint> markers = [];
  List<GeoPoint> userPath = [];

  @override
  void initState() {
    super.initState();
    mapController = MapController(
      initPosition: GeoPoint(latitude: 17.7749, longitude: 73.4194),
    );
    _getCurrentLocation();
    _startLocationTracking();
  }

  Future<void> _getCurrentLocation() async {
    try {
      currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      mapController.moveTo(
        GeoPoint(latitude: currentPosition!.latitude, longitude: currentPosition!.longitude),
      );
      await _updateCurrentLocationAddress();
      _addCurrentLocationMarker();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unable to get current location')),
      );
    }
  }

  Future<void> _updateCurrentLocationAddress() async {
    if (currentPosition != null) {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        currentPosition!.latitude,
        currentPosition!.longitude,
      );
      if (placemarks.isNotEmpty) {
        currentLocationController.text = '${placemarks.first.name}, ${placemarks.first.locality}';
      }
    }
  }

  Future<void> searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final lat = locations.first.latitude;
        final lng = locations.first.longitude;

        // Clear previous markers
        await _clearMarkers();

        // Move the map to the searched location with a specific zoom level
        mapController.moveTo(GeoPoint(latitude: lat, longitude: lng));

        // Add marker for searched location
        await mapController.addMarker(
          GeoPoint(latitude: lat, longitude: lng),
          markerIcon: MarkerIcon(
            icon: Icon(Icons.location_on, color: Colors.green, size: 48),
          ),
        );

        // Add to markers list
        markers.add(GeoPoint(latitude: lat, longitude: lng));

        double distanceInMeters = Geolocator.distanceBetween(
          currentPosition!.latitude,
          currentPosition!.longitude,
          lat,
          lng,
        );

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Distance: ${distanceInMeters.toStringAsFixed(2)} meters')),
        );

        await mapController.drawRoute(
          GeoPoint(latitude: currentPosition!.latitude, longitude: currentPosition!.longitude),
          GeoPoint(latitude: lat, longitude: lng),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Location not found')),
      );
    }
  }

  Future<void> _addCurrentLocationMarker() async {
    if (currentPosition != null) {
      await mapController.addMarker(
        GeoPoint(latitude: currentPosition!.latitude, longitude: currentPosition!.longitude),
        markerIcon: MarkerIcon(
          icon: Icon(Icons.my_location, color: Colors.red, size: 48),
        ),
      );
    }
  }

  // Start tracking the user's location
  void _startLocationTracking() {
    Geolocator.getPositionStream().listen((Position position) {
      setState(() {
        currentPosition = position;
        userPath.add(GeoPoint(latitude: position.latitude, longitude: position.longitude));
      });
      _updateCurrentLocationAddress();
      _addCurrentLocationMarker();
      _drawUserPath();
    });
  }

  // Draw the path taken by the user
  Future<void> _drawUserPath() async {
    if (userPath.length > 1) {
      // await mapController.drawRoad(userPath);
    }
  }

  // Method to clear markers
  Future<void> _clearMarkers() async {
    markers.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          OSMFlutter(
            controller: mapController,
            osmOption: OSMOption(
              userTrackingOption: UserTrackingOption(
                enableTracking: true,
                unFollowUser: true,
              ),
              zoomOption: ZoomOption(
                initZoom: 8,
                minZoomLevel: 3,
                maxZoomLevel: 19,
                stepZoom: 1.0,
              ),
              userLocationMarker: UserLocationMaker(
                personMarker: MarkerIcon(
                  icon: Icon(
                    Icons.location_history_rounded,
                    color: Colors.red,
                    size: 48,
                  ),
                ),
                directionArrowMarker: MarkerIcon(
                  icon: Icon(
                    Icons.arrow_forward,
                    color: Colors.blue,
                    size: 20,
                  ),
                ),
              ),
              roadConfiguration: RoadOption(
                roadColor: Colors.yellowAccent,
              ),
            ),
          ),
          Positioned(
            top: 40,
            left: 8,
            right: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Search Location',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      searchLocation(searchController.text);
                    },
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 100,
            left: 8,
            right: 8,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: TextField(
                controller: currentLocationController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide.none,
                  ),
                  labelText: 'Current Location',
                  enabled: false, // Make it read-only
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Extension for MapController to draw a route
extension MapControllerExtensions on MapController {
  Future<void> drawRoute(GeoPoint start, GeoPoint end) async {
    await clearRoute();
    await drawRoad(start, end);
  }

  Future<void> clearRoute() async {
    await removeRoad(roadKey: ''); // Assuming removeRoad exists to clear drawn routes
  }
}

