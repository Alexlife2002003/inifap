import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class GraficaTemperatura extends StatefulWidget {
  const GraficaTemperatura({Key? key}) : super(key: key);

  @override
  State<GraficaTemperatura> createState() => _GraficaTemperaturaState();
}

class _GraficaTemperaturaState extends State<GraficaTemperatura> {
  List<Map<String, dynamic>> resumenGraficaTemperatura = [];
  List<GraphData> temperatureData = [];
  double _chartOffset = 0.0;

  @override
  void initState() {
    super.initState();
    loadGraficaTemperatura().then((_) {
      loadDataTransformation();
    });
  }

  void loadDataTransformation() {
    List<dynamic> datos = resumenGraficaTemperatura[0]['Datos'];
    for (var item in datos) {
      temperatureData.add(GraphData(item['Hora'], double.parse(item['Temp'])));
    }
  }

  Future<void> loadGraficaTemperatura() async {
    const secureStorage = FlutterSecureStorage();
    String? storedDataJson =
        await secureStorage.read(key: 'grafica_temperatura');
    if (storedDataJson != null) {
      setState(() {
        resumenGraficaTemperatura =
            List<Map<String, dynamic>>.from(json.decode(storedDataJson));
      });
    } else {
      setState(() {
        resumenGraficaTemperatura = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Grafica Temperatura',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          height: 500,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: [
                    Transform.translate(
                      offset: Offset(_chartOffset, 0.0),
                      child: Container(
                        color: lightGreen,
                        width: MediaQuery.of(context).size.width * 2,
                        child: SfCartesianChart(
                          zoomPanBehavior: ZoomPanBehavior(
                            enablePinching: false,
                            enableSelectionZooming: false,
                          ),
                          primaryXAxis: CategoryAxis(
                            title: AxisTitle(text: 'Hora'),
                          ),
                          primaryYAxis: NumericAxis(
                            title: AxisTitle(text: 'Temperatura'),
                          ),
                          series: <LineSeries<GraphData, String>>[
                            LineSeries<GraphData, String>(
                              dataSource: temperatureData,
                              name: 'Temperature',
                              xValueMapper: (GraphData temperature, _) => temperature.Hour,
                              yValueMapper: (GraphData temperature, _) => temperature.value,
                              markerSettings: MarkerSettings(
                                isVisible: true,
                                shape: DataMarkerType.circle,
                                color: Colors.red,
                                borderColor: Colors.black,
                                borderWidth: 2,
                              ),
                            )
                          ],
                          tooltipBehavior: TooltipBehavior(enable: true),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Desliza horizontalmente para ver la grafica entera',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GraphData {
  GraphData(this.Hour, this.value);
  final String Hour;
  final double value;
}
