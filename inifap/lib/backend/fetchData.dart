import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:inifap/backend/validaciones.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

Future<String> fetchDataResumenDiaAnterior() async {
  bool internet = await conexionInternt();
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['DIA_ANTERIOR'] ?? "DEFAULT";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(key: 'dia_anterior', value: response.body);

      return 'Se han actualizado los datos'; // Replace this with your actual data fetching logic
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataResumenReal() async {
  bool internet = await conexionInternt();
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['RESUMEN_TIEMPO_REAL'] ?? "DEFAULT";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(
          key: 'Resumen_tiempo_real', value: response.body);
      return 'Se han actualizado los datos';
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataAvanceMensual() async {
  bool internet = await conexionInternt();
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['AVANCE_MENSUAL'] ?? "DEFAULT";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(key: 'avance_mensual', value: response.body);
      return 'Se han actualizado los datos'; // Replace this with your actual data fetching logic
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataGraficaTemperatura(
    String day, String month, String year, String idEst) async {
  bool internet = await conexionInternt();
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['GRAFICA_TEMPERATURA'] ?? "DEFAULT";
    apiUrl = "$apiUrl&day=$day&month=$month&year=$year&id_est_given=$idEst";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(
          key: 'grafica_temperatura', value: response.body);
      return 'Se han actualizado los datos'; // Replace this with your actual data fetching logic
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataGraficaPrecipitacion(
    String day, String month, String year, String idEst) async {
  bool internet = await conexionInternt();
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['GRAFICA_PRECIPITACION'] ?? "DEFAULT";
    apiUrl = "$apiUrl&day=$day&month=$month&year=$year&id_est_given=$idEst";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(
          key: 'grafica_precipitacion', value: response.body);
      return 'Se han actualizado los datos';
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataGraficaHumedad(
    String day, String month, String year,) async {
  bool internet = await conexionInternt();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String idEst = prefs.getString('estacionActual') ?? "";
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['GRAFICA_HUMEDAD'] ?? "DEFAULT";
    apiUrl = "$apiUrl&day=$day&month=$month&year=$year&id_est_given=$idEst";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(key: 'grafica_humedad', value: response.body);
      return 'Se han actualizado los datos';
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataGraficaRadiacion(
    String day, String month, String year, String idEst) async {
  bool internet = await conexionInternt();
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['GRAFICA_RADIACION'] ?? "DEFAULT";
    apiUrl = "$apiUrl&day=$day&month=$month&year=$year&id_est_given=$idEst";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(key: 'grafica_radiacion', value: response.body);
      return 'Se han actualizado los datos';
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataGraficaViento(
    String day, String month, String year, String idEst) async {
  bool internet = await conexionInternt();
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env['GRAFICA_VIENTO'] ?? "DEFAULT";
    apiUrl = "$apiUrl&day=$day&month=$month&year=$year&id_est_given=$idEst";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(key: 'grafica_viento', value: response.body);
      return 'Se han actualizado los datos';
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<String> fetchDataGrafica(
    String day, String month, String year, String storageKey, String dotenvname) async {
  bool internet = await conexionInternt();
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String idEst = prefs.getString('estacionActual') ?? "";
  if (internet == false) {
    return "Sin conexión. Sin datos actualizados.";
  }
  try {
    // Simulating an asynchronous API call to fetch data
    String apiUrl = dotenv.env[dotenvname] ?? "DEFAULT";
    apiUrl = "$apiUrl&day=$day&month=$month&year=$year&id_est_given=$idEst";
    final response = await http.get(Uri.parse(apiUrl));
    const secureStorage = FlutterSecureStorage();

    if (response.statusCode == 200) {
      await secureStorage.write(key: storageKey, value: response.body);
      return 'Se han actualizado los datos';
    } else {
      throw Exception('Failed to fetch data: ${response.statusCode}');
    }
  } catch (e) {
    return 'Error';
  }
}

Future<void> showNotificationAvanceMensual(String fetchedData) async {
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
    "Avance Mensual", // Notification title
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

Future<void> showNotificationResumenReal(String fetchedData) async {
  // Initialize the local notifications plugin with Android-specific initialization settings.
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Create an instance of InitializationSettings with the Android initialization settings.
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Show notification with fetched data
  await flutterLocalNotificationsPlugin.show(
    2, // Unique notification ID
    "Resumen en tiempo real", // Notification title
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

Future<void> showNotificationDiaAnterior(String fetchedData) async {
  // Initialize the local notifications plugin with Android-specific initialization settings.
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  // Create an instance of InitializationSettings with the Android initialization settings.
  const InitializationSettings initializationSettings =
      InitializationSettings(android: initializationSettingsAndroid);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Show notification with fetched data
  await flutterLocalNotificationsPlugin.show(
    3, // Unique notification ID
    "Resumen dia anterior", // Notification title
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
