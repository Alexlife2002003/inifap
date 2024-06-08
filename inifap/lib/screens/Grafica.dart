import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/backend/fetchData.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:intl/intl.dart';

class Grafica extends StatefulWidget {
  final String title;
  final String storageKey;
  final String yAxisTitle;
  final String valueKey;
  final String dotenvname;

  const Grafica({
    Key? key,
    required this.title,
    required this.storageKey,
    required this.yAxisTitle,
    required this.valueKey,
    required this.dotenvname,
  }) : super(key: key);

  @override
  _GraficaState createState() => _GraficaState();
}

class _GraficaState extends State<Grafica> {
  List<Map<String, dynamic>> resumenGrafica = [];
  List<GraphData> graphData = [];
  double _chartOffset = 0.0;
  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<String> dateList = [];
  String? estacion = "";
  String? municipio = "";
  String fechalarga = "";

  @override
  void initState() {
    super.initState();
    generateDateList();
    getEstacionNameAndMunicipio();
    loadGrafica().then((_) {
      loadDataTransformation();
    });
  }

  void generateDateList() {
    DateTime startDate = DateTime(2023, 12, 31);
    DateTime endDate = DateTime.now();
    DateTime currentDate = startDate;

    while (currentDate.isBefore(endDate) ||
        currentDate.isAtSameMomentAs(endDate)) {
      dateList.add(DateFormat('dd-MM-yyyy').format(currentDate));
      currentDate = currentDate.add(const Duration(days: 1));
    }
    dateList = dateList.reversed
        .toList(); // Reverse the list to have the most recent date on top
    selectedDate = dateList.first; // Select the most recent date
  }

  void loadDataTransformation() async {
    graphData.clear(); // Clear the graphData list before adding new data
    List<dynamic> datos = resumenGrafica[0]['Datos'];
    for (var item in datos) {
      graphData
          .add(GraphData(item['Hora'], double.parse(item[widget.valueKey])));
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    estacion = prefs.getString('Estacion');
    municipio = prefs.getString('Municipio');
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
    List<String> splitdate = selectedDate.split("-");
    fechalarga =
        "${splitdate[0]} de ${getMonthName(int.parse(splitdate[1]))} del ${splitdate[2]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text(
                estacion ?? "NA",
                style:
                    const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
              ),
              Text(
                municipio ?? "NA",
                style:
                    const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 15,
              ),
              const Text(
                "Fecha:",
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              Text(
                "$fechalarga",
                style: const TextStyle(fontSize: 20, color: Colors.grey),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: DropdownButton<String>(
                  value: selectedDate,
                  onChanged: (String? newValue) {
                    setState(() async {
                      selectedDate = newValue!;
                      List<String> splitdate = selectedDate.split("-");
                      graphData = [];
                      resumenGrafica = [];
                      await fetchDataGrafica(splitdate[0], splitdate[1],
                          splitdate[2], widget.storageKey, widget.dotenvname);
                      loadGrafica().then((_) {
                        loadDataTransformation();
                      });
                    });
                  },
                  items: dateList.map<DropdownMenuItem<String>>((String date) {
                    return DropdownMenuItem<String>(
                      value: date,
                      child: Text(date),
                    );
                  }).toList(),
                ),
              ),
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
                            primaryXAxis: const CategoryAxis(
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
                                markerSettings: const MarkerSettings(
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
              const Padding(
                padding: EdgeInsets.all(8.0),
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
