import 'package:flutter/material.dart';

class AppStructureDemo extends StatefulWidget {
  const AppStructureDemo({super.key});

  @override
  State<AppStructureDemo> createState() => _AppStructureDemoState();
}

class _AppStructureDemoState extends State<AppStructureDemo> {
  bool isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      // Theme khi ở Light Mode
      theme: ThemeData(
        brightness: Brightness.light,
        useMaterial3: true,
      ),

      // Theme khi ở Dark Mode
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        useMaterial3: true,
      ),

      // Chọn theme dựa vào isDarkMode
      themeMode: isDarkMode ? ThemeMode.dark : ThemeMode.light,

      home: Scaffold(
        appBar: AppBar(
          title: const Text('EX4'),

          // Switch bật/tắt Dark Mode
          actions: [
            const Text('Dark'),

            Switch(
              value: isDarkMode,
              onChanged: (value) {
                setState(() {
                  isDarkMode = value;
                });
              },
            ),
          ],
        ),

        body: const Center(
          child: Text(
            'This is a simple screen with theme toggle.',
          ),
        ),

        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('FAB clicked');
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }
}