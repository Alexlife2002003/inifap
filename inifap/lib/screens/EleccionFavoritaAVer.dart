import 'package:flutter/material.dart';
import 'package:inifap/main.dart';
import 'package:inifap/screens/AppWithDrawer.dart';
import 'package:inifap/screens/EstacionResumenReal.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:inifap/datos/Datos.dart';
import 'package:inifap/widgets/Colors.dart';

class EleccionFavoritaAVer extends StatefulWidget {
  @override
  _EleccionFavoritaAVerState createState() => _EleccionFavoritaAVerState();
}

class _EleccionFavoritaAVerState extends State<EleccionFavoritaAVer> {
  int _currentIndex = 0;
  List<Map<String, dynamic>> favorites = [];
  List<Map<String, dynamic>> originalData = [];
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadFavorites();
    originalData = List.from(estaciones);
    searchController.addListener(() {
      filterSearchResults(searchController.text);
    });
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
  }

  @override
  Widget build(BuildContext context) {
    return AppWithDrawer(
      content: Scaffold(
     
        body: _buildScreenContent(),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: darkGreen,
          currentIndex: _currentIndex,
          selectedItemColor: lightGreen,
          onTap: _selectTab,
          items: [
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
      ),
    );
  }

  Widget _buildScreenContent() {
    if (_currentIndex == 0) {
      return EstacionResumenReal(); // Content for 'Detalles' tab
    } else {
      return _buildFavoritesScreen(); // Content for 'Favoritos' tab
    }
  }

  Widget _buildFavoritesScreen() {
    return Column(
      children: [
        SizedBox(
          height: 40,
        ),
        Text(
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
              prefixIcon: Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(20.0)),
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
        onTap: () {
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

class EleccionFavoritaAVerNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Navigator(
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => EleccionFavoritaAVer(),
        );
      },
    );
  }
}
