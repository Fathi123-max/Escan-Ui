import 'package:escan_ui/custom_widgets/siginin.dart';
import 'package:escan_ui/custom_widgets/sitting_page.dart';
import 'package:flutter/material.dart';

import 'fav_screen.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: <Widget>[
          const UserAccountsDrawerHeader(
            accountName: Text("John Doe"),
            accountEmail: Text("johndoe@example.com"),
            currentAccountPicture: CircleAvatar(
              backgroundImage: NetworkImage("https://i.pravatar.cc/300"),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text("My Profile"),
            onTap: () {
              // Handle profile tap

              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const SignInDemo()));
            },
          ),
          const SettingsTile(),
          ListTile(
            leading: const Icon(Icons.favorite),
            title: const Text("MyProperts"),
            onTap: () {
              // Handle settings tap
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => const FavoritesPage()));
            },
          ),
          ListTile(
            leading: const Icon(Icons.power_settings_new),
            title: const Text("Logout"),
            onTap: () {
              // Handle logout tap
            },
          ),
        ],
      ),
    );
  }
}
