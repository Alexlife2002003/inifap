//////////////////////////////////////////////////////////////////////////////////////////////////////////////
//   Nombre:                          Equipo Tacos de asada                                                 //
//   Descripción:                     Cajon de la app                                                       //
//////////////////////////////////////////////////////////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:inifap/screens/AppDetailsPage.dart';
import 'package:inifap/screens/EleccionFavoritaAVer.dart';
import 'package:inifap/screens/Resumen_Real_or_Yesterday.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';

class AppWithDrawer extends StatelessWidget {
  final Widget content;

  const AppWithDrawer({required this.content});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreen), //rellenar
    
      ),
      drawer: Drawer(
        backgroundColor: darkGreen, //rellenar
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 180,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: darkGreen, //rellenar
                ),
                child: InkWell(
                  onTap: () {},
                  child: const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Inifap',
                        style: TextStyle(
                          color: Color(0xFFFFEDBD),
                          fontSize: 40,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      Divider(
                        color: Colors.white,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  const Text('Estaciones',
                      style: TextStyle(color: Colors.white, fontSize: 33)),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>EleccionFavoritaAVer()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Lista Estaciones',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ListPage()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Tiempo Real',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ResumenRealOrYesterday()));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  const Text(
                    'Detalles apps',
                    style: TextStyle(color: Colors.white, fontSize: 33),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AppDetailsPage()));
              },
            ),
 
          ],
        ),
      ),
      body: content,
    );
  }
}
