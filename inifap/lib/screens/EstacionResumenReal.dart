import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:inifap/widgets/WeatherCardViento.dart';
import 'package:inifap/widgets/weatherCard.dart';

class EstacionResumenReal extends StatefulWidget {
  const EstacionResumenReal({Key? key}) : super(key: key);

  @override
  State<EstacionResumenReal> createState() => _EstacionResumenRealState();
}

class _EstacionResumenRealState extends State<EstacionResumenReal> {
  String favorites = "";
  List<Map<String, dynamic>> detailedInfo = [];
  List<Map<String, dynamic>> resumenEstaciones = [];
  List<Map<String, dynamic>> resumenGraficaTemperatura = [];
  List<Map<String, dynamic>> resumenGraficaPrecipitacion = [];
  List<Map<String, dynamic>> resumenGraficaHumedad = [];
  List<Map<String, dynamic>> resumenGraficaRadiacion = [];
  List<Map<String, dynamic>> resumenGraficaViento = [];
  double? lastTemperature;
  double? lastPrecipitation;
  double? lastHumedad;
  double? lastRadiacion;
  double? lastViento;

  @override
  void initState() {
    super.initState();
    loadResumenEstaciones().then((_) {
      loadFavorites();
    });
  }

  void loadDataTransformation() {
    List<dynamic> datosTemperatura = resumenGraficaTemperatura[0]['Datos'];
    List<dynamic> datosPrecipitacion = resumenGraficaPrecipitacion[0]['Datos'];
    List<dynamic> datosHumedad = resumenGraficaHumedad[0]['Datos'];
    List<dynamic> datosRadiacion = resumenGraficaRadiacion[0]['Datos'];
    List<dynamic> datosViento = resumenGraficaViento[0]['Datos'];
    print("datos viento $datosViento");
    if (datosTemperatura.isNotEmpty) {
      var lastItem = datosTemperatura.last;
      lastTemperature = double.parse(lastItem['Temp']);
      print('Last temperature: $lastTemperature'); // or do something with it
    }
    if (datosPrecipitacion.isNotEmpty) {
      var lastItem = datosPrecipitacion.last;
      lastPrecipitation = double.parse(lastItem['Pre']);
      print('Last Pre: $lastPrecipitation'); // or do something with it
    }
    if (datosHumedad.isNotEmpty) {
      var lastItem = datosHumedad.last;
      lastHumedad = double.parse(lastItem['Humedad']);
      print("Last humedad: $lastHumedad");
    }
    if (datosRadiacion.isNotEmpty) {
      var lastItem = datosRadiacion.last;
      lastRadiacion = double.parse(lastItem['Rad']);
      print("Last radiacion: $lastRadiacion");
    }
    if (datosViento.isNotEmpty) {
      var lastItem = datosViento.last;
      lastViento = double.parse(lastItem['VelViento']);
      print("Last viento: $lastViento");
    }
  }

