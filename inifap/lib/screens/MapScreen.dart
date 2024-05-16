import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> locations;

  const MapScreen({Key? key, required this.locations}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  Set<Marker> markers = {};
  double currentLatitude = 0.0;
  double currentLongitude = 0.0;
  double zoomlevel = 10.0;
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
    _loadFavorites();
  }

  void _getCurrentLocation() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    setState(() {
      currentLatitude = position.latitude;
      currentLongitude = position.longitude;
      zoomlevel = 10.0;
      _updateMarkers();
    });
  }

  void _updateMarkers() {
    setState(() {
      markers.clear();
      markers.add(
        Marker(
          markerId: MarkerId('currentLocation'),
          position: LatLng(currentLatitude, currentLongitude),
          icon:
              BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
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
            icon: favorites
                    .any((element) => element['id_estacion'] == location['id_estacion'])
                ? BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueGreen)
                : BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueBlue),
            onTap: () {
              showModalBottomSheet(
                context: context,
                builder: (BuildContext context) {
                  return Container(
                    height: 100,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Estacion ${location['Estacion']}- Municipio ${location['Municipio']}"),
                          IconButton(
                            icon: Icon(
                              favorites.any((element) =>
                                      element['id_estacion'] == location['id_estacion'])
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                            ),
                            onPressed: () {
                              _addToFavorites(location['id_estacion'].toString());
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

  void _addToFavorites(String title) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favTitles = prefs.getStringList('favorites') ?? [];
    if (favTitles.contains(title)) {
      favTitles.remove(title); // Remove from favorites
    } else {
      favTitles.add(title); // Add to favorites
    }
    await prefs.setStringList('favorites', favTitles);
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favTitles = prefs.getStringList('favorites') ?? [];
    List<Map<String, dynamic>> updatedFavorites = widget.locations
        .where((element) => favTitles.contains(element['titulo']))
        .toList();
    setState(() {
      favorites = updatedFavorites;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mapa de Estaciones"),
        backgroundColor: lightGreen,
      ),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: LatLng(
            currentLatitude != 0.0 ? currentLatitude : 22.7561951,
            currentLongitude != 0.0 ? currentLongitude : -102.4989123,
          ),
          zoom: zoomlevel,
        ),
        markers: markers,
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
      ),
    );
  }
}
