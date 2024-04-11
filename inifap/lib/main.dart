import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/screens/HomeScreen.dart';
import 'package:inifap/screens/Resumen_Real_or_Yesterday.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';
import 'package:flutter_dotenv/flutter_dotenv.dart';
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
List<String> prefixesShort = [
  'N',
  'NNE',
  'NE',
  'ENE',
  'E',
  'ESE',
  'SE',
  'SSE',
  'S',
  'SSO',
  'SO',
  'OSO',
  'O',
  'ONO',
  'NO',
  'NNO'
];

void main() async {
  await dotenv.load();
  requestNotificationPermission();
  startPeriodicTask();
  fetchDataResumenReal();
  fetchDataResumenDiaAnterior();
  fetchDataAvanceMensual();
  runApp(MyApp());
}

void requestNotificationPermission() async {
  // Request notification permission
  final PermissionStatus status = await Permission.notification.request();
  if (status != PermissionStatus.granted) {
    // Handle denied or restricted permission
    // You may want to show a message to the user
    debugPrint('Notification permission denied or restricted');
  }
}

void startPeriodicTask() {
  // Schedule a periodic task using Timer.periodic
  Timer.periodic(const Duration(minutes: 30), (Timer timer) async {
    // Fetch data
    final fetchedData = await fetchDataResumenReal();
    // Show notification with fetched data
    if (fetchedData != "Error") {
      await showNotification(fetchedData);
    } else {
      await showNotificationError();
    }
  });

  Timer.periodic(const Duration(hours: 6), (Timer timer) async {
    // Fetch data
    final fetchedData = await fetchDataResumenDiaAnterior();
    // Show notification with fetched data
    if (fetchedData != "Error") {
      await showNotification(fetchedData);
    } else {
      await showNotificationError();
    }
  });
  Timer.periodic(const Duration(hours: 12), (Timer timer) async {
    final fetchedData = await fetchDataAvanceMensual();
    if (fetchedData != "Error") {
      await showNotification(fetchedData);
    } else {
      await showNotificationError();
    }
  });
}

