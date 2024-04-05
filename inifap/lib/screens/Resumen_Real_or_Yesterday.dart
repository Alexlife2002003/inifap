import 'package:flutter/material.dart';
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
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: SingleChildScrollView(
        child: Container(
          color: lightGreen,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 50,
              ),
              Row(
                children: [
                  _buildForecastCard(
                      Icons.today, "Resumen en tiempo real", Colors.lightBlue,
                      () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  ResumenReal()),
                    );
                  }),
                  _buildForecastCard(Icons.calendar_today,
                      "Resumen dia anterior", Colors.orangeAccent,(){
                        Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>  ResumenDiaAnterior()),
                    );
                      }),
                ],
              ),
              Row(
                children: [
                  _buildForecastCard(
                      Icons.calendar_month, "Avance mensual", Colors.blueGrey,(){})
                ],
              ),
              _buildForecastCard(
                  Icons.today, "Today's Forecast", Colors.lightBlue,(){}),
              _buildForecastCard(Icons.calendar_today, "Yesterday's Forecast",
                  Colors.orangeAccent,(){}),
              _buildForecastCard(Icons.wb_sunny, "Sunny", Colors.yellow,(){}),
              _buildForecastCard(Icons.cloud, "Cloudy", Colors.grey,(){}),
              _buildForecastCard(Icons.waves, "Rainy", Colors.blue,(){}),
              _buildForecastCard(Icons.grain, "Windy", Colors.lightBlue,(){}),
              _buildForecastCard(
                  Icons.ac_unit, "Snowy", Colors.lightBlueAccent,(){}),
              _buildForecastCard(Icons.hot_tub, "Humid", Colors.purple,(){}),
              _buildForecastCard(
                  Icons.nightlight_round, "Night", Colors.indigo,(){}),
            ],
          ),
        ),
      ),
    );
  }


  Widget _newCardTitle(
    IconData icon,
    String title,
    Color color,
  ) {
    return GestureDetector(
      onTap: () {},
      child: Card(
        color: lightGreen,
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(
                icon,
                size: 40,
                color: color,
              ),
              const SizedBox(height: 8),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ],
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
