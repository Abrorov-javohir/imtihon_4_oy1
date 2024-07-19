import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';

class ChangeTheme extends StatefulWidget {
  const ChangeTheme({super.key});

  @override
  State<ChangeTheme> createState() => _ChangeThemeState();
}

class _ChangeThemeState extends State<ChangeTheme> {
  bool isDarkMode = false;

  @override
  void initState() {
    super.initState();
    AdaptiveTheme.getThemeMode().then((mode) {
      setState(() {
        isDarkMode = mode == AdaptiveThemeMode.dark;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tungi va kungi rejmi"),
      ),
      body: SwitchListTile(
        title: const Text("Tungi va kungi rejmi"),
        value: isDarkMode,
        onChanged: (bool value) {
          setState(() {
            isDarkMode = value;
          });
          if (value) {
            AdaptiveTheme.of(context).setDark();
          } else {
            AdaptiveTheme.of(context).setLight();
          }
        },
      ),
    );
  }
}
