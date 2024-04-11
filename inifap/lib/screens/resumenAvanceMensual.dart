import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/View/widgets.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:inifap/widgets/icons/RotatedIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diacritic/diacritic.dart';

class resumenAvanceMensual extends StatefulWidget {
  @override
  _resumenAvanceMensualState createState() => _resumenAvanceMensualState();
}

class _resumenAvanceMensualState extends State<resumenAvanceMensual> {
  List<String> favorites = [];
  List<Map<String, dynamic>> resumenEstaciones = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    loadResumenEstaciones(); // No need to await here
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> loadResumenEstaciones() async {
    // Data from your provided list
    const secureStorage = FlutterSecureStorage();
    String? storedDataJson = await secureStorage.read(key: 'avance_mensual');
    if (storedDataJson != null) {
      setState(() {
        resumenEstaciones =
            List<Map<String, dynamic>>.from(json.decode(storedDataJson));
        for (var obj in resumenEstaciones) {
          String estacion = obj['Estacion'];
        }
        //print(resumenEstaciones);
      });
    } else {
      setState(() {
        resumenEstaciones = [];
      });
    }
  }

  Map<String, dynamic> getDataForEstacionAndMunicipio(
      String estacion, String municipio) {
    return resumenEstaciones.firstWhere(
      (data) =>
          removeDiacritics(data['Estacion']) == removeDiacritics(estacion) &&
          removeDiacritics(data['Municipio']) == removeDiacritics(municipio),
      orElse: () => {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 40),
            const Center(
              child: Text(
                'Resumen mensual',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: favorites.isEmpty
                  ? const Center(
                      child: Text(
                        'No hay favoritos seleccionados',
                        style: TextStyle(fontSize: 20),
                      ),
                    )
                  : ListView.builder(
                      itemCount: favorites.length,
                      itemBuilder: (BuildContext context, int index) {
                        List<String> parts = favorites[index].split(' - ');
                        String estacion = parts[0].split(': ')[1];
                        String municipio = parts[1].split(': ')[1];
                        Map<String, dynamic> data =
                            getDataForEstacionAndMunicipio(estacion, municipio);
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Card(
                            color: lightGreen,
                            elevation: 0, // No shadow
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: const BorderSide(
                                  color: Colors.black, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  estacion_municipio(estacion, municipio),
                                  if (data.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Temperatura(
                                      "Temperatura",
                                      '${data["Temp_max"]}°C',
                                      '${data["Temp_med"]}°C',
                                      '${data["Temp_min"]}°C',
                                    ),
                                    const SizedBox(height: 10),
                                    informacion_singular(
                                      "Precipitacion:",
                                      "${data['Precipitacion']} mm",
                                      Icons.cloudy_snowing,
                                    ),
                                    const SizedBox(height: 10),
                                    const Center(
                                      child: Text(
                                        'Viento:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.air,
                                              size: 40,
                                            ),
                                            const Text(
                                              "Max/Med",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data['Viento_max']} km/hr | ${data['Viento_med']} km/hr',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const Center(
                                      child: Text(
                                        'Humedad:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.thermostat,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                            const Text(
                                              'Max',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["Humedad_max"]}°C',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.thermostat,
                                              size: 40,
                                            ),
                                            const Text(
                                              'Med',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["Humedad_med"]}°C',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.thermostat,
                                                size: 40,
                                                color: Colors.blue[200]),
                                            const Text(
                                              "Min",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["Humedad_min"]}°C',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        informacion_singular(
                                          "Radiacion:",
                                          "${data['Radiacion']} mm",
                                          Icons.cloudy_snowing,
                                        ),
                                        informacion_singular(
                                          "Evapotranspiracion:",
                                          "${data['Evapotranspiracion']} mm",
                                          Icons.cloudy_snowing,
                                        ),
                                      ],
                                    )
                                  ] else ...[
                                    const SizedBox(height: 10),
                                    const Text(
                                      'No data available',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
