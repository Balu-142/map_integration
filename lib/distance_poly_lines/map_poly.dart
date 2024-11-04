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
  final Completer<GoogleMapController> _controller = Completer<GoogleMapController>();
  LatLng? _currentPosition;
  LatLng? _searchedPosition;
  Set<Marker> _markers = {};
  Set<Polyline> _polylines = {};
  final TextEditingController _currentLocationController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  double? _distance; // Variable to hold the distance
  Timer? _locationTimer; // Timer for tracking location

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.4204, 78.4565),
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _startTracking(); // Start tracking current location
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

    if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
        _getAddressFromLatLng(_currentPosition!); // Update with address
        _markers.add(Marker(
          markerId: MarkerId('currentLocation'),
          position: _currentPosition!,
          infoWindow: InfoWindow(title: 'Your Location'),
        ));
      });

      final GoogleMapController controller = await _controller.future;
      controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));

      // If a searched position exists, redraw the route
      if (_searchedPosition != null) {
        await _drawRoute(_currentPosition!, _searchedPosition!);
      }
    } else {
      print("Location permission denied");
    }
  }

  Future<void> _getAddressFromLatLng(LatLng latLng) async {
    List<Placemark> placemarks = await placemarkFromCoordinates(latLng.latitude, latLng.longitude);
    if (placemarks.isNotEmpty) {
      Placemark place = placemarks.first;
      String address = "${place.name}, ${place.street}, ${place.locality}, ${place.country}"; // Full address
      setState(() {
        _currentLocationController.text = "$address\n(${latLng.latitude}, ${latLng.longitude})"; // Update with address and coordinates
      });
    }
  }

  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        _searchedPosition = LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId('searchedLocation'),
            position: _searchedPosition!,
            infoWindow: InfoWindow(title: location),
          ));
        });

        // Calculate and set distance
        if (_currentPosition != null) {
          _distance = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            _searchedPosition!.latitude,
            _searchedPosition!.longitude,
          );

          // Convert distance from meters to kilometers
          _distance = _distance! / 1000; // Distance in kilometers
        }

        // Fetch and draw the route
        await _drawRoute(_currentPosition!, _searchedPosition!);

        // Get address for searched position
        await _getAddressFromLatLng(_searchedPosition!);

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(_searchedPosition!));
      }
    } catch (e) {
      print(e); // Handle the error as needed
    }
  }

  Future<void> _drawRoute(LatLng start, LatLng end) async {
    // Replace 'YOUR_API_KEY' with your actual Google Directions API key
    final String apiKey = 'YOUR_API_KEY';
    final response = await http.get(Uri.parse(
        'https://maps.googleapis.com/maps/api/directions/json?origin=${start.latitude},${start.longitude}&destination=${end.latitude},${end.longitude}&key=$apiKey'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['routes'].isNotEmpty) {
        List<PointLatLng> points = _convertToLatLng(data['routes'][0]['polyline']['points']);
        _polylines.clear(); // Clear existing polylines
        _polylines.add(Polyline(
          polylineId: PolylineId('route'),
          points: points.map((point) => LatLng(point.latitude, point.longitude)).toList(),
          color: Colors.blue,
          width: 5,
        ));
        setState(() {}); // Update the state to redraw the map with polylines
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
                controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
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
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
