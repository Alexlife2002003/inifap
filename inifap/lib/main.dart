import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inifap/backend/fetch_data.dart';
import 'package:inifap/screens/app_with_drawer.dart';
import 'package:inifap/screens/eleccion_favorita_a_ver.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  void startPeriodicTask() {
    // Schedule a periodic task using Timer.periodic

    Timer(const Duration(seconds: 3), () async {
      await Future.wait([
        fetchDataResumenReal(),
        fetchDataResumenDiaAnterior(),
      ]);
      final fetchedData = await fetchDataAvanceMensual();
      if (fetchedData != "Error") {
      } else {
        await showNotificationError();
      }
    });
    Timer.periodic(const Duration(minutes: 1), (Timer timer) async {
      //30 minutes
      final fetchedData = await fetchDataResumenReal();
      // Show notification with fetched data
      if (fetchedData != "Error") {
        await showNotificationResumenReal(fetchedData);
      } else {
        await showNotificationError();
      }
    });

    Timer.periodic(const Duration(minutes: 6), (Timer timer) async {
      //6 hours
      //6 hours
      // Fetch data
      final fetchedData = await fetchDataResumenDiaAnterior();
      // Show notification with fetched data
      if (fetchedData != "Error") {
        await showNotificationDiaAnterior(fetchedData);
      } else {
        await showNotificationError();
      }
    });
    Timer.periodic(const Duration(minutes: 12), (Timer timer) async {
      //12 hours
      //12 hours
      final fetchedData = await fetchDataAvanceMensual();
      if (fetchedData != "Error") {
        await showNotificationAvanceMensual(fetchedData);
      } else {
        await showNotificationError();
      }
    });
  }

  void requestNotificationPermission() async {
    // Request notification permission
    final PermissionStatus status = await Permission.notification.request();
    if (status != PermissionStatus.granted) {}

    // Ensure permissions are granted before accessing location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  }

  await dotenv.load();
  requestNotificationPermission();
  fetchDataResumenReal();
  fetchDataResumenDiaAnterior();
  fetchDataAvanceMensual();
  startPeriodicTask();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Inifap',
      home: AppWithDrawer(content: EleccionFavoritaAVer()),
    );
  }
}
