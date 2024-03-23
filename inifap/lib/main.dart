import 'package:flutter/material.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/screens/resumenReal.dart';
import 'package:inifap/widgets/Colors.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inifap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ListPage(),
    ResumenReal(),
    GraphScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkGreen,
        currentIndex: _currentIndex,
        selectedItemColor: lightGreen,
        unselectedItemColor: Colors.grey.shade500,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: darkGreen,
            icon: const Icon(Icons.sunny_snowing),
            label: 'Estacion',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista Estaciones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Resumen tiempo real',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.open_with_rounded),
            label: 'Other',
          ),
        ],
      ),
    );
  }
}

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

class WeatherCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? max;
  final String? min;
  final String? avg;
  final String? total;

  const WeatherCard({
    required this.icon,
    required this.label,
    required this.value,
    this.max,
    this.min,
    this.avg,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - 40;
    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: cardWidth,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: lightGreen,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 32.0,
                ),
                const SizedBox(width: 5.0),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          value,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      children: [
                        const Text(
                          'Resumen registrado:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (max != null) Text(max!),
                        if (min != null) Text(min!),
                        if (avg != null) Text(avg!),
                        if (total != null) Text(total!),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherCardViento extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? max;
  final String? min;
  final String? avg;
  final String? total;

  const WeatherCardViento({
    required this.icon,
    required this.label,
    required this.value,
    this.max,
    this.min,
    this.avg,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - 40;
    return Container(
      padding: const EdgeInsets.only(left: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: cardWidth,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: lightGreen,
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Icon(
                      icon,
                      color: Colors.blue,
                      size: 32.0,
                    ),
                    const SizedBox(width: 5.0),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              label,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              value,
                              style: const TextStyle(fontSize: 16.0),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  children: [
                    const Text(
                      'Resumen registrado:',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    if (max != null) Text(max!),
                    if (min != null) Text(min!),
                    if (avg != null) Text(avg!),
                    if (total != null) Text(total!),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ExploreScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('List of places'),
    );
  }
}

class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Other'),
    );
  }
}
