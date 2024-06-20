import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/View/widgets.dart';
import 'package:inifap/screens/app_with_drawer.dart';
import 'package:inifap/screens/grafica.dart';
import 'package:inifap/screens/list_page.dart';
import 'package:inifap/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ResumenAvanceMensual extends StatefulWidget {
  const ResumenAvanceMensual({super.key});

  @override
  State createState() => _ResumenAvanceMensualState();
}

class _ResumenAvanceMensualState extends State<ResumenAvanceMensual> {
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
    String? storedDataJson = await secureStorage.read(key: 'avance_mensual');
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
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Avance mensual',
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
                                  estacion_municipio(data['Est'], data['Est']),
                                  if (data.isNotEmpty) ...[
                                    Center(
                                      child: Column(
                                        children: [
                                          const Icon(Icons.calendar_month,
                                              size: 50, color: Colors.black),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            getMonthName(
                                                int.parse(data['Mes'])),
                                            style: const TextStyle(
                                                fontSize: 18,
                                                color: Colors.blue),
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    Temperatura(
                                      "Temperatura",
                                      '${data["TempMax"]}°C',
                                      '${data["TempMed"]}°C',
                                      '${data["TempMin"]}°C',
                                      Icons.thermostat,
                                    ),
                                    const SizedBox(height: 10),
                                    informacion_singular(
                                      "Precipitacion:",
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
                                              Icons.water_drop,
                                              color: Colors.red,
                                              size: 40,
                                            ),
                                            const Text(
                                              'Max',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["HumRMax"]}%',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            const Icon(
                                              Icons.water_drop,
                                              size: 40,
                                            ),
                                            const Text(
                                              'Med',
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["HumRMed"]}%',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                        Column(
                                          children: [
                                            Icon(Icons.water_drop,
                                                size: 40,
                                                color: Colors.blue[200]),
                                            const Text(
                                              "Min",
                                              style: TextStyle(fontSize: 18),
                                            ),
                                            Text(
                                              '${data["HumRMin"]}%',
                                              style: const TextStyle(
                                                  fontSize: 18,
                                                  color: Colors.blue),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        informacion_singular(
                                          "Radiación:",
                                          "${data['Rad']} W/m",
                                          Icons.cloudy_snowing,
                                        ),
                                        informacion_singular(
                                          "Evapotranspiración:",
                                          "${data['Eto']} mm",
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
