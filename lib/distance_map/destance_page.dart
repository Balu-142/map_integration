import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart'; // For geocoding

class DistanceCalculator extends StatefulWidget {
  const DistanceCalculator({super.key});

  @override
  State<DistanceCalculator> createState() => DistanceCalculatorState();
}

class DistanceCalculatorState extends State<DistanceCalculator> {
  final Completer<GoogleMapController> _controller =
  Completer<GoogleMapController>();
  LatLng? _currentPosition;
  Set<Marker> _markers = {};
  final TextEditingController _searchController = TextEditingController();
  double? _distance;

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(17.4204, 78.4565),
    zoom: 11,
  );

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _markers.add(Marker(
        markerId: MarkerId('currentLocation'),
        position: _currentPosition!,
        infoWindow: InfoWindow(title: 'Your Location'),
      ));
    });
  }

  Future<void> _searchLocation(String location) async {
    try {
      List<Location> locations = await locationFromAddress(location);
      if (locations.isNotEmpty) {
        final LatLng searchedPosition =
        LatLng(locations.first.latitude, locations.first.longitude);
        setState(() {
          _markers.add(Marker(
            markerId: MarkerId('searchedLocation'),
            position: searchedPosition,
            infoWindow: InfoWindow(title: location),
          ));

          // Calculate distance
          _calculateDistance(_currentPosition!, searchedPosition);
        });

        final GoogleMapController controller = await _controller.future;
        controller.animateCamera(CameraUpdate.newLatLng(searchedPosition));
      }
    } catch (e) {
      print(e); // Handle the error as needed
    }
  }

  void _calculateDistance(LatLng start, LatLng end) {
    double distanceInMeters = Geolocator.distanceBetween(
      start.latitude,
      start.longitude,
      end.latitude,
      end.longitude,
    );

    setState(() {
      _distance = distanceInMeters; // Store distance
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Map Sample'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50.0),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Location',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchLocation(_searchController.text);
                  },
                ),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _kGooglePlex,
              markers: _markers,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
                if (_currentPosition != null) {
                  controller.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
                }
              },
            ),
          ),
          if (_distance != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                "Distance: ${_distance!.toStringAsFixed(2)} meters",
                style: TextStyle(fontSize: 18),
              ),
            ),
        ],
      ),
    );
  }
}
