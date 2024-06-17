import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/backend/fetch_data.dart';
import 'package:inifap/screens/app_with_drawer.dart';
import 'package:inifap/screens/list_page.dart';
import 'package:inifap/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:intl/intl.dart';

class Grafica extends StatefulWidget {
  final String title;
  final String storageKey;
  final String yAxisTitle;
  final String valueKey;
  final String dotenvname;

  const Grafica({
    super.key,
    required this.title,
    required this.storageKey,
    required this.yAxisTitle,
    required this.valueKey,
    required this.dotenvname,
  });

  @override
  _GraficaState createState() => _GraficaState();
}

class _GraficaState extends State<Grafica> {
  List<Map<String, dynamic>> resumenGrafica = [];
  List<GraphData> graphData = [];
  String selectedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());
  List<String> dateList = [];
  String? estacion = "";
  String? municipio = "";
  String fechalarga = "";
  bool _isLoading = true;

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
    dateList = dateList.reversed.toList();
    selectedDate = dateList.first;
  }

  void loadDataTransformation() async {
    graphData.clear();
    if (resumenGrafica.isNotEmpty) {
      List<dynamic> datos = resumenGrafica[0]['Datos'];
      for (var item in datos) {
        graphData
            .add(GraphData(item['Hora'], double.parse(item[widget.valueKey])));
      }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    estacion = prefs.getString('Estacion');
    municipio = prefs.getString('Municipio');

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> loadGrafica() async {
    List<String> splitdate = selectedDate.split("-");
    fechalarga =
        "${splitdate[0]} de ${getMonthName(int.parse(splitdate[1]))} del ${splitdate[2]}";
    await fetchDataGrafica(splitdate[0], splitdate[1], splitdate[2],
        widget.storageKey, widget.dotenvname);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idEst = prefs.getString('estacionActual') ?? "";
    const secureStorage = FlutterSecureStorage();
    String? storedDataJson = await secureStorage.read(key: widget.storageKey);
    if (storedDataJson != null && idEst != "") {
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

  void botonListPage() {
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(
        builder: (context) => const AppWithDrawer(
          content: ListPage(),
        ),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double fontSizeTitle = screenWidth * 0.08;
    double fontSizeTitle2 = screenWidth * 0.06;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            fontSize: screenWidth * 0.06,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: _isLoading
              ? const CircularProgressIndicator()
              : resumenGrafica.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('No hay favoritos seleccionados'),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: botonListPage,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: lightGreen,
                            foregroundColor: darkGreen,
                          ),
                          child: const Text("Seleccionar Favoritos"),
                        )
                      ],
                    )
                  : Column(
                      children: [
                        Text(
                          estacion ?? "NA",
                          style: TextStyle(
                            fontSize: fontSizeTitle,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          municipio ?? "NA",
                          style: TextStyle(
                            fontSize: fontSizeTitle2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: screenHeight * 0.02,
                        ),
                        Text(
                          "Fecha:",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05, color: Colors.grey),
                        ),
                        Text(
                          "$fechalarga",
                          style: TextStyle(
                              fontSize: screenWidth * 0.05, color: Colors.grey),
                        ),
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: DropdownButton<String>(
                            value: selectedDate,
                            onChanged: (String? newValue) {
                              setState(() async {
                                _isLoading =
                                    true; // Set loading to true when date changes
                                selectedDate = newValue!;
                                List<String> splitdate =
                                    selectedDate.split("-");
                                graphData = [];
                                resumenGrafica = [];
                                await fetchDataGrafica(
                                    splitdate[0],
                                    splitdate[1],
                                    splitdate[2],
                                    widget.storageKey,
                                    widget.dotenvname);
                                loadGrafica().then((_) {
                                  loadDataTransformation();
                                });
                              });
                            },
                            items: dateList
                                .map<DropdownMenuItem<String>>((String date) {
                              return DropdownMenuItem<String>(
                                value: date,
                                child: Text(
                                  date,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.04),
                                ),
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
                                offset: const Offset(0.0, 0.0),
                                child: Card(
                                  elevation: 10,
                                  shadowColor: Colors.grey.withOpacity(0.5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15),
                                    side:
                                        BorderSide(color: darkGreen, width: 2),
                                  ),
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: lightGreen,
                                    ),
                                    width: screenWidth * 2,
                                    child: SfCartesianChart(
                                      zoomPanBehavior: ZoomPanBehavior(
                                        enablePinching: false,
                                        enableSelectionZooming: false,
                                      ),
                                      primaryXAxis: const CategoryAxis(
                                        title: AxisTitle(text: 'Hora'),
                                      ),
                                      primaryYAxis: NumericAxis(
                                        title:
                                            AxisTitle(text: widget.yAxisTitle),
                                      ),
                                      series: <LineSeries<GraphData, String>>[
                                        LineSeries<GraphData, String>(
                                          dataSource: graphData,
                                          name: widget.title,
                                          xValueMapper: (GraphData data, _) =>
                                              data.hour,
                                          yValueMapper: (GraphData data, _) =>
                                              data.value,
                                          markerSettings: const MarkerSettings(
                                            isVisible: true,
                                            shape: DataMarkerType.circle,
                                            color: Colors.red,
                                            borderColor: Colors.black,
                                            borderWidth: 2,
                                          ),
                                        ),
                                      ],
                                      tooltipBehavior:
                                          TooltipBehavior(enable: true),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(screenWidth * 0.02),
                          child: Text(
                            'Desliza horizontalmente para ver la grafica entera',
                            style: TextStyle(
                                fontSize: screenWidth * 0.04,
                                color: Colors.black54),
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

String getMonthName(int monthNumber) {
  List<String> months = [
    'Enero',
    'Febrero',
    'Marzo',
    'Abril',
    'Mayo',
    'Junio',
    'Julio',
    'Agosto',
    'Septiembre',
    'Octubre',
    'Noviembre',
    'Diciembre'
  ];
  return months[monthNumber - 1];
}
