import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inifap/backend/fetchData.dart';
import 'package:inifap/screens/AppDetailsPage.dart';
import 'package:inifap/screens/AppWithDrawer.dart';
import 'package:inifap/screens/EleccionFavoritaAVer.dart';
import 'package:inifap/screens/Resumen_Real_or_Yesterday.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';
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
    if (status != PermissionStatus.granted) {
      // Handle denied or restricted permission
      // You may want to show a message to the user
      debugPrint('Notification permission denied or restricted');
    }

    // Ensure permissions are granted before accessing location
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Handle the case where the user denies permission
        debugPrint("Location permission denied or restricted");
      }
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

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    const EleccionFavoritaAVer(),
    const ListPage(),
    const ResumenRealOrYesterday(),
    const AppDetailsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: lightGreen,
        unselectedItemColor: Colors.grey.shade500,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: darkGreen,
            icon: const Icon(Icons.sunny_snowing),
            label: 'Estaciones',
          ),
          BottomNavigationBarItem(
            backgroundColor: darkGreen,
            icon: const Icon(Icons.list),
            label: 'Lista Estaciones',
          ),
          BottomNavigationBarItem(
            backgroundColor: darkGreen,
            icon: const Icon(Icons.access_time),
            label: 'Tiempo real',
          ),
          BottomNavigationBarItem(
            backgroundColor: darkGreen,
            icon: const Icon(Icons.open_with_rounded),
            label: 'Other',
          ),
        ],
      ),
    );
  }
}
