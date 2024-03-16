import 'package:flutter/material.dart';
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
        title: Text('Resumen en tiempo real'),
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
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.access_time,
                                              size: 20,
                                              color: Colors.black,
                                            ),
                                            SizedBox(width: 5),
                                            Text(
                                              '${data['Hora']}',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Icon(Icons.calendar_month,
                                                size: 20, color: Colors.black),
                                            SizedBox(
                                              width: 5,
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
                                    Text(
                                      'Temperatura:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Max: ${data["Max"]}°C',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'Min: ${data["Min"]}°C',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'Med: ${data["Med"]}°C',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Precipitacion:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "${data['Precipitacion']}",
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Viento:',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 5),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Med: ${data['VelMed']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'Max: ${data['VelMax']}',
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Text(
                                          'Direccion: ${data['Direccion']}',
                                          style: TextStyle(fontSize: 18),
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
