import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:location/location.dart' as l;
import 'package:location/location.dart';
import 'package:permission_handler/permission_handler.dart';

class location_track extends StatefulWidget {
  const location_track({Key? key}) : super(key: key);

  @override
  State<location_track> createState() => _location_trackState();
}

class _location_trackState extends State<location_track> {
  bool gpsEnabled = false;
  bool permissionGranted = false;
  l.Location location = l.Location();
  late StreamSubscription subscription;
  bool trackingEnabled = false;

  List<l.LocationData> locations = [];

  @override
  void initState() {
    super.initState();
    checkStatus();
  }

  @override
  void dispose() {
    stopTracking();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Location App'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            buildListTile(
              "GPS",
              gpsEnabled
                  ? const Text("Okey")
                  : ElevatedButton(
                  onPressed: () {
                    requestEnableGps();
                  },
                  child: const Text("Enable Gps")),
            ),
            buildListTile(
              "Permission",
              permissionGranted
                  ? const Text("Okey")
                  : ElevatedButton(
                  onPressed: () {
                    requestLocationPermission();
                  },
                  child: const Text("Request Permission")),
            ),
            buildListTile(
              "Location",
              trackingEnabled
                  ? ElevatedButton(
                  onPressed: () {
                    stopTracking();
                  },
                  child: const Text("Stop"))
                  : ElevatedButton(
                  onPressed: gpsEnabled && permissionGranted
                      ? () {
                    startTracking();
                  }
                      : null,
                  child: const Text("Start")),
            ),
            Expanded(
                child: ListView.builder(
                  itemCount: locations.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(
                          "${locations[index].latitude} ${locations[index].longitude}"),
                    );
                  },
                ))
          ],
        ),
      ),
    );
  }

  ListTile buildListTile(
      String title,
      Widget? trailing,
      ) {
    return ListTile(
      dense: true,
      title: Text(title),
      trailing: trailing,
    );
  }

  void requestEnableGps() async {
    if (gpsEnabled) {
      log("Already open");
    } else {
      bool isGpsActive = await location.requestService();
      if (!isGpsActive) {
        setState(() {
          gpsEnabled = false;
        });
        log("User did not turn on GPS");
      } else {
        log("gave permission to the user and opened it");
        setState(() {
          gpsEnabled = true;
        });

      }
    }
  }

  void requestLocationPermission() async {
    var permissionStatus = await Permission.locationWhenInUse.request();

    setState(() {
      if (permissionStatus.isGranted) {
        permissionGranted = true;
      } else if (permissionStatus.isDenied) {
        permissionGranted = false;
        // Optionally, show a dialog or snackbar to inform the user
      } else if (permissionStatus.isPermanentlyDenied) {
        permissionGranted = false;
        // Optionally, direct the user to the app settings
      } else {
        // Handle other states if necessary
        permissionGranted = false;
      }
    });
  }


  Future<bool> isPermissionGranted() async {
    return await Permission.locationWhenInUse.isGranted;
  }

  Future<bool> isGpsEnabled() async {
    return await Permission.location.serviceStatus.isEnabled;
  }

  checkStatus() async {
    bool _permissionGranted = await isPermissionGranted();
    bool _gpsEnabled = await isGpsEnabled();
    setState(() {
      permissionGranted = _permissionGranted;
      gpsEnabled = _gpsEnabled;
    });
  }

  addLocation(l.LocationData data) {
    setState(() {
      locations.insert(0, data);
    });
  }

  clearLocation() {
    setState(() {
      locations.clear();
    });
  }

  void startTracking() async {
    if (!(await isGpsEnabled())) {
      return;
    }
    if (!(await isPermissionGranted())) {
      return;
    }
    subscription = location.onLocationChanged.listen((event) {
      addLocation(event);
    });
    setState(() {
      trackingEnabled = true;
    });
  }

  void stopTracking() {
    subscription.cancel();
    setState(() {
      trackingEnabled = false;
    });
    clearLocation();
  }
}