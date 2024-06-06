import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:inifap/widgets/Colors.dart';

class Grafica extends StatefulWidget {
  final String title;
  final String storageKey;
  final String yAxisTitle;
  final String valueKey;

  const Grafica({
    Key? key,
    required this.title,
    required this.storageKey,
    required this.yAxisTitle,
    required this.valueKey,
  }) : super(key: key);

  @override
  _GraficaState createState() => _GraficaState();
}

class _GraficaState extends State<Grafica> {
  List<Map<String, dynamic>> resumenGrafica = [];
  List<GraphData> graphData = [];
  double _chartOffset = 0.0;

  @override
  void initState() {
    super.initState();
    loadGrafica().then((_) {
      loadDataTransformation();
    });
  }

  void loadDataTransformation() {
    List<dynamic> datos = resumenGrafica[0]['Datos'];
    for (var item in datos) {
      graphData
          .add(GraphData(item['Hora'], double.parse(item[widget.valueKey])));
    }
  }

  Future<void> loadGrafica() async {
    const secureStorage = FlutterSecureStorage();
    String? storedDataJson = await secureStorage.read(key: widget.storageKey);
    if (storedDataJson != null) {
      setState(() {
        resumenGrafica =
            List<Map<String, dynamic>>.from(json.decode(storedDataJson));
      });
    } else {
      setState(() {
        resumenGrafica = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
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
                      child: Card(
                        elevation: 10,
                        shadowColor: Colors.grey.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: lightGreen,
                          ),
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
                              title: AxisTitle(text: widget.yAxisTitle),
                            ),
                            series: <LineSeries<GraphData, String>>[
                              LineSeries<GraphData, String>(
                                dataSource: graphData,
                                name: widget.title,
                                xValueMapper: (GraphData data, _) => data.hour,
                                yValueMapper: (GraphData data, _) => data.value,
                                markerSettings: MarkerSettings(
                                  isVisible: true,
                                  shape: DataMarkerType.circle,
                                  color: Colors.red,
                                  borderColor: Colors.black,
                                  borderWidth: 2,
                                ),
                              ),
                            ],
                            tooltipBehavior: TooltipBehavior(enable: true),
                          ),
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
  GraphData(this.hour, this.value);
  final String hour;
  final double value;
}
