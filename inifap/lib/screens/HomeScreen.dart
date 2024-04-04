import 'package:flutter/material.dart';
import 'package:inifap/widgets/WeatherCardViento.dart';
import 'package:inifap/widgets/weatherCard.dart';
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 50),
            Image.asset(
              'lib/assets/logo.png',
            ),
            const SizedBox(height: 15,),
            const Text(
              "Rancho Grande",
              style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Fresnillo",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Fecha de instalacion:\n27 de marzo 2003",
              style: TextStyle(fontSize: 20, color: Colors.grey),
            ),
            const SizedBox(height: 25),
            const WeatherCard(
              icon: Icons.thermostat,
              label: 'Temperatura',
              value: '22.7 °C',
              max: 'Max 24.9°C a las 13:30 hr',
              min: 'Min 10.6°C a las 07:00 hr',
              avg: 'Med 15.7°C',
            ),
            const WeatherCard(
              icon: Icons.water_drop,
              label: 'Humedad\nrelativa',
              value: '15.9 %',
              max: 'Max 38.9% a las 06:15hr',
              min: 'Min 12.5% a las 14:30hr',
              avg: 'Med 25.6%',
            ),
            const WeatherCard(
              icon: Icons.cloudy_snowing,
              label: 'Precipitación',
              value: '0.0 mm',
              total: 'Total acumulada\n0.0 mm',
            ),
            const WeatherCard(
              icon: Icons.sunny,
              label: 'Radiación',
              value: '103.2 W/m²',
              total: 'Total registrada\n12,413 W/m²',
            ),
            const WeatherCardViento(
              icon: Icons.air,
              label: 'Velocidad y\ndirección del\n viento',
              value: '21.3 Km/hr',
              max: 'Max 35 Km/hr proveniente del Sur a las 15:30 hr',
              min: 'Min 4 Km/hr proveniente del Sur a las 08:30 hr',
              avg: 'Med 17.5 Km/hr proveniente del SSO',
            ),
          ],
        ),
      ),
    );
  }
}