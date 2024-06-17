import 'package:flutter/material.dart';
import 'package:inifap/backend/fetch_data.dart';
import 'package:inifap/screens/map_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inifap/datos/datos.dart';
import 'package:inifap/widgets/colors.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  List<Map<String, dynamic>> filteredMarcadores = [];
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> originalData = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    originalData = List.from(datosEstacions);
    filteredMarcadores = List.from(datosEstacions);
    _loadFavorites();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      originalData.forEach((item) {
        if (item['Municipio'].toLowerCase().contains(query.toLowerCase()) ||
            item['Estacion'].toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        filteredMarcadores.clear();
        filteredMarcadores.addAll(dummyListData);
      });
      return;
    } else {
      setState(() {
        filteredMarcadores.clear();
        filteredMarcadores.addAll(originalData);
      });
    }
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> favTitles = prefs.getStringList('favorites') ?? [];
    setState(() {
      favorites = originalData
          .where((element) =>
              favTitles.contains(element['id_estacion'].toString()))
          .toList();
    });
    if (favorites.length == 1) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString('estacionActual', favTitles[0]);
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
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String temporal = prefs.getString('estacionActual') ?? "";
      if (!favTitles.contains(temporal)) {
        await prefs.setString('estacionActual', "");
      }
    }
  }

  void _addToFavorites(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = index.toString();
    List<String> favTitles = prefs.getStringList('favorites') ?? [];
    if (favTitles.contains(id)) {
      favTitles.remove(id); // Remove from favorites
    } else {
      favTitles.add(id); // Add to favorites
    }
    await prefs.setStringList('favorites', favTitles);
    _loadFavorites();
  }

  void _openMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => MapScreen(locations: filteredMarcadores)),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listTiles = [];
    listTiles.addAll(favorites.map((fav) {
      return ListTile(
        tileColor: lightGreen,
        title:
            Text("Estacion: ${fav['Estacion']}-Municipio: ${fav['Municipio']}"),
        trailing: IconButton(
          icon: const Icon(Icons.favorite),
          color: Colors.red,
          onPressed: () {
            _addToFavorites(fav['id_estacion']);
          },
        ),
      );
    }));
    listTiles.addAll(filteredMarcadores
        .where((item) => !favorites.contains(item))
        .map((item) {
      return ListTile(
        tileColor: lightGreen,
        title: Text(
            "Estacion: ${item['Estacion']}-Municipio: ${item['Municipio']}"),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            _addToFavorites(item['id_estacion']);
          },
        ),
      );
    }));

    return Scaffold(
      backgroundColor: lightGreen,
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(""),
                const Text(
                  "Lista de estaciones",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: const Icon(Icons.map),
                  onPressed: _openMapScreen,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onChanged: (value) {
                filterSearchResults(value);
              },
              controller: searchController,
              decoration: InputDecoration(
                labelText: "Search",
                hintText: "Search",
                prefixIcon: const Icon(
                  Icons.search,
                ),
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: darkGreen),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: listTiles,
            ),
          ),
        ],
      ),
    );
  }
}
