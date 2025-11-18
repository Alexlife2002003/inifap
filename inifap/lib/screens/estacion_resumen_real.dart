import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:inifap/backend/fetch_data.dart';
import 'package:inifap/screens/app_with_drawer.dart';
import 'package:inifap/screens/list_page.dart';
import 'package:inifap/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inifap/widgets/weather_card_viento.dart';
import 'package:inifap/widgets/weather_card.dart';
import 'package:flutter/cupertino.dart';

class EstacionResumenReal extends StatefulWidget {
  const EstacionResumenReal({super.key});

  @override
  State<EstacionResumenReal> createState() => _EstacionResumenRealState();
}

class _EstacionResumenRealState extends State<EstacionResumenReal> {
  String favorites = "";
  List<Map<String, dynamic>> detailedInfo = [];
  List<Map<String, dynamic>> resumenEstaciones = [];
  List<Map<String, dynamic>> resumenGraficaTemperatura = [];
  List<Map<String, dynamic>> resumenGraficaPrecipitacion = [];
  List<Map<String, dynamic>> resumenGraficaHumedad = [];
  List<Map<String, dynamic>> resumenGraficaRadiacion = [];
  List<Map<String, dynamic>> resumenGraficaViento = [];
  double? lastTemperature;
  double? lastPrecipitation;
  double? lastHumedad;
  double? lastRadiacion;
  double? lastViento;
  String instalacion = "";

  @override
  void initState() {
    super.initState();
    loadResumenEstaciones().then((_) {
      loadFavorites();
    });
    final DateTime currentDate = DateTime.now();
    String day = currentDate.day.toString();
    String month = currentDate.month.toString();
    String year = currentDate.year.toString();
    fetchDataGrafica(
        day, month, year, 'grafica_temperatura', 'GRAFICA_TEMPERATURA');
    fetchDataGrafica(
        day, month, year, 'grafica_precipitacion', 'GRAFICA_PRECIPITACION');
    fetchDataGrafica(day, month, year, 'grafica_humedad', 'GRAFICA_HUMEDAD');
    fetchDataGrafica(
        day, month, year, 'grafica_radiacion', 'GRAFICA_RADIACION');
    fetchDataGrafica(day, month, year, 'grafica_viento', 'GRAFICA_VIENTO');
  }

  void loadDataTransformation() {
    if (resumenGraficaTemperatura.isEmpty ||
        resumenGraficaPrecipitacion.isEmpty ||
        resumenGraficaHumedad.isEmpty ||
        resumenGraficaRadiacion.isEmpty ||
        resumenGraficaViento.isEmpty) return;

    List<dynamic> datosTemperatura = resumenGraficaTemperatura[0]['Datos'];
    List<dynamic> datosPrecipitacion = resumenGraficaPrecipitacion[0]['Datos'];
    List<dynamic> datosHumedad = resumenGraficaHumedad[0]['Datos'];
    List<dynamic> datosRadiacion = resumenGraficaRadiacion[0]['Datos'];
    List<dynamic> datosViento = resumenGraficaViento[0]['Datos'];

    if (datosTemperatura.isNotEmpty) {
      var lastItem = datosTemperatura.last;
      lastTemperature = double.tryParse(lastItem['Temp'].toString());
    }
    if (datosPrecipitacion.isNotEmpty) {
      var lastItem = datosPrecipitacion.last;
      lastPrecipitation = double.tryParse(lastItem['Pre'].toString());
    }
    if (datosHumedad.isNotEmpty) {
      var lastItem = datosHumedad.last;
      lastHumedad = double.tryParse(lastItem['Humedad'].toString());
    }
    if (datosRadiacion.isNotEmpty) {
      var lastItem = datosRadiacion.last;
      lastRadiacion = double.tryParse(lastItem['Rad'].toString());
    }
    if (datosViento.isNotEmpty) {
      var lastItem = datosViento.last;
      lastViento = double.tryParse(lastItem['VelViento'].toString());
    }
  }

