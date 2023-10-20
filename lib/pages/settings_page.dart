import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool useSystemTheme = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('SettingsPage'),
        ),
        body: ListView(
          children: [
            ListTile(
              title: const Text("Use system theme"),
              trailing: Switch(
                value: useSystemTheme,
                onChanged: (value) {
                  setState(() {
                    useSystemTheme = value;
                  });
                },
              ),
            ),
            _buildCustomTheme(),
          ],
        ));
  }

  Widget _buildCustomTheme() {
    if (!useSystemTheme) {
      return const SizedBox.shrink();
    }
    return ListTile(
        title: const Text('Theme'),
        trailing: Switch(
          value: false,
          onChanged: (value) {
            Get.changeTheme(value ? ThemeData.dark() : ThemeData.light());
          },
        ));
  }
}
