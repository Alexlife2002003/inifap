import 'package:flutter/material.dart';
import 'package:inifap/datos/Datos.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:inifap/widgets/icons/RotatedIcon.dart';

import 'package:shared_preferences/shared_preferences.dart';

class ResumenReal extends StatefulWidget {
  @override
  _ResumenRealState createState() => _ResumenRealState();
}

class _ResumenRealState extends State<ResumenReal> {
  List<String> favorites = [];
  List<Map<String, dynamic>> resumenEstaciones = [];

  @override
  void initState() {
    super.initState();
    loadFavorites();
    loadResumenEstaciones();
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  void loadResumenEstaciones() {
    // Data from your provided list
    resumenEstaciones = ResumenEstacionesTiempoReal;
  }

  Map<String, dynamic> getDataForEstacionAndMunicipio(
      String estacion, String municipio) {
    return resumenEstaciones.firstWhere(
      (data) => data['Estacion'] == estacion && data['Municipio'] == municipio,
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
                'Resumen tiempo real',
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
                              side: const BorderSide(color: Colors.black, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Estacion:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        estacion,
                                        style: const TextStyle(
                                            fontSize: 20, color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      const Text(
                                        'Municipio:',
                                        style: TextStyle(fontSize: 20),
                                      ),
                                      Text(
                                        municipio,
                                        style: const TextStyle(fontSize: 20,color: Colors.blue),
                                      ),
                                    ],
                                  ),
                                  if (data.isNotEmpty) ...[
                                    const SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.access_time,
                                              size: 50,
                                              color: Colors.black,
                                            ),
                                            const SizedBox(height: 5),
                                            Text(
                                              '${data['Hora']} hrs',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
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
                                    const Center(
                                      child: Text(
                                        'Temperatura:',
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
                                              '${data["Max"]}°C',
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
                                              '${data["Med"]}°C',
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
                                              '${data["Min"]}°C',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    const Center(
                                      child: Text(
                                        'Precipitacion:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.cloudy_snowing,
                                              size: 40,
                                            ),
                                            Text(
                                              "${data['Precipitacion']} mm",
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
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
