import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart';
import 'package:inifap/backend/validaciones.dart';

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
    String api_url = dotenv.env['RESUMEN_TIEMPO_REAL'] ?? "DEFAULT";
    final response = await http.get(Uri.parse(api_url));

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
          "Evapotranspiracion":
              dataList[13].replaceAll(RegExp("[a-zA-ZáéíóúñÑÁÉÍÓÚ:\s]"), ""),
        };
        data.add(dataMap);
        dataList.removeRange(0, 13);
      }

      String dataJson = jsonEncode(data);
      await secureStorage.write(key: 'avance_mensual', value: dataJson);
      return 'Se han actualizado los datos'; // Replace this with your actual data fetching logic
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
