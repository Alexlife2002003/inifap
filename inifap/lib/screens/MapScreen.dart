import "package:flutter/material.dart";
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MapScreen extends StatefulWidget {
  final List<Map<String, dynamic>> locations;

  const MapScreen({Key? key, required this.locations}) : super(key: key);

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Map<String, dynamic>> favorites = [];

  @override
  void initState() {
    super.initState();
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
    setState(() {
      favorites = widget.locations
          .where((element) => favTitles.contains(element['titulo']))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(
            builder: (context) => ListPage(),
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
          initialCameraPosition: const CameraPosition(
            target: LatLng(23.6260, -102.5375), // Center of Mexico
            zoom: 5.0, // Initial zoom level
          ),
          markers: Set<Marker>.of(widget.locations.map((location) {
            return Marker(
              markerId: MarkerId(location['titulo']),
              position: LatLng(
                location['position']['lat'],
                location['position']['lng'],
              ),
              icon: favorites
                      .any((element) => element['titulo'] == location['titulo'])
                  ? BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueBlue) // Blue marker for favorites
                  : BitmapDescriptor.defaultMarkerWithHue(
                      BitmapDescriptor.hueRed), // Red marker for others
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
                            Text(location['titulo']),
                            IconButton(
                              icon: Icon(
                                favorites.any((element) =>
                                        element['titulo'] == location['titulo'])
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                              ),
                              onPressed: () {
                                _addToFavorites(location['titulo']);
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
          })),
        ),
      ),
    );
  }
}
