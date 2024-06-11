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
    double imageSize = screenWidth * 0.25;
    double fontSize = screenWidth * 0.08;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreen),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: darkGreen,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: screenHeight * 0.25,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: darkGreen,
                ),
                child: InkWell(
                  onTap: () {},
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset(
                        'lib/assets/logo2.jpeg',
                        width: imageSize,
                        height: imageSize,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            ListTile(
              title: Row(
                children: [
                  Text(
                    'Estaciones',
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
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
                  Text(
                    'Lista Estaciones',
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
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
                  Text(
                    'Tiempo Real',
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
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
                  Text(
                    'Detalles apps',
                    style: TextStyle(color: Colors.white, fontSize: fontSize),
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
