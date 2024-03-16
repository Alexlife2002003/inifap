import 'package:flutter/material.dart';
import 'package:inifap/widgets/Colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inifap/datos/Datos.dart';

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

  @override
  Widget build(BuildContext context) {
    List<Widget> listTiles = [];
    listTiles.addAll(favorites.map((fav) {
      return ListTile(
        tileColor: lightGreen,
        title: Text(fav['titulo']),
        trailing: IconButton(
          icon: Icon(Icons.favorite),
          color: Colors.red,
          onPressed: () {
            _addToFavorites(filteredMarcadores
                .indexWhere((element) => element['titulo'] == fav['titulo']));
          },
        ),
        // You can add onTap functionality here
      );
    }));
    listTiles.addAll(filteredMarcadores
        .where((item) => !favorites.contains(item))
        .map((item) {
      return ListTile(
        tileColor: lightGreen,
        title: Text(item['titulo']),
        trailing: IconButton(
          icon: Icon(Icons.favorite_border),
          onPressed: () {
            _addToFavorites(filteredMarcadores
                .indexWhere((element) => element['titulo'] == item['titulo']));
          },
        ),
        // You can add onTap functionality here
      );
    }));

    return Scaffold(
      appBar: AppBar(
        title: Text("Lista de estaciones"),
        backgroundColor: lightGreen,
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
                prefixIcon: Icon(
                  Icons.search,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(25.0)),
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
