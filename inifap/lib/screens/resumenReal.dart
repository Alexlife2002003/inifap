import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:inifap/datos/Datos.dart';
import 'package:inifap/widgets/Colors.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - 40;
    return Scaffold(
      appBar: AppBar(
        title: Text('Resumen tiempo real'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              'Lista de favoritos:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blueAccent,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: favorites.isEmpty
                  ? Center(
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
                              side: BorderSide(color: Colors.black, width: 1),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Estacion: $estacion',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  Text(
                                    'Municipio: $municipio',
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  if (data.isNotEmpty) ...[
                                    SizedBox(height: 10),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 50,
                                              color: Colors.black,
                                            ),
                                            SizedBox(height: 5),
                                            Text(
                                              '${data['Hora']} hrs',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.calendar_month,
                                                size: 50, color: Colors.black),
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              '${data['Fecha']}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        'Temperatura:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.thermostat,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                            Text(
                                              'Max',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["Max"]}°C',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.thermostat,
                                              size: 40,
                                            ),
                                            Text(
                                              'Med',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["Med"]}°C',
                                              style: TextStyle(
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
                                            Text(
                                              "Min",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["Min"]}°C',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Center(
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
                                            Icon(
                                              Icons.cloudy_snowing,
                                              size: 40,
                                            ),
                                            Text(
                                              "${data['Precipitacion']}",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Center(
                                      child: Text(
                                        'Viento:',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.air,
                                              size: 40,
                                            ),
                                            Text(
                                              "Max/Med",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data['VelMax']} km/hr | ${data['VelMed']} km/hr',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(
                                              Icons.discord,
                                              size: 40,
                                            ),
                                            Text(
                                              'Direccion',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data['Direccion']}',
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ] else ...[
                                    SizedBox(height: 10),
                                    Text(
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
