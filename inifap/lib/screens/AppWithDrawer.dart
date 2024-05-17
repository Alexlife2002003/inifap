import 'package:flutter/material.dart';
import 'package:inifap/screens/AppDetailsPage.dart';
import 'package:inifap/screens/EleccionFavoritaAVer.dart';
import 'package:inifap/screens/Resumen_Real_or_Yesterday.dart';
import 'package:inifap/screens/listPage.dart';
import 'package:inifap/widgets/Colors.dart';

class AppWithDrawer extends StatefulWidget {
  final Widget content;

  const AppWithDrawer({required this.content});

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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: lightGreen,
        elevation: 0,
        iconTheme: IconThemeData(color: darkGreen),
        title: Text(
          title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: darkGreen,
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 180,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: darkGreen,
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
                _updateContent(EleccionFavoritaAVer());
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
                _updateContent(ListPage());
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
                _updateContent(ResumenRealOrYesterday());
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
                _updateContent(AppDetailsPage());
              },
            ),
          ],
        ),
      ),
      body: widget.content,
    );
  }
}
