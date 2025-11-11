import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';
import 'package:kaleo_frontend/features/home/presentation/screens/home_shell.dart';

/// Pantalla de bienvenida/onboarding de Kaleo
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<_WelcomePage> _pages = const [
    _WelcomePage(
      icon: Icons.search_rounded,
      title: 'Explora Oportunidades',
      subtitle: 'Descubre convocatorias y becas relevantes para ti',
    ),
    _WelcomePage(
      icon: Icons.notifications_active_rounded,
      title: 'Mantente Informado',
      subtitle: 'Recibe actualizaciones y no te pierdas ningún plazo',
    ),
    _WelcomePage(
      icon: Icons.star_rounded,
      title: 'Organiza tus Favoritos',
      subtitle: 'Guarda y compara lo que más te interesa',
    ),
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goNext() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(duration: const Duration(milliseconds: 350), curve: Curves.easeOut);
    } else {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeShell()));
    }
  }

  void _skip() {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => const HomeShell()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: _pages.length,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  itemBuilder: (context, index) {
                    final page = _pages[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Icon(page.icon, size: 60, color: AppColors.textWhite),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            page.title,
                            style: const TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textWhite,
                              letterSpacing: -0.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            page.subtitle,
                            style: TextStyle(
                              fontSize: 16,
                              color: AppColors.textWhite.withOpacity(0.9),
                              height: 1.5,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        final isActive = _currentPage == i;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: isActive ? 20 : 8,
                          decoration: BoxDecoration(
                            color: isActive ? Colors.white : Colors.white.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        TextButton(
                          onPressed: _skip,
                          child: const Text('Saltar'),
                          style: TextButton.styleFrom(foregroundColor: AppColors.textWhite),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _goNext,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.textWhite,
                            foregroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: Text(_currentPage == _pages.length - 1 ? 'Empezar' : 'Siguiente'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WelcomePage {
  final IconData icon;
  final String title;
  final String subtitle;

  const _WelcomePage({required this.icon, required this.title, required this.subtitle});
}


