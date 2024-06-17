import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inifap/backend/fetch_data.dart';
import 'package:inifap/screens/app_with_drawer.dart';
import 'package:inifap/screens/list_page.dart';
import 'package:inifap/widgets/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> locations;

  const MapScreen({super.key, required this.locations});

  @override
  State createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  double currentLatitude = 22.76843;
  double currentLongitude = -102.58141;
  double zoomlevel = 8.0;
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadFavorites();
  }

  Future<void> _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
      zoomlevel = 10.0;
      _updateMarkers();
      _updateCameraPosition();
    });
  }

  void _updateMarkers() {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: const MarkerId('currentLocation'),
          position: LatLng(currentLatitude, currentLongitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        ),
      );
      markers.addAll(
        widget.locations.map((location) {
          return Marker(
            markerId: MarkerId(location['Estacion']),
            position: LatLng(
              location['Lat'],
              location['lng'],
            ),
            icon: favorites.any((element) =>
                    element['id_estacion'] == location['id_estacion'])
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  bool isFavorite = favorites.any((element) =>
                      element['id_estacion'] == location['id_estacion']);
                  return SizedBox(
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                              "Estacion ${location['Estacion']}- Municipio ${location['Municipio']}"),
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.grey,
                            ),
                            onPressed: () {
                              _toggleFavorite(
                                  location['id_estacion'].toString());
                              Navigator.pop(context); // Close the bottom sheet
                            },
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        }),
      );
    });
  }

  void _updateCameraPosition() {
    mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(currentLatitude, currentLongitude),
          zoom: zoomlevel,
        ),
      ),
    );
  }

  void _toggleFavorite(String idEstacion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favIds = prefs.getStringList('favorites') ?? [];
    if (favIds.contains(idEstacion)) {
      favIds.remove(idEstacion);
      if (favIds.isEmpty) {
        await prefs.setString('estacionActual', "");
      }
    } else {
      favIds.add(idEstacion);
      if (favIds.length == 1) {
        await prefs.setString('estacionActual', favIds[0]);
        final DateTime currentDate = DateTime.now();
        String day = currentDate.day.toString();
        String month = currentDate.month.toString();
        String year = currentDate.year.toString();
        fetchDataGrafica(
            day, month, year, 'grafica_temperatura', 'GRAFICA_TEMPERATURA');
        fetchDataGrafica(
            day, month, year, 'grafica_precipitacion', 'GRAFICA_PRECIPITACION');
        fetchDataGrafica(
            day, month, year, 'grafica_humedad', 'GRAFICA_HUMEDAD');
        fetchDataGrafica(
            day, month, year, 'grafica_radiacion', 'GRAFICA_RADIACION');
        fetchDataGrafica(day, month, year, 'grafica_viento', 'GRAFICA_VIENTO');
      }
    }
    await prefs.setStringList('favorites', favIds);
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favIds = prefs.getStringList('favorites') ?? [];
    List<Map<String, dynamic>> updatedFavorites = widget.locations
        .where((element) => favIds.contains(element['id_estacion'].toString()))
        .toList();
    setState(() {
      favorites = updatedFavorites;
      _updateMarkers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => const AppWithDrawer(
              content: ListPage(),
            ),
          ),
          (route) => false,
        );
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Mapa de Estaciones"),
          backgroundColor: lightGreen,
        ),
        body: GoogleMap(
          initialCameraPosition: CameraPosition(
            target: LatLng(
              currentLatitude,
              currentLongitude,
            ),
            zoom: zoomlevel,
          ),
          markers: markers,
          onMapCreated: (GoogleMapController controller) {
            mapController = controller;
          },
        ),
      ),
    );
  }
}
