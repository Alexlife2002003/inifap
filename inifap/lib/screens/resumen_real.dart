import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/View/widgets.dart';
import 'package:inifap/screens/app_with_drawer.dart';
import 'package:inifap/screens/list_page.dart';
import 'package:inifap/widgets/colors.dart';
import 'package:inifap/widgets/icons/rotated_icon.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumenReal extends StatefulWidget {
  const ResumenReal({super.key});

  @override
  State createState() => _ResumenRealState();
}

class _ResumenRealState extends State<ResumenReal> {
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
    String? storedDataJson =
        await secureStorage.read(key: 'Resumen_tiempo_real');
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

  Map<String, dynamic> getDataForEstacionAndMunicipio(String id) {
    return resumenEstaciones.firstWhere(
      (data) => data['Id'].toString() == id,
      orElse: () => {},
    );
  }

  hora_fecha(String hora, String fecha) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
              hora,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ],
        ),
        Column(
          children: [
            const Icon(Icons.calendar_month, size: 50, color: Colors.black),
            const SizedBox(
              height: 5,
            ),
            Text(
              fecha,
              style: const TextStyle(fontSize: 18, color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }

  void botonListPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const AppWithDrawer(
          content: ListPage(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double fontSizeTitle = screenWidth * 0.05;
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context);
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Resumen tiempo real',
            style: TextStyle(
              fontSize: fontSizeTitle,
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
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'No hay favoritos seleccionados',
                              style: TextStyle(fontSize: 20),
                            ),
                            ElevatedButton(
                              onPressed: botonListPage,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: lightGreen,
                                foregroundColor: darkGreen,
                              ),
                              child: const Text("Seleccionar favoritos"),
                            )
                          ],
                        ),
                      )
                    : ListView.builder(
                        itemCount: favorites.length,
                        itemBuilder: (BuildContext context, int index) {
                          String id = favorites[index];
                          Map<String, dynamic> data =
                              getDataForEstacionAndMunicipio(id);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              color: lightGreen,
                              elevation: 0,
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
                                    estacionMunicipio(data['Est'], data['Est']),
                                    if (data.isNotEmpty) ...[
                                      const SizedBox(height: 10),
                                      hora_fecha('${data['Hora']} hrs',
                                          '${data['Fecha']}'),
                                      const SizedBox(height: 10),
                                      temperatura(
                                        "Temperatura:",
                                        '${data["TempMax"]}°C',
                                        '${data["TempMed"]}°C',
                                        '${data["TempMin"]}°C',
                                        Icons.thermostat,
                                      ),
                                      const SizedBox(height: 10),
                                      informacionSingular(
                                        "Precipitación:",
                                        "${data['Pre']} mm",
                                        CupertinoIcons.cloud_rain_fill,
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
                                                icon:
                                                    Icons.assistant_navigation,
                                                direction:
                                                    '${data['DirViento']}', // Dirección basada en los datos proporcionados
                                                size: 40,
                                              ),
                                              const Text(
                                                'Dirección',
                                                style: TextStyle(fontSize: 18),
                                              ),
                                              Text(
                                                '${data['DirViento']}',
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
      ),
    );
  }
}
