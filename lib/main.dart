import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/chart_screen.dart';
import 'screens/camera_screen.dart';
import 'screens/servo_control_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Akıllı Tarım Uygulaması',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    ChartScreen(),
    CameraScreen(),
    ServoControlScreen(),
  ];

  final List<String> _titles = const [
    "Veriler",
    "Grafik",
    "Kamera",
    "Yön Kontrol",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_titles[_currentIndex])),
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: "Veriler",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.show_chart),
            label: "Grafik",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.videocam), label: "Kamera"),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings_remote),
            label: "Kontrol",
          ),
        ],
      ),
    );
  }
}
