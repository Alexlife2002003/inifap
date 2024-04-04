import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/screens/HomeScreen.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/screens/resumenReal.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart' ;
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

        List<String> prefixes = [
      'Norte',
      'NNE',
      'NE',
      'ENE',
      'Este',
      'ESE',
      'SE',
      'SSE',
      'Sur',
      'SSO',
      'SO',
      'OSO',
      'Oeste',
      'ONO',
      'NO',
      'NNO'
    ];

void main() async {
  await dotenv.load();
  runApp(MyApp());
  requestNotificationPermission();
  // Start periodic background task to fetch data and show notifications
  startPeriodicTask();
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
  String api_url = dotenv.env['RESUMEN_TIEMPO_REAL'] ?? "DEFAULT";
  final response = await http.get(Uri.parse(api_url));
  List<String> dataList = [];
  List<Map<String, dynamic>> data = [];
  const secureStorage=FlutterSecureStorage();
  
  if (response.statusCode == 200) {
    final document = parse(response.body);
    String? parsedString = parse(document.body?.text).documentElement?.text;
    var textparts=parsedString?.split(',');
    textparts?.forEach((part){
      dataList.add(part.trim());
    });

    while(dataList.length !=1){
      String municipio=dataList[0];
      String direccion=dataList[10];
      for (String prefix in prefixes){
        if(municipio.startsWith(prefix)){
          municipio=municipio.substring(prefix.length).trim();
          
        }
        if(direccion.startsWith(prefix)){
          direccion=prefix;
        }
      }
      var dataMap={
        "Municipio": municipio,
        "Estacion": dataList[1],
        "Hora": dataList[2],
        "Fecha": dataList[3],
        "Max": dataList[4],
        "Min":dataList[5],
        "Med": dataList[6],
        "Precipitacion": dataList[7],
        "VelMed": dataList[8],
        "VelMax": dataList[9],
        "Direccion": direccion,
      };
      data.add(dataMap);
      dataList.removeRange(0,10);
     // print("------------------------------------------------");
     //print(dataList);

    }
    //print(data);
    String dataJson=jsonEncode(data);
    await secureStorage.write(key: 'Resumen_tiempo_real', value: dataJson);



  }
  
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
