import 'package:flutter/material.dart';
import 'package:inifap/screens/AppWithDrawer.dart';
import 'package:inifap/screens/resumenAvanceMensual.dart';
import 'package:inifap/screens/resumenDiaAnterior.dart';
import 'package:inifap/screens/resumenReal.dart';
import 'package:inifap/widgets/Colors.dart';

class ResumenRealOrYesterday extends StatefulWidget {
  const ResumenRealOrYesterday({super.key});

  @override
  State<ResumenRealOrYesterday> createState() => _ResumenRealOrYesterdayState();
}

class _ResumenRealOrYesterdayState extends State<ResumenRealOrYesterday> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return AppWithDrawer(
      content: Scaffold(
        appBar: AppBar(
          backgroundColor: lightGreen,
          elevation: 0,
          title: const Text(
            "Datos en tiempo real",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Container(
              height: screenHeight,
              child: Column(
                children: [
                  Row(
                    children: [
                      _buildForecastCard(Icons.today, "Resumen en tiempo real",
                          Colors.lightBlue, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResumenReal()),
                        );
                      }),
                      _buildForecastCard(Icons.calendar_today,
                          "Resumen dia anterior", Colors.orangeAccent, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ResumenDiaAnterior()),
                        );
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      _buildForecastCard(Icons.calendar_month, "Avance mensual",
                          Colors.blueGrey, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => resumenAvanceMensual()),
                        );
                      })
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildForecastCard(
      IconData icon, String title, Color color, VoidCallback onPressed) {
    return GestureDetector(
      onTap: (onPressed),
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            0.5, // Set width to half of the screen size
        child: Card(
          color: color,
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Icon(
                  icon,
                  size: 40,
                  color: Colors.white,
                ),
                const SizedBox(height: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
