import 'package:flutter/material.dart';
import 'package:inifap/backend/fetchData.dart';
import 'package:inifap/screens/HomeScreen.dart';
import 'package:inifap/screens/Resumen_Real_or_Yesterday.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Inifap',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    ListPage(),
    const ResumenRealOrYesterday(),
    GraphScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: darkGreen,
        currentIndex: _currentIndex,
        selectedItemColor: lightGreen,
        unselectedItemColor: Colors.grey.shade500,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: darkGreen,
            icon: const Icon(Icons.sunny_snowing),
            label: 'Estaciones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.list),
            label: 'Lista Estaciones',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.access_time),
            label: 'Tiempo real',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.open_with_rounded),
            label: 'Other',
          ),
        ],
      ),
    );
  }
}

class GraphScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Other'),
    );
  }
}
