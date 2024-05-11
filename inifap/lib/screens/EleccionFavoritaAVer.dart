import 'package:flutter/material.dart';
import 'package:inifap/screens/EstacionResumenReal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inifap/datos/Datos.dart';
import 'package:inifap/widgets/Colors.dart';

class EleccionFavoritaAVer extends StatefulWidget {
  @override
  _EleccionFavoritaAVerState createState() => _EleccionFavoritaAVerState();
}

class _EleccionFavoritaAVerState extends State<EleccionFavoritaAVer> {
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> originalData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    print("entered");
    originalData = List.from(estaciones);
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  @override
  void didUpdateWidget(covariant EleccionFavoritaAVer oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Add logic here to handle updates when the widget is rebuilt
    _loadFavorites();
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favTitles = prefs.getStringList('favorites') ?? [];
    setState(() {
      favorites = originalData
          .where((element) => favTitles.contains(element['titulo']))
          .toList();
    });
   
  }

  void filterSearchResults(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favTitles = prefs.getStringList('favorites') ?? [];
    List<Map<String, dynamic>> filteredList = originalData
        .where((element) =>
            element['titulo'].toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      favorites = filteredList
          .where((element) => favTitles.contains(element['titulo']))
          .toList();
    });
     if (favorites.length == 1) {
      setState(() {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => EstacionResumenReal()),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de Estaciones Favoritas"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Buscar estación...",
                hintText: "Buscar estación...",
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: darkGreen),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: favorites.length,
              itemBuilder: (context, index) {
                final stationName = favorites[index]['titulo'];
                return buildFavoriteStationCard(stationName);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFavoriteStationCard(String stationName) {
    return Card(
      color: lightGreen,
      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          stationName,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('estacionActual', stationName);
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => EstacionResumenReal()),
          );
          print('Tapped on station: $stationName');
        },
      ),
    );
  }
}
