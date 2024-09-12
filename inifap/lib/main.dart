import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inifap/backend/fetch_data.dart';
import 'package:inifap/screens/app_with_drawer.dart';
import 'package:inifap/screens/eleccion_favorita_a_ver.dart';
import 'package:workmanager/workmanager.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Workmanager().initialize(callbackDispatcher, isInDebugMode: false);

  // Schedule four tasks with different intervals
  await Workmanager().registerPeriodicTask("unique1",
    "task1",
    initialDelay: Duration(minutes: 1),
    frequency: Duration(minutes: 30),
  );
   await Workmanager().registerPeriodicTask("unique2",
    "task2",
    initialDelay: Duration(minutes: 1),
    frequency: Duration(hours: 6),
  );
  await Workmanager().registerPeriodicTask("unique3",
    "task3",
    initialDelay: Duration(minutes: 1),
    frequency: Duration(hours: 12),
  );

 
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
  runApp(const MyApp());
}
@pragma('vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    // Implement task logic based on taskName
    if (taskName == "task1") {
      //30 minutes
      final fetchedData = await fetchDataResumenReal();
      // Show notification with fetched data
      if (fetchedData != "Error") {
        await showNotificationResumenReal(fetchedData);
      } else {
        await showNotificationError();
      }
      // Task 4 logic
    }
    if (taskName == "task2") {
      //6 hours
      // Fetch data
      final fetchedData = await fetchDataResumenDiaAnterior();
      // Show notification with fetched data
      if (fetchedData != "Error") {
        await showNotificationDiaAnterior(fetchedData);
      } else {
        await showNotificationError();
      }
    }
    if (taskName == "task3") {
      //12 hours
      final fetchedData = await fetchDataAvanceMensual();
      if (fetchedData != "Error") {
        await showNotificationAvanceMensual(fetchedData);
      } else {
        await showNotificationError();
      }
    }
    return Future.value(true);
  });
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
