import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/constants/app_constants.dart';
import 'core/theme/app_theme.dart';
import 'providers/settings_provider.dart';
import 'providers/weather_provider.dart';
import 'screens/alerts/alerts_screen.dart';
import 'screens/assistant/assistant_screen.dart';
import 'screens/districts/districts_screen.dart';
import 'screens/home/home_screen.dart';
import 'screens/planner/planner_screen.dart';
import 'screens/settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final settingsProvider = SettingsProvider();
  await settingsProvider.load();

  final weatherProvider = WeatherProvider();
  await weatherProvider.refreshDistrict(
    settingsProvider.selectedDistrict,
    alertsEnabled: settingsProvider.alertsEnabled,
    uvThreshold: settingsProvider.uvThreshold,
  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: settingsProvider),
        ChangeNotifierProvider.value(value: weatherProvider),
      ],
      child: const WayraUvRootApp(),
    ),
  );
}

class WayraUvRootApp extends StatelessWidget {
  const WayraUvRootApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const MainNavigationShell(),
    );
  }
}

class MainNavigationShell extends StatefulWidget {
  const MainNavigationShell({super.key});

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _index = 0;

  static const List<Widget> _pages = [
    HomeScreen(),
    AssistantScreen(),
    PlannerScreen(),
    AlertsScreen(),
    DistrictsScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppConstants.appName)),
      body: IndexedStack(index: _index, children: _pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.wb_sunny_outlined), label: 'Monitor'),
          NavigationDestination(icon: Icon(Icons.health_and_safety_outlined), label: 'Asistente'),
          NavigationDestination(icon: Icon(Icons.event_available_outlined), label: 'Plan'),
          NavigationDestination(icon: Icon(Icons.notifications_outlined), label: 'Alertas'),
          NavigationDestination(icon: Icon(Icons.map_outlined), label: 'Distritos'),
          NavigationDestination(icon: Icon(Icons.info_outline), label: 'Info'),
        ],
      ),
    );
  }
}