Future<String> fetchDataResumenDiaAnterior() async {
  try {
    // Simulating an asynchronous API call to fetch data
    String api_url = dotenv.env['DIA_ANTERIOR'] ?? "DEFAULT";
    final response = await http.get(Uri.parse(api_url));

    List<String> dataList = [];
    List<Map<String, dynamic>> data = [];
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      final document = parse(response.body);
      String? parsedString = parse(document.body?.text).documentElement?.text;
      var textparts = parsedString?.split(',');
      textparts?.forEach((part) {
        dataList.add(part.trim());
      });

      while (dataList.length >= 10) {
        String municipio = dataList[0];
        String direccion = dataList[9];
        for (String prefix in prefixesShort) {
          if (municipio.startsWith(prefix)) {
            if (prefix == "O") {
              if (municipio != "Ojocaliente")
                municipio = municipio.substring(prefix.length).trim();
            } else {
              municipio = municipio.substring(prefix.length).trim();
            }
          }
          if (direccion.startsWith(prefix)) {
            direccion = prefix;
          }
        }
        if (direccion == "S") {
          for (String prefix in prefixes) {
            if (dataList[9].startsWith(prefix)) {
              direccion = prefix;
              break;
            } else {
              direccion = "Sur";
            }
          }
        }

        if (direccion == "O") {
          for (String prefix in prefixes) {
            if (dataList[9].startsWith(prefix)) {
              direccion = prefix;
              break;
            } else {
              direccion = "Oeste";
            }
          }
        }
        if (direccion == "E") {
          for (String prefix in prefixes) {
            if (dataList[9].startsWith(prefix)) {
              direccion = prefix;
              break;
            } else {
              direccion = "Este";
            }
          }
        }

        if (direccion == "N") {
          for (String prefix in prefixes) {
            if (dataList[9].startsWith(prefix)) {
              direccion = prefix;
              break;
            } else {
              direccion = "Norte";
            }
          }
        }

        if (dataList[1] == "Col. González Ortega") {
          dataList[1] == "Col. Gonzalez Ortega";
        }
        var dataMap = {
          "Municipio": municipio,
          "Estacion": dataList[1],
          "Fecha": dataList[2],
          "Max": dataList[3],
          "Min": dataList[4],
          "Med": dataList[5],
          "Precipitacion": dataList[6],
          "VelMed": dataList[7],
          "VelMax": dataList[8],
          "Direccion": direccion,
        };
        data.add(dataMap);
        dataList.removeRange(0, 9);
      }

      String dataJson = jsonEncode(data);
      await secureStorage.write(key: 'dia_anterior', value: dataJson);

      return 'Fetched data'; // Replace this with your actual data fetching logic
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataResumenReal() async {
  try {
    // Simulating an asynchronous API call to fetch data
    String api_url = dotenv.env['RESUMEN_TIEMPO_REAL'] ?? "DEFAULT";
    final response = await http.get(Uri.parse(api_url));

    List<String> dataList = [];
    List<Map<String, dynamic>> data = [];
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      final document = parse(response.body);
      String? parsedString = parse(document.body?.text).documentElement?.text;
      var textparts = parsedString?.split(',');
      textparts?.forEach((part) {
        dataList.add(part.trim());
      });

      while (dataList.length >= 11) {
        String municipio = dataList[0];
        String direccion = dataList[10];
        for (String prefix in prefixes) {
          if (municipio.startsWith(prefix)) {
            municipio = municipio.substring(prefix.length).trim();
          }
          if (direccion.startsWith(prefix)) {
            direccion = prefix;
          }
        }
        var dataMap = {
          "Municipio": municipio,
          "Estacion": dataList[1],
          "Hora": dataList[2],
          "Fecha": dataList[3],
          "Max": dataList[4],
          "Min": dataList[5],
          "Med": dataList[6],
          "Precipitacion": dataList[7],
          "VelMed": dataList[8],
          "VelMax": dataList[9],
          "Direccion": direccion,
        };
        data.add(dataMap);
        dataList.removeRange(0, 10);
      }

      String dataJson = jsonEncode(data);
      await secureStorage.write(key: 'Resumen_tiempo_real', value: dataJson);

      return 'Fetched data'; // Replace this with your actual data fetching logic
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataAvanceMensual() async {
  try {
    // Simulating an asynchronous API call to fetch data
    String api_url = dotenv.env['AVANCE_MENSUAL'] ?? "DEFAULT";
    final response = await http.get(Uri.parse(api_url));

    List<String> dataList = [];
    List<Map<String, dynamic>> data = [];
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      final document = parse(response.body);
      String? parsedString = parse(document.body?.text).documentElement?.text;
      var textparts = parsedString?.split(',');
      textparts?.forEach((part) {
        dataList.add(part.trim());
      });

      while (dataList.length >= 12) {
        var dataMap = {
          "Municipio": dataList[0].replaceAll(RegExp("[0-9.]"), ""),
          "Estacion": dataList[1],
          "Temp_max": dataList[2],
          "Temp_min": dataList[3],
          "Temp_med": dataList[4],
          "Precipitacion": dataList[5],
          "Humedad_max": dataList[6],
          "Humedad_min": dataList[7],
          "Humedad_med": dataList[8],
          "Radiacion": dataList[9] + "," + dataList[10],
          "Viento_max": dataList[11],
          "Viento_med": dataList[12],
          "Evapotranspiracion": dataList[13].replaceAll(RegExp("[a-zA-ZáéíóúñÑÁÉÍÓÚ:\s]"), ""),
        };
        data.add(dataMap);
        dataList.removeRange(0, 13);
      }

      String dataJson = jsonEncode(data);
      await secureStorage.write(key: 'avance_mensual', value: dataJson);

      print(data);

      return 'Fetched data'; // Replace this with your actual data fetching logic
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
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
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

Future<void> showNotificationError() async {
  // Initialize the local notifications plugin with Android-specific initialization settings.
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Create an instance of InitializationSettings with the Android initialization settings.
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Show notification with fetched data
  await flutterLocalNotificationsPlugin.show(
    1, // Unique notification ID
    'Actualización de información fallida', // Notification title
    'No se pudo actualizar la información debido a que el API está caído.', // Notification body using fetched data
    const NotificationDetails(
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
    ResumenRealOrYesterday(),
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
            label: 'Estaciones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista Estaciones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Tiempo real',
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
