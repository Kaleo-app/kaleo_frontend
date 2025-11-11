import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/core/widgets/web_main_navbar.dart';
import 'package:kaleo_frontend/features/demo/presentation/screens/demo_list_screen.dart';
import 'package:kaleo_frontend/features/info/presentation/screens/about_screen.dart';
import 'package:kaleo_frontend/features/results/presentation/screens/results_screen.dart';

class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DemoListScreen(onTabChanged: _onTabChanged),
      ResultsScreen(onTabChanged: _onTabChanged),
      AboutScreen(onTabChanged: _onTabChanged),
    ];
  }

  void _onTabChanged(int index) {
    setState(() {
      _index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // Detectar si es web y pantalla ancha
    final bool isWeb = identical(0, 0.0);
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isWideWeb = isWeb && screenWidth > 800;

    return Scaffold(
      body: IndexedStack(index: _index, children: _pages),
      // Navegación inferior solo para móvil
      bottomNavigationBar: isWideWeb ? null : NavigationBar(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withOpacity(0.12),
        selectedIndex: _index,
        onDestinationSelected: (i) => setState(() => _index = i),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Inicio',
          ),
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            selectedIcon: Icon(Icons.view_list_rounded),
            label: 'Resultados',
          ),
          NavigationDestination(
            icon: Icon(Icons.info_outline_rounded),
            selectedIcon: Icon(Icons.info_rounded),
            label: 'Acerca de',
          ),
        ],
      ),
    );
  }
}


