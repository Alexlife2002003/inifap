import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:inifap/screens/AppWithDrawer.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen2 extends StatefulWidget {
  final List<Map<String, dynamic>> locations;

  const MapScreen2({Key? key, required this.locations}) : super(key: key);

  @override
  _MapScreen2State createState() => _MapScreen2State();
}

class _MapScreen2State extends State<MapScreen2> {
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
                  return Container(
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

  void _toggleFavorite(String idEstacion) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favIds = prefs.getStringList('favorites') ?? [];
    if (favIds.contains(idEstacion)) {
      favIds.remove(idEstacion); // Remove from favorites
    } else {
      favIds.add(idEstacion); // Add to favorites
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
      _updateMarkers(); // Update markers to reflect favorites
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
