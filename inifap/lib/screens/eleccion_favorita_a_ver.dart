import 'package:flutter/material.dart';
import 'package:inifap/screens/estacion_resumen_real.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inifap/datos/datos.dart';
import 'package:inifap/widgets/colors.dart';

class EleccionFavoritaAVer extends StatefulWidget {
  const EleccionFavoritaAVer({super.key});

  @override
  State createState() => _EleccionFavoritaAVerState();
}

class _EleccionFavoritaAVerState extends State<EleccionFavoritaAVer> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> filteredFavorites = [];
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> originalData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    originalData = List.from(datosEstacions);
    _loadFavorites();
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<Map<String, dynamic>> dummyListData = [];
      for (var item in originalData) {
        if (item['Municipio'].toLowerCase().contains(query.toLowerCase()) ||
            item['Estacion'].toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      }
      setState(() {
        filteredFavorites = dummyListData
            .where((element) => favorites.contains(element))
            .toList();
      });
    } else {
      setState(() {
        filteredFavorites = List.from(favorites);
      });
    }
  }

  void _loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Set<String> favTitles = prefs.getStringList('favorites')?.toSet() ?? {};
    setState(() {
      favorites = originalData
          .where((element) => favTitles.contains(element['id_estacion'].toString()))
          .toList();
      filteredFavorites = List.from(favorites);
    });
  }

  void _addToFavorites(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String idStr = id.toString();
    Set<String> favTitles = prefs.getStringList('favorites')?.toSet() ?? {};
    if (favTitles.contains(idStr)) {
      favTitles.remove(idStr);
    } else {
      favTitles.add(idStr);
    }
    await prefs.setStringList('favorites', favTitles.toList());
    _loadFavorites();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _buildScreenContent(),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkGreen,
        currentIndex: _currentIndex,
        selectedItemColor: lightGreen,
        onTap: _selectTab,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.info),
            label: 'Detalles',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent() {
    if (_currentIndex == 0) {
      return const EstacionResumenReal(); // Content for 'Detalles' tab
    } else {
      return _buildFavoritesScreen(); // Content for 'Favoritos' tab
    }
  }

  Widget _buildFavoritesScreen() {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
        const Text(
          'Lista de estaciones',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
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
              labelText: "Buscar estación...",
              hintText: "Buscar estación...",
              prefixIcon: const Icon(Icons.search),
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(20.0)),
                borderSide: BorderSide(color: darkGreen),
              ),
            ),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFavorites.length,
            itemBuilder: (context, index) {
              final stationName =
                  "Estacion: ${filteredFavorites[index]['Estacion']}-Municipio: ${filteredFavorites[index]['Municipio']}";
              return buildFavoriteStationCard(
                  stationName, filteredFavorites[index]['id_estacion']);
            },
          ),
        ),
      ],
    );
  }

  Widget buildFavoriteStationCard(String stationName, int id) {
    return Card(
      color: lightGreen,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(
          stationName,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        onTap: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('estacionActual', id.toString());
          _navigateToDetails();
        },
      ),
    );
  }

  void _selectTab(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _navigateToDetails() {
    // Navigate to 'Detalles' tab (index 0)
   
    _selectTab(0);
  }
}
