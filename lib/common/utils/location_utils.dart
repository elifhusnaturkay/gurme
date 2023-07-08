import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:gurme/common/utils/show_toast.dart';
import 'package:url_launcher/url_launcher.dart';

class LocationUtils {
  static String calculateDistance(double startLatitude, double startLongitude,
      double endLatitude, double endLongitude) {
    int kilometerToMeter = 1000;

    double distance = Geolocator.distanceBetween(
        startLatitude, startLongitude, endLatitude, endLongitude);

    distance /= kilometerToMeter;
    final formattedDistance = distance.toStringAsFixed(1);
    return '$formattedDistance km';
  }

  static Future<void> showOnMap(BuildContext context, GeoPoint location) async {
    final googleMapUrl = Uri.parse(
        'https://www.google.com/maps/search/?api=1&query=${location.latitude},${location.longitude}');

    if (await canLaunchUrl(googleMapUrl)) {
      await launchUrl(googleMapUrl);
    } else {
      // ignore: use_build_context_synchronously
      showToast(context, 'Bir şeyler yanlış gitti');
    }
  }
}
