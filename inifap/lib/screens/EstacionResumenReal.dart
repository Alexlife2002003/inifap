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

  @override
  void initState() {
    super.initState();
    loadResumenEstaciones().then((_) {
      loadFavorites();
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
      Map<String, dynamic> info = await getDataForEstacionAndMunicipio(favorites);
      print("info $info");
      infoList.add(info);
    }

    setState(() {
      detailedInfo = infoList;
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
    String? storedDataJson = await secureStorage.read(key: 'Resumen_tiempo_real');
    print("stored json $storedDataJson");
    if (storedDataJson != null) {
      setState(() {
        resumenEstaciones = List<Map<String, dynamic>>.from(json.decode(storedDataJson));
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
                          style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          info['Est'] ?? 'N/A',
                          style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Fecha de instalacion:\n ${info['Instalacion'] ?? 'N/A'}",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        WeatherCard(
                          icon: Icons.thermostat,
                          label: 'Temperatura',
                          value: info['temperatura'] ?? 'N/A',
                          max: 'Max ${info['TempMax']}°C a las ${info['HoraMaxTemp']} hr',
                          min: 'Min ${info['TempMin']}°C a las ${info['HoraMinTemp']} hr',
                          avg: 'Med ${info['TempMed']}°C',
                        ),
                        WeatherCard(
                          icon: Icons.water_drop,
                          label: 'Humedad\nrelativa',
                          value: info['humedad'] ?? 'N/A',
                          max: 'Max ${info['HumedadMax']}% a las ${info['HoraHumedadMax']} hr',
                          min: 'Min ${info['HumedadMin']}% a las ${info['HoraHumedadMin']} hr',
                          avg: 'Med ${info['HumedadMed']}%',
                        ),
                        WeatherCard(
                          icon: Icons.cloudy_snowing,
                          label: 'Precipitación',
                          value: info['precipitacion'] ?? 'N/A',
                          total: 'Total acumulada\n${info['Pre']} mm',
                        ),
                        WeatherCard(
                          icon: Icons.sunny,
                          label: 'Radiación',
                          value: info['radiacion'] ?? 'N/A',
                          total: 'Total registrada\n NA W/m²',
                        ),
                        WeatherCardViento(
                          icon: Icons.air,
                          label: 'Velocidad y\ndirección del\n viento',
                          value: info['viento'] ?? 'N/A',
                          max: 'Max ${info['VelMax']} proveniente del N/A a las N/A hr',
                          min: 'Min 4 Km/hr proveniente del N/A a las N/A hr',
                          avg: 'Med 17.5 Km/hr proveniente del N/A',
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
