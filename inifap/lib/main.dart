import 'package:flutter/material.dart';
import 'package:inifap/screens/HomeScreen.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/screens/resumenReal.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() {
  runApp(MyApp());
}

void requestNotificationPermission() async {
  // Request notification permission
  final PermissionStatus status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    // Handle denied or restricted permission
    // You may want to show a message to the user
    print('Notification permission denied or restricted');
  }
}

void startPeriodicTask() {
  // Schedule a periodic task using Timer.periodic
  Timer.periodic(Duration(hours: 1), (Timer timer) async {
    // Fetch data
    final fetchedData = await fetchData();
    // Show notification with fetched data
    await showNotification(fetchedData);
  });
}

Future<String> fetchData() async {
  // Simulating an asynchronous API call to fetch data
  await Future.delayed(Duration(seconds: 5));
  return 'Fetched data'; // Replace this with your actual data fetching logic
}

Future<void> showNotification(String fetchedData) async {
  // Initialize the local notifications plugin with Android-specific initialization settings.
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Create an instance of InitializationSettings with the Android initialization settings.
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Show notification with fetched data
  await flutterLocalNotificationsPlugin.show(
    0, // Unique notification ID
    'Periodic Notification', // Notification title
    fetchedData, // Notification body using fetched data
    NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inifap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ListPage(),
    ResumenReal(),
    GraphScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkGreen,
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
            label: 'Estacion',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista Estaciones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Resumen tiempo real',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.open_with_rounded),
            label: 'Other',
          ),
        ],
      ),
    );
  }
}





class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Other'),
    );
  }
}