  Future<void> loadGrafica() async {
    const secureStorage = FlutterSecureStorage();
    String? storedDataJsonTemperatura =
        await secureStorage.read(key: 'grafica_temperatura');
    String? storedDataJsonPrecipitacion =
        await secureStorage.read(key: 'grafica_precipitacion');
    String? storedDataJsonHumedad =
        await secureStorage.read(key: 'grafica_humedad');
    String? storedDataJsonRadiacion =
        await secureStorage.read(key: 'grafica_radiacion');
    String? storedDataJsonViento =
        await secureStorage.read(key: 'grafica_viento');

    setState(() {
      if (storedDataJsonTemperatura != null &&
          storedDataJsonTemperatura != "null") {
        resumenGraficaTemperatura = List<Map<String, dynamic>>.from(
            json.decode(storedDataJsonTemperatura));
      } else {
        resumenGraficaTemperatura = [];
      }

      if (storedDataJsonPrecipitacion != null &&
          storedDataJsonPrecipitacion != "null") {
        resumenGraficaPrecipitacion = List<Map<String, dynamic>>.from(
            json.decode(storedDataJsonPrecipitacion));
      } else {
        resumenGraficaPrecipitacion = [];
      }

      if (storedDataJsonHumedad != null && storedDataJsonHumedad != "null") {
        resumenGraficaHumedad =
            List<Map<String, dynamic>>.from(json.decode(storedDataJsonHumedad));
      } else {
        resumenGraficaHumedad = [];
      }

      if (storedDataJsonRadiacion != null &&
          storedDataJsonRadiacion != "null") {
        resumenGraficaRadiacion = List<Map<String, dynamic>>.from(
            json.decode(storedDataJsonRadiacion));
      } else {
        resumenGraficaRadiacion = [];
      }

      if (storedDataJsonViento != null && storedDataJsonViento != "null") {
        resumenGraficaViento =
            List<Map<String, dynamic>>.from(json.decode(storedDataJsonViento));
      } else {
        resumenGraficaViento = [];
      }

      if (resumenGraficaHumedad.isNotEmpty) {
        loadDataTransformation();
      }
    });
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      favorites = prefs.getString('estacionActual') ?? "";
    });

    List<Map<String, dynamic>> infoList = [];
    if (favorites.isNotEmpty) {
      Map<String, dynamic> info =
          await getDataForEstacionAndMunicipio(favorites);
      if (info.isNotEmpty) {
        infoList.add(info);
      }
    }

    if (infoList.isNotEmpty) {
      instalacion = infoList[0]['fecha'] ?? '';
      if (instalacion.isNotEmpty && instalacion.contains('-')) {
        var instalacions = instalacion.split("-");
        instalacion =
            "${instalacions[0]} de ${getMonthName(int.parse(instalacions[1]))} del ${instalacions[2]}";
      }
    }

    setState(() {
      detailedInfo = infoList;
      loadGrafica();
    });
  }

  Future<Map<String, dynamic>> getDataForEstacionAndMunicipio(String id) async {
    await loadResumenEstaciones();
    return resumenEstaciones.firstWhere(
      (data) => data['Id'].toString() == id,
      orElse: () => {},
    );
  }

  Future<void> loadResumenEstaciones() async {
    const secureStorage = FlutterSecureStorage();
    String? storedDataJson =
        await secureStorage.read(key: 'Resumen_tiempo_real');
    if (storedDataJson != null) {
      setState(() {
        resumenEstaciones =
            List<Map<String, dynamic>>.from(json.decode(storedDataJson));
      });
    } else {
      setState(() {
        resumenEstaciones = [];
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

  String _formatValue(double? value, String suffix) {
    if (value == null) return '—';
    return "${value.toStringAsFixed(1)}$suffix";
  }

  @override
  Widget build(BuildContext context) {
    final hasStation = detailedInfo.isNotEmpty;

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: SafeArea(
        child: hasStation ? _buildStationView() : _buildEmptyState(),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.location_off_outlined,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            const Text(
              'No hay estación seleccionada',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Selecciona una estación desde la lista para ver los datos en tiempo real.',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: botonListPage,
              style: ElevatedButton.styleFrom(
                backgroundColor: lightGreen,
                foregroundColor: darkGreen,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              icon: const Icon(Icons.list),
              label: const Text('Seleccionar estación'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStationView() {
  // Solo usamos el primer elemento de detailedInfo
  final info = detailedInfo.first;
  final estRaw = info['Est']?.toString() ?? '';
  final splitResult = estRaw.split(' - ');
  final municipio = splitResult.length > 1 ? splitResult[0] : '';
  final estacion = splitResult.length > 1 ? splitResult[1] : estRaw;
  final hora = info['Hora']?.toString() ?? 'N/A';

  return SingleChildScrollView(
    padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
    child: Center(
      // Esto limita el ancho máximo del contenido, evita overflow en pantallas chicas
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 600),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER: logo arriba, texto abajo, todo centrado
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Logo
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: lightGreen.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Image.asset(
                      'lib/assets/logo.png',
                      height: 40,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 12),
                  // Nombre estación
                  Text(
                    estacion,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (municipio.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      municipio,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                  const SizedBox(height: 12),
                  // Fecha
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          instalacion.isNotEmpty ? instalacion : 'Fecha N/D',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  // Hora de actualización
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Última actualización: $hora hrs',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Cards de clima (ya se adaptan al ancho del padre)
            WeatherCard(
              icon: Icons.thermostat,
              label: 'Temperatura',
              value: _formatValue(lastTemperature, ' °C'),
              max:
                  'Max ${info['TempMax']}°C a las ${info['HoraMaxTemp']} hr',
              min:
                  'Min ${info['TempMin']}°C a las ${info['HoraMinTemp']} hr',
              avg: 'Med ${info['TempMed']}°C',
            ),
            WeatherCard(
              icon: Icons.water_drop,
              label: 'Humedad\nrelativa',
              value: _formatValue(lastHumedad, ' %'),
              max:
                  'Max ${info['HumedadMax']}% a las ${info['HoraHumedadMax']} hr',
              min:
                  'Min ${info['HumedadMin']}% a las ${info['HoraHumedadMin']} hr',
              avg: 'Med ${info['HumedadMed']}%',
            ),
            WeatherCard(
              icon: CupertinoIcons.cloud_rain_fill,
              label: 'Precipitación',
              value: _formatValue(lastPrecipitation, ' mm'),
              total: 'Total acumulada\n${info['Pre']} mm',
            ),
            WeatherCard(
              icon: Icons.sunny,
              label: 'Radiación',
              value: _formatValue(lastRadiacion, ' W/m²'),
              total:
                  'Total registrada\n${info['radiacionTotal']} W/m²',
            ),
            WeatherCardViento(
              icon: Icons.air,
              label: 'Velocidad y\ndirección del\nviento',
              value: _formatValue(lastViento, ' Km/hr'),
              max:
                  'Max ${info['VelMax']} Km/hr \nproveniente del ${info['DirVelMax']} a las ${info['VelMaxHora']} hr',
              min:
                  'Min ${info['VelMin']} Km/hr \nproveniente del ${info['DirVelMin']} a las ${info['VelMinHora']} hr',
              avg: 'Med ${info['VelMed']} Km/hr',
            ),
          ],
        ),
      ),
    ),
  );
}

}
