import 'package:escan_ui/common/controller.dart';
import 'package:escan_ui/properties/data/models/Houses_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  _FavoritesPageState createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<String> _favorites = [];

  @override
  void initState() {
    super.initState();
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _favorites = prefs.getStringList('favorites') ?? [];
    });
  }

  Future<void> _removeFavorite(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> favorites = prefs.getStringList('favorites') ?? [];

    if (favorites.contains(id)) {
      favorites.remove(id);
      prefs.setStringList('favorites', favorites);
      setState(() {
        _favorites.remove(id);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
      ),
      body: _favorites.isEmpty
          ? const Center(
              child: Text('No favorite houses'),
            )
          : ListView.builder(
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                String id = _favorites[index];
                return FutureBuilder<House?>(
                  future: HouseController().getHouseById(id),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      House house = snapshot.data!;
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                          title: Text(house.address ?? ''),
                          subtitle: Text('\$${house.amount.toString()}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _removeFavorite(house.id!);
                            },
                          ),
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return const Text('Error loading house information');
                    } else {
                      return const SizedBox(
                        height: 80,
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                  },
                );
              },
            ),
    );
  }
}
