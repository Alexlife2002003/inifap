import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/View/widgets.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:inifap/widgets/icons/RotatedIcon.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diacritic/diacritic.dart';

class ResumenDiaAnterior extends StatefulWidget {
  @override
  _ResumenDiaAnteriorState createState() => _ResumenDiaAnteriorState();
}

class _ResumenDiaAnteriorState extends State<ResumenDiaAnterior> {
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
      String temporary = prefs.getString('estacionActual') ?? "";
      if (temporary != "") {
        favorites.add(temporary);
      }
    });
  }

  Future<void> loadResumenEstaciones() async {
    // Data from your provided list
    const secureStorage = FlutterSecureStorage();
    String? storedDataJson = await secureStorage.read(key: 'dia_anterior');
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
      appBar: AppBar(
        title: Text(
          'Resumen dia anterior',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
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
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Icon(Icons.calendar_month,
                                                size: 50, color: Colors.black),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${data['Fecha']}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    Temperatura(
                                      "Temperatura",
                                      '${data["Max"]}°C',
                                      '${data["Med"]}°C',
                                      '${data["Min"]}°C',
                                      Icons.thermostat,
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
                                              '${data['VelMax']} km/hr | ${data['VelMed']} km/hr',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            RotatedIcon(
                                              icon: Icons.assistant_navigation,
                                              direction:
                                                  '${data['Direccion']}', // Dirección basada en los datos proporcionados
                                              size: 40,
                                            ),
                                            const Text(
                                              'Direccion',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data['Direccion']}',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
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
