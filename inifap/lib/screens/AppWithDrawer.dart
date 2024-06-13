import 'package:flutter/material.dart';
import 'package:inifap/screens/AppDetailsPage.dart';
import 'package:inifap/screens/EleccionFavoritaAVer.dart';
import 'package:inifap/screens/Resumen_Real_or_Yesterday.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';

class AppWithDrawer extends StatefulWidget {
  final Widget content;

  const AppWithDrawer({super.key, required this.content});

  @override
  _AppWithDrawerState createState() => _AppWithDrawerState();
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
      return 'Detalles apps';
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
                decoration: BoxDecoration(
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
                  SizedBox(
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
                  SizedBox(
                      width: 8), // Add some space between the icon and text
                  Flexible(
                    child: Text(
                      'Lista Estaciones',
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
                  SizedBox(
                      width: 8), // Add some space between the icon and text
                  Flexible(
                    child: Text(
                      'Tiempo Real',
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
                  Image.asset(
                    'lib/assets/favicon.ico',
                    width: faviconSize,
                    height: faviconSize,
                    fit: BoxFit.contain,
                  ),
                  SizedBox(
                      width: 8), // Add some space between the icon and text
                  Flexible(
                    child: Text(
                      'Detalles apps',
                      style: TextStyle(color: darkGreen, fontSize: fontSize),
                    ),
                  ),
                ],
              ),
              onTap: () {
                _updateContent(const AppDetailsPage());
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
                  SizedBox(width: 8),
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
