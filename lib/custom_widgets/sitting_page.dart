import 'package:escan_ui/screens/home_page_screen.dart';
import 'package:flutter/material.dart';

class SettingsTile extends StatelessWidget {
  const SettingsTile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(Icons.dark_mode),
      title: const Text('Dark mode'),
      trailing: Switch(
        value: Theme.of(context).brightness == Brightness.dark,
        onChanged: (value) {
          final Brightness newBrightness =
              value ? Brightness.dark : Brightness.light;
          final ThemeData newTheme = Theme.of(context).copyWith(
            brightness: newBrightness,
          );
          MaterialApp themeApp = MaterialApp(
            title: "Material App",
            theme: newTheme,
            debugShowCheckedModeBanner: false,
            home: HomePageScreen(),
          );
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => themeApp));
        },
      ),
    );
  }
}
