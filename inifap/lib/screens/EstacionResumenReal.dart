import 'package:flutter/material.dart';
import 'package:inifap/datos/Datos.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:inifap/widgets/WeatherCardViento.dart';
import 'package:inifap/widgets/weatherCard.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:diacritic/diacritic.dart';

import 'dart:async';

class EstacionResumenReal extends StatefulWidget {
  const EstacionResumenReal({Key? key}) : super(key: key);

  @override
  State<EstacionResumenReal> createState() => _EstacionResumenRealState();
}

class _EstacionResumenRealState extends State<EstacionResumenReal> {
  String favorites = "";
  List<Map<String, dynamic>> detailedInfo = [];

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getString('estacionActual') ?? "";
    });

    // Load detailed information for each favorite
    List<Map<String, dynamic>> infoList = [];
    if (favorites.isNotEmpty) {
      List<String> parts = favorites.split(' - ');
      String estacion = parts[0].split(': ')[1];
      String municipio = parts[1].split(': ')[1];
      Map<String, dynamic> info =
          fetchDataForEstacionAndMunicipio(estacion, municipio);
      infoList.add(info);
    }
   

    setState(() {
      detailedInfo = infoList;
    });
  }

  String getMonthName(int month) {
    switch (month) {
      case 1:
        return "Enero";
      case 2:
        return "Febrero";
      case 3:
        return "Marzo";
      case 4:
        return "Abril";
      case 5:
        return "Mayo";
      case 6:
        return "June";
      case 7:
        return "July";
      case 8:
        return "August";
      case 9:
        return "September";
      case 10:
        return "October";
      case 11:
        return "November";
      case 12:
        return "December";
      default:
        return "Invalid month";
    }
  }

  // Simulated function to fetch detailed data based on estacion and municipio
  Map<String, dynamic> fetchDataForEstacionAndMunicipio(
      String estacion, String municipio) {
    String instalacion = "";
    for (var est in datosEstacions) {
      if (removeDiacritics(est['Estacion']) == removeDiacritics(estacion) &&
          removeDiacritics(est['Municipio']) == removeDiacritics(municipio)) {
        instalacion = est['Instalacion'];
        var instalacions = instalacion.split("-");
        instalacion =
            "${instalacions[2]} de ${getMonthName(int.parse(instalacions[1]))} del ${instalacions[0]}";
      }
    }
    return {
      'estacion': estacion,
      'municipio': municipio,
      'temperatura': '22.7 °C',
      'humedad': '15.9 %',
      'precipitacion': '0.0 mm',
      'radiacion': '103.2 W/m²',
      'viento': '21.3 Km/hr',
      'Instalacion': instalacion,
    };
  }

  @override
  void initState() {
    super.initState();
    loadFavorites();
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
                  children: [Text('No hay favoritos seleccionadosc')],
                ),
              if (detailedInfo.isNotEmpty)
                Column(
                  children: detailedInfo.map((info) {
                    return Column(
                      children: [
                        SizedBox(height: 40,),
                        Image.asset(
                          'lib/assets/logo.png', // Replace with your image path
                          height: 40, // Adjust the height as needed
                        ),
                        const SizedBox(height: 15),
                        Text(
                          info['estacion'],
                          style: TextStyle(
                              fontSize: 36, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          info['municipio'],
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          "Fecha de instalacion:\n ${info['Instalacion']}",
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                        WeatherCard(
                          icon: Icons.thermostat,
                          label: 'Temperatura',
                          value: info['temperatura'],
                          max: 'Max 24.9°C a las 13:30 hr',
                          min: 'Min 10.6°C a las 07:00 hr',
                          avg: 'Med 15.7°C',
                        ),
                        WeatherCard(
                          icon: Icons.water_drop,
                          label: 'Humedad\nrelativa',
                          value: info['humedad'],
                          max: 'Max 38.9% a las 06:15hr',
                          min: 'Min 12.5% a las 14:30hr',
                          avg: 'Med 25.6%',
                        ),
                        WeatherCard(
                          icon: Icons.cloudy_snowing,
                          label: 'Precipitación',
                          value: info['precipitacion'],
                          total: 'Total acumulada\n0.0 mm',
                        ),
                        WeatherCard(
                          icon: Icons.sunny,
                          label: 'Radiación',
                          value: info['radiacion'],
                          total: 'Total registrada\n12,413 W/m²',
                        ),
                        WeatherCardViento(
                          icon: Icons.air,
                          label: 'Velocidad y\ndirección del\n viento',
                          value: info['viento'],
                          max:
                              'Max 35 Km/hr proveniente del Sur a las 15:30 hr',
                          min: 'Min 4 Km/hr proveniente del Sur a las 08:30 hr',
                          avg: 'Med 17.5 Km/hr proveniente del SSO',
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