  Future<void> loadGrafica() async {
    const secureStorage = FlutterSecureStorage();
    String? storedDataJsonTemperatura =
        await secureStorage.read(key: 'grafica_temperatura');
    String? storedDataJsonPrecipitacion =
        await secureStorage.read(key: 'grafica_precipitacion');
    String? storedDataJsonHumedad =
        await secureStorage.read(key: 'grafica_humedad');
    String? storedDataJsonRadiacion =
        await secureStorage.read(key: 'grafica_radiacion');
    String? storedDataJsonViento =
        await secureStorage.read(key: 'grafica_viento');

    setState(() {
      if (storedDataJsonTemperatura != null) {
        resumenGraficaTemperatura = List<Map<String, dynamic>>.from(
            json.decode(storedDataJsonTemperatura));
      } else {
        resumenGraficaTemperatura = [];
      }

      if (storedDataJsonPrecipitacion != null) {
        resumenGraficaPrecipitacion = List<Map<String, dynamic>>.from(
            json.decode(storedDataJsonPrecipitacion));
      } else {
        resumenGraficaPrecipitacion = [];
      }
      if (storedDataJsonHumedad != null) {
        resumenGraficaHumedad =
            List<Map<String, dynamic>>.from(json.decode(storedDataJsonHumedad));
      } else {
        resumenGraficaHumedad = [];
      }
      if (storedDataJsonRadiacion != null) {
        resumenGraficaRadiacion = List<Map<String, dynamic>>.from(
            json.decode(storedDataJsonRadiacion));
      } else {
        resumenGraficaRadiacion = [];
      }
      if (storedDataJsonViento != null) {
        resumenGraficaViento =
            List<Map<String, dynamic>>.from(json.decode(storedDataJsonViento));
      } else {
        resumenGraficaRadiacion = [];
      }

      // Call loadDataTransformation() once after both conditions are evaluated
      loadDataTransformation();
    });
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getString('estacionActual') ?? "";
    });

    // Load detailed information for each favorite
    List<Map<String, dynamic>> infoList = [];
    if (favorites.isNotEmpty) {
      print("fav $favorites");
      Map<String, dynamic> info =
          await getDataForEstacionAndMunicipio(favorites);
      print("info $info");
      infoList.add(info);
    }

    setState(() {
      detailedInfo = infoList;
      loadGrafica();
    });
  }

  Future<Map<String, dynamic>> getDataForEstacionAndMunicipio(String id) async {
    print("resumen estaciones $resumenEstaciones");
    // Ensure the data is loaded before accessing it
    await loadResumenEstaciones();
    return resumenEstaciones.firstWhere(
      (data) => data['Id'].toString() == id,
      orElse: () => {},
    );
  }

  Future<void> loadResumenEstaciones() async {
    // Data from your provided list
    const secureStorage = FlutterSecureStorage();
    String? storedDataJson =
        await secureStorage.read(key: 'Resumen_tiempo_real');
    print("stored json $storedDataJson");
    if (storedDataJson != null) {
      setState(() {
        resumenEstaciones =
            List<Map<String, dynamic>>.from(json.decode(storedDataJson));
      });
    } else {
      setState(() {
        resumenEstaciones = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (detailedInfo.isEmpty)
                Column(
                  children: [Text('No hay favoritos seleccionados')],
                ),
              if (detailedInfo.isNotEmpty)
                Column(
                  children: detailedInfo.map((info) {
                    return Column(
                      children: [
                        SizedBox(height: 40),
                        Image.asset(
                          'lib/assets/logo.png', // Replace with your image path
                          height: 40, // Adjust the height as needed
                        ),
                        const SizedBox(height: 15),
                        Text(
                          info['Est'] ?? 'N/A',
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          info['Est'] ?? 'N/A',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Fecha de instalacion:\n ${info['Instalacion'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        WeatherCard(
                          icon: Icons.thermostat,
                          label: 'Temperatura',
                          value: lastTemperature.toString() ?? 'N/A',
                          max:
                              'Max ${info['TempMax']}°C a las ${info['HoraMaxTemp']} hr',
                          min:
                              'Min ${info['TempMin']}°C a las ${info['HoraMinTemp']} hr',
                          avg: 'Med ${info['TempMed']}°C',
                        ),
                        WeatherCard(
                          icon: Icons.water_drop,
                          label: 'Humedad\nrelativa',
                          value: lastHumedad.toString() ?? 'N/A',
                          max:
                              'Max ${info['HumedadMax']}% a las ${info['HoraHumedadMax']} hr',
                          min:
                              'Min ${info['HumedadMin']}% a las ${info['HoraHumedadMin']} hr',
                          avg: 'Med ${info['HumedadMed']}%',
                        ),
                        WeatherCard(
                          icon: Icons.cloudy_snowing,
                          label: 'Precipitación',
                          value: lastPrecipitation.toString() ?? 'N/A',
                          total: 'Total acumulada\n${info['Pre']} mm',
                        ),
                        WeatherCard(
                          icon: Icons.sunny,
                          label: 'Radiación',
                          value: lastRadiacion.toString() ?? 'N/A',
                          total: 'Total registrada\n ${info['radiacionTotal']} W/m²',
                        ),
                        WeatherCardViento(
                          icon: Icons.air,
                          label: 'Velocidad y\ndirección del\n viento',
                          value: lastViento.toString() ?? 'N/A',
                          max:
                              'Max ${info['VelMax']} proveniente del ${info['DirVelMax']} a las ${info['VelMaxHora']} hr',
                          min: 'Min ${info['VelMin']} Km/hr proveniente del ${info['DirVelMin']} a las ${info['VelMinHora']} hr',
                          avg: 'Med ${info['VelMed']} Km/hr proveniente del N/A',
                        ),
                        const SizedBox(height: 20),
                      ],
                    );
                  }).toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
