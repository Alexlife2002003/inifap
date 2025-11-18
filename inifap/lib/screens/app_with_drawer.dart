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
  late String title;

  @override
  void initState() {
    super.initState();
    title = _getTitleForContent(widget.content);
  }

  String _getTitleForContent(Widget content) {
    if (content is ListPage) {
      return 'Lista estaciones';
    } else if (content is EleccionFavoritaAVer) {
      return 'Estaciones favoritas';
    } else if (content is ResumenRealOrYesterday) {
      return 'Datos en tiempo real';
    } else if (content is AppDetailsPage) {
      return 'Acerca de la app';
    } else if (content is MapScreen2) {
      return 'Mapa de estaciones';
    } else {
      return 'INIFAP Zacatecas';
    }
  }

  void _updateContent(Widget content) {
    Navigator.of(context).pop(); // cierra el drawer
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (_) => AppWithDrawer(content: content),
      ),
    );
  }

  bool _isCurrent(Widget screen) {
    return widget.content.runtimeType == screen.runtimeType;
  }

  @override
  Widget build(BuildContext context) {
    final filteredMarcadores = List<Map<String, dynamic>>.from(datosEstacions);
    final screenWidth = MediaQuery.of(context).size.width;

    final double faviconSize = screenWidth * 0.06;
    final double fontSize = screenWidth * 0.045;
    final double fontSizeTitle = screenWidth * 0.05;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: darkGreen,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: fontSizeTitle,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            _buildDrawerHeader(),
            const SizedBox(height: 4),
            _buildSectionLabel('Navegación'),
            _buildDrawerItem(
              label: 'Estaciones favoritas',
              icon: Image.asset(
                'lib/assets/favicon.ico',
                width: faviconSize,
                height: faviconSize,
                fit: BoxFit.contain,
              ),
              selected: _isCurrent(const EleccionFavoritaAVer()),
              onTap: () => _updateContent(const EleccionFavoritaAVer()),
              fontSize: fontSize,
            ),
            _buildDrawerItem(
              label: 'Mapa',
              icon: Image.asset(
                'lib/assets/favicon.ico',
                width: faviconSize,
                height: faviconSize,
                fit: BoxFit.contain,
              ),
              selected: _isCurrent(MapScreen2(locations: filteredMarcadores)),
              onTap: () => _updateContent(
                MapScreen2(locations: filteredMarcadores),
              ),
              fontSize: fontSize,
            ),
            _buildDrawerItem(
              label: 'Lista estaciones',
              icon: Image.asset(
                'lib/assets/favicon.ico',
                width: faviconSize,
                height: faviconSize,
                fit: BoxFit.contain,
              ),
              selected: _isCurrent(const ListPage()),
              onTap: () => _updateContent(const ListPage()),
              fontSize: fontSize,
            ),
            _buildDrawerItem(
              label: 'Tiempo real',
              // 🔙 volvemos a tu favicon como icono
              icon: Image.asset(
                'lib/assets/favicon.ico',
                width: faviconSize,
                height: faviconSize,
                fit: BoxFit.contain,
              ),
              selected: _isCurrent(const ResumenRealOrYesterday()),
              onTap: () => _updateContent(const ResumenRealOrYesterday()),
              fontSize: fontSize,
            ),
            const Divider(height: 24),
            _buildSectionLabel('Información'),
            _buildDrawerItem(
              label: 'Acerca de la app',
              icon: Icon(
                Icons.info_outline,
                size: faviconSize,
                color: darkGreen,
              ),
              selected: _isCurrent(const AppDetailsPage()),
              onTap: () => _updateContent(const AppDetailsPage()),
              fontSize: fontSize,
            ),
          ],
        ),
      ),
      body: widget.content,
    );
  }

 Widget _buildDrawerHeader() {
  return DrawerHeader(
    padding: EdgeInsets.zero,
    margin: EdgeInsets.zero,
    decoration: BoxDecoration(
      color: Colors.white,
      border: Border(
        bottom: BorderSide(
          color: lightGreen.withOpacity(0.7),
          width: 2,
        ),
      ),
    ),
    child: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // logo pequeño, sobre fondo blanco
          Image.asset(
            'lib/assets/logo.png',
            fit: BoxFit.contain,
            height: 52,
          ),
          const SizedBox(height: 8),
          Text(
            'INIFAP C.E. Zacatecas',
            style: TextStyle(
              color: darkGreen,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 2),
          Text(
            'Estaciones climatológicas',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}


  Widget _buildSectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
      child: Text(
        text.toUpperCase(),
        style: TextStyle(
          fontSize: 11,
          color: Colors.grey[600],
          fontWeight: FontWeight.w600,
          letterSpacing: 0.8,
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required String label,
    required Widget icon,
    required bool selected,
    required VoidCallback onTap,
    required double fontSize,
  }) {
    final bgColor =
        selected ? lightGreen.withOpacity(0.25) : Colors.transparent;
    final textColor = selected ? darkGreen : Colors.black87;

    return Material(
      color: bgColor,
      child: ListTile(
        leading: icon,
        title: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: fontSize,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
        dense: true,
        horizontalTitleGap: 10,
      ),
    );
  }
}
