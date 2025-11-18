import 'package:flutter/material.dart';
import 'package:inifap/screens/grafica.dart';
import 'package:inifap/screens/grafica_precipitacion.dart';
import 'package:inifap/screens/resumen_avance_mensual.dart';
import 'package:inifap/screens/resumen_dia_anterior.dart';
import 'package:inifap/screens/resumen_real.dart';

class ResumenRealOrYesterday extends StatefulWidget {
  const ResumenRealOrYesterday({super.key});

  @override
  State<ResumenRealOrYesterday> createState() => _ResumenRealOrYesterdayState();
}

class _ResumenRealOrYesterdayState extends State<ResumenRealOrYesterday> {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Center(
      child: Scaffold(
        body: Center(
          child: SizedBox(
            height: screenHeight,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const Text(
                    'Resumen',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      _buildForecastCard(Icons.today, "Resumen en tiempo real",
                          Colors.lightBlue, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResumenReal()),
                        );
                      }),
                      _buildForecastCard(Icons.calendar_today,
                          "Resumen día anterior", Colors.orangeAccent, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ResumenDiaAnterior()),
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
                              builder: (context) =>
                                  const ResumenAvanceMensual()),
                        );
                      }),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    'Gráficas',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      _buildForecastCard(
                          Icons.auto_graph_rounded, "Temperatura", Colors.brown,
                          () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Grafica(
                                    title: 'Gráfica Temperatura',
                                    storageKey: 'grafica_temperatura',
                                    yAxisTitle: 'Temperatura',
                                    valueKey: 'Temp',
                                    dotenvname: 'GRAFICA_TEMPERATURA',
                                  )),
                        );
                      }),
                      _buildForecastCard(Icons.auto_graph_rounded,
                          "Precipitación", Colors.lightGreen, () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const GraficaPrecipitacion(
                                    title: 'Gráfica Precipitación',
                                    storageKey: 'grafica_precipitacion',
                                    yAxisTitle: 'Precipitación',
                                    valueKey: 'Pre',
                                    dotenvname: 'GRAFICA_PRECIPITACION',
                                  )),
                        );
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      _buildForecastCard(
                          Icons.auto_graph_rounded, "Humedad", Colors.lightBlue,
                          () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Grafica(
                                      title: 'Gráfica Humedad',
                                      storageKey: 'grafica_humedad',
                                      yAxisTitle: 'Humedad',
                                      valueKey: 'Humedad',
                                      dotenvname: 'GRAFICA_HUMEDAD',
                                    )));
                      }),
                      _buildForecastCard(Icons.auto_graph_rounded, "Radiación",
                          Colors.orangeAccent, () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Grafica(
                                      title: 'Gráfica Radiación',
                                      storageKey: 'grafica_radiacion',
                                      yAxisTitle: 'Radiación',
                                      valueKey: 'Rad',
                                      dotenvname: 'GRAFICA_RADIACION',
                                    )));
                      }),
                    ],
                  ),
                  Row(
                    children: [
                      _buildForecastCard(
                          Icons.auto_graph_rounded, "Viento", Colors.blueGrey,
                          () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Grafica(
                                      title: 'Gráfica Viento',
                                      storageKey: 'grafica_viento',
                                      yAxisTitle: 'Viento',
                                      valueKey: 'VelViento',
                                      dotenvname: 'GRAFICA_VIENTO',
                                    )));
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
        width: MediaQuery.of(context).size.width * 0.5,
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
