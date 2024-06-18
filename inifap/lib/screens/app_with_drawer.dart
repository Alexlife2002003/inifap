import 'package:flutter/material.dart';
import 'package:inifap/datos/datos.dart';
import 'package:inifap/screens/app_details_page.dart';
import 'package:inifap/screens/eleccion_favorita_a_ver.dart';
import 'package:inifap/screens/map_screen_2.dart';

import 'package:inifap/screens/resumen_real_or_yesterday.dart';
import 'package:inifap/screens/list_page.dart';
import 'package:inifap/widgets/colors.dart';

class AppWithDrawer extends StatefulWidget {
  final Widget content;

  const AppWithDrawer({super.key, required this.content});

  @override
  State createState() => _AppWithDrawerState();
}

class _AppWithDrawerState extends State<AppWithDrawer> {
  String title = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      title = _getTitleForContent(widget.content);
    });
  }

  String _getTitleForContent(Widget content) {
    if (content is ListPage) {
      return '';
    } else if (content is EleccionFavoritaAVer) {
      return 'Estaciones';
    } else if (content is ResumenRealOrYesterday) {
      return 'Datos en tiempo real';
    } else if (content is AppDetailsPage) {
      return 'Acerca de la app';
    } else if (content is MapScreen2) {
      return 'Mapa';
    } else {
      return 'Inifap';
    }
  }

  void _updateContent(Widget content) {
    setState(() {
      title = _getTitleForContent(content);
    });
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AppWithDrawer(content: content),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredMarcadores = List.from(datosEstacions);
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double headerImageSize = screenWidth * 0.25;
    double faviconSize = screenWidth * 0.06;
    double fontSize = screenWidth * 0.06;
    double fontSizeTitle = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreen),
        title: Text(
          title,
          style:
              TextStyle(fontWeight: FontWeight.bold, fontSize: fontSizeTitle),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: screenHeight * 0.25,
              child: DrawerHeader(
                decoration: const BoxDecoration(
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/logo.png',
                        width: headerImageSize,
                        height: headerImageSize,
                        fit: BoxFit.scaleDown,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'lib/assets/favicon.ico',
                    width: faviconSize,
                    height: faviconSize,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                      width: 8), // Add some space between the icon and text
                  Flexible(
                    child: Text(
                      'Estaciones',
                      style: TextStyle(color: darkGreen, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              onTap: () {
                _updateContent(const EleccionFavoritaAVer());
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'lib/assets/favicon.ico',
                    width: faviconSize,
                    height: faviconSize,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                      width: 8), // Add some space between the icon and text
                  Flexible(
                    child: Text(
                      'Mapa',
                      style: TextStyle(color: darkGreen, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              onTap: () {
                _updateContent(MapScreen2(locations: filteredMarcadores));
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'lib/assets/favicon.ico',
                    width: faviconSize,
                    height: faviconSize,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                      width: 8), // Add some space between the icon and text
                  Flexible(
                    child: Text(
                      'Lista estaciones',
                      style: TextStyle(color: darkGreen, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              onTap: () {
                _updateContent(const ListPage());
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Image.asset(
                    'lib/assets/favicon.ico',
                    width: faviconSize,
                    height: faviconSize,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(
                      width: 8), // Add some space between the icon and text
                  Flexible(
                    child: Text(
                      'Tiempo real',
                      style: TextStyle(color: darkGreen, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              onTap: () {
                _updateContent(const ResumenRealOrYesterday());
              },
            ),
            ListTile(
              title: Row(
                children: [
                  Icon(
                    Icons.info_outline,
                    size: faviconSize,
                    color: Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      'Acerca de la app',
                      style: TextStyle(color: darkGreen, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              onTap: () {
                _updateContent(const AppDetailsPage());
              },
            ),
          ],
        ),
      ),
      body: widget.content,
    );
  }
}
