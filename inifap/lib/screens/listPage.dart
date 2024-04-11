import 'package:flutter/material.dart';
import 'package:inifap/screens/MapScreen.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:inifap/datos/Datos.dart';
import 'package:inifap/widgets/Colors.dart';


class ListPage extends StatefulWidget {
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
    originalData = List.from(estaciones);
    filteredMarcadores = List.from(estaciones);
    _loadFavorites();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      originalData.forEach((item) {
        if (item['titulo'].toLowerCase().contains(query.toLowerCase())) {
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
          .where((element) => favTitles.contains(element['titulo']))
          .toList();
    });
  }

  void _addToFavorites(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String title = filteredMarcadores[index]['titulo'];
    List<String> favTitles = prefs.getStringList('favorites') ?? [];
    if (favTitles.contains(title)) {
      favTitles.remove(title); // Remove from favorites
    } else {
      favTitles.add(title); // Add to favorites
    }
    await prefs.setStringList('favorites', favTitles);
    _loadFavorites();
  }

  void _openMapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => MapScreen(locations: filteredMarcadores)),
    );
    
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> listTiles = [];
    listTiles.addAll(favorites.map((fav) {
      return ListTile(
        tileColor: lightGreen,
        title: Text(fav['titulo']),
        trailing: IconButton(
          icon: const Icon(Icons.favorite),
          color: Colors.red,
          onPressed: () {
            _addToFavorites(filteredMarcadores
                .indexWhere((element) => element['titulo'] == fav['titulo']));
          },
        ),
      );
    }));
    listTiles.addAll(filteredMarcadores
        .where((item) => !favorites.contains(item))
        .map((item) {
      return ListTile(
        tileColor: lightGreen,
        title: Text(item['titulo']),
        trailing: IconButton(
          icon: const Icon(Icons.favorite_border),
          onPressed: () {
            _addToFavorites(filteredMarcadores
                .indexWhere((element) => element['titulo'] == item['titulo']));
          },
        ),
      );
    }));

    return Scaffold(
      appBar: AppBar(
        title: const Text("Lista de estaciones"),
        backgroundColor: lightGreen,
        actions: [
          IconButton(
            icon: const Icon(Icons.map),
            onPressed: _openMapScreen,
          ),
        ],
      ),
      backgroundColor: lightGreen,
      body: Column(
        children: <Widget>[
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
                    borderSide: BorderSide(color: darkGreen)),
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




void main() {
  runApp(MaterialApp(
    home: ListPage(),
  ));
}
