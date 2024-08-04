import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:pherico/utils/snackbar.dart';

class GeoService {
  Future<bool> _handleLocationPermission(context) async {
    bool serviceEnabled;
    LocationPermission locationPermission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showErrorSnackbar(
          'Location services are disabled. Please enable the services',
          context);
      return false;
    }
    locationPermission = await Geolocator.checkPermission();
    if (locationPermission == LocationPermission.denied) {
      locationPermission = await Geolocator.requestPermission();
      if (locationPermission == LocationPermission.denied) {
        showErrorSnackbar('Location permission denied', context);
        return false;
      }
    }

    if (locationPermission == LocationPermission.deniedForever) {
      showErrorSnackbar('Location permissions are permanently denied', context);
      return false;
    }
    return true;
  }

  Future<Position?> getUserCurrentPostion(BuildContext context) async {
    Position? currentPosition;
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) {
      currentPosition = null;
      return currentPosition;
    }

    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) {
      currentPosition = position;
    }).catchError((e) {
      currentPosition = null;
    });
    return currentPosition;
  }

  Future<Placemark?> getCurrentAddress(BuildContext context) async {
    Placemark? placemark;
    Position? position = await getUserCurrentPostion(context);
    if (position != null) {
      await placemarkFromCoordinates(position.latitude, position.longitude)
          .then((List<Placemark> placemarks) {
        placemark = placemarks[0];
      }).catchError((e) {
        placemark = null;
      });
    } else {
      placemark = null;
    }
    return placemark;
  }
}
