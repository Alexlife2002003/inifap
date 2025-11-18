import 'dart:async';
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
  final TextEditingController searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    originalData = List.from(datosEstacions);
    _loadFavorites();
    searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Debounce to avoid filtering on every keystroke
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      filterSearchResults(searchController.text);
    });
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      final q = query.toLowerCase().trim();
      final matches = originalData.where((item) {
        final muni = (item['Municipio'] ?? '').toString().toLowerCase();
        final est = (item['Estacion'] ?? '').toString().toLowerCase();
        return muni.contains(q) || est.contains(q);
      }).toList();

      setState(() {
        filteredFavorites = matches.where((e) => favorites.contains(e)).toList();
      });
    } else {
      setState(() {
        filteredFavorites = List.from(favorites);
      });
    }
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favTitles = prefs.getStringList('favorites')?.toSet() ?? {};
    setState(() {
      favorites = originalData
          .where((e) => favTitles.contains(e['id_estacion'].toString()))
          .toList();
      filteredFavorites = List.from(favorites);
    });
  }

  Future<void> _refreshFavorites() async {
    await _loadFavorites();
    filterSearchResults(searchController.text);
  }

  void _selectTab(int index) {
    setState(() => _currentIndex = index);
  }

  void _navigateToDetails() {
    _selectTab(0);
  }

  Future<void> _openStation(int id) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('estacionActual', id.toString());
    _navigateToDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: _buildScreenContent(),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: _selectTab,
        height: 64,
        elevation: 0,
        backgroundColor: Colors.white,
        indicatorColor: lightGreen.withOpacity(0.25),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.info_outline),
            selectedIcon: Icon(Icons.info),
            label: 'Detalles',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_outline),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }

  Widget _buildScreenContent() {
    if (_currentIndex == 0) {
      return const EstacionResumenReal();
    } else {
      return _FavoritesView(
        count: filteredFavorites.length,
        onRefresh: _refreshFavorites,
        header: _FancyHeader(
          title: 'Estaciones favoritas',
          subtitle: 'Filtra por estación o municipio',
        ),
        searchBar: _SearchBarWidget(
          controller: searchController,
          onChanged: (v) => filterSearchResults(v),
        ),
        list: _buildFavoritesList(),
        empty: _EmptyState(
          title: 'Sin favoritos aún',
          message:
              'Agrega estaciones a favoritos para verlas aquí. Usa la búsqueda para encontrar una estación o municipio.',
          action: TextButton.icon(
            onPressed: () => _selectTab(0),
            icon: const Icon(Icons.explore),
            label: const Text('Ir a detalles'),
          ),
        ),
      );
    }
  }

  Widget _buildFavoritesList() {
    return ListView.separated(
      itemCount: filteredFavorites.length,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (context, i) {
        final item = filteredFavorites[i];
        final estacion = (item['Estacion'] ?? '').toString();
        final municipio = (item['Municipio'] ?? '').toString();
        final id = item['id_estacion'] as int;

        return _StationTile(
          title: estacion,
          subtitle: municipio,
          id: id,
          onTap: () => _openStation(id),
        );
      },
    );
  }
}

class _FancyHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _FancyHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 56, 20, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [darkGreen, darkGreen.withOpacity(0.75)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, 8),
          )
        ],
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
      ),
      child: Row(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(10),
            child: const Icon(Icons.star, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: .2,
                    )),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14,
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBarWidget extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  const _SearchBarWidget({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      transform: Matrix4.translationValues(0, -18, 0),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Material(
        elevation: 4,
        shadowColor: Colors.black.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: 'Buscar estación o municipio…',
            prefixIcon: const Icon(Icons.search),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
    );
  }
}

class _FavoritesView extends StatelessWidget {
  final int count;
  final Future<void> Function() onRefresh;
  final Widget header;
  final Widget searchBar;
  final Widget list;
  final Widget empty;

  const _FavoritesView({
    required this.count,
    required this.onRefresh,
    required this.header,
    required this.searchBar,
    required this.list,
    required this.empty,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: darkGreen,
      onRefresh: onRefresh,
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(child: header),
          SliverToBoxAdapter(
            child: Row(
              children: [
                const SizedBox(width: 16),
                _CountPill(count: count),
              ],
            ),
          ),
          SliverToBoxAdapter(child: searchBar),
          SliverToBoxAdapter(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              child: count == 0 ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: empty,
              ) : const SizedBox.shrink(),
            ),
          ),
          if (count > 0) SliverToBoxAdapter(child: list),
          const SliverPadding(padding: EdgeInsets.only(bottom: 24)),
        ],
      ),
    );
  }
}

class _CountPill extends StatelessWidget {
  final int count;
  const _CountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.favorite, size: 16, color: Colors.black54),
          const SizedBox(width: 6),
          Text('$count',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              )),
        ],
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final Widget? action;
  const _EmptyState({required this.title, required this.message, this.action});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          const SizedBox(height: 8),
          Icon(Icons.sentiment_dissatisfied, size: 40, color: Colors.black38),
          const SizedBox(height: 10),
          Text(title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
              )),
          const SizedBox(height: 6),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black54),
          ),
          if (action != null) ...[
            const SizedBox(height: 10),
            action!,
          ],
        ],
      ),
    );
  }
}

class _StationTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final int id;
  final VoidCallback onTap;

  const _StationTile({
    required this.title,
    required this.subtitle,
    required this.id,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          leading: Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: lightGreen.withOpacity(.25),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.location_on, color: Colors.black87),
          ),
          title: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          subtitle: Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Colors.black54),
          ),
          trailing: Icon(Icons.chevron_right, color: Colors.black.withOpacity(.6)),
        ),
      ),
    );
  }
}
