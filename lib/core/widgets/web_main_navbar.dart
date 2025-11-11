import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';

class WebMainNavbar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChanged;

  const WebMainNavbar({
    super.key,
    required this.currentIndex,
    required this.onTabChanged,
  });

  @override
  Widget build(BuildContext context) {
    final tabs = [
      _TabData(
        icon: Icons.home_rounded,
        label: 'Inicio',
        index: 0,
      ),
      _TabData(
        icon: Icons.view_list_rounded,
        label: 'Resultados',
        index: 1,
      ),
      _TabData(
        icon: Icons.info_rounded,
        label: 'Acerca de',
        index: 2,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: tabs.map((tab) {
          final isSelected = currentIndex == tab.index;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _NavItem(
              tab: tab,
              isSelected: isSelected,
              onTap: () => onTabChanged(tab.index),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final _TabData tab;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.tab,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        hoverColor: AppColors.primary.withOpacity(0.05),
        splashColor: AppColors.primary.withOpacity(0.1),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: isSelected 
                ? AppColors.primary.withOpacity(0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
            border: isSelected
                ? Border.all(color: AppColors.primary.withOpacity(0.3), width: 1)
                : null,
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                tab.icon,
                size: 20,
                color: isSelected ? AppColors.primary : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                tab.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.primary : Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabData {
  final IconData icon;
  final String label;
  final int index;

  const _TabData({
    required this.icon,
    required this.label,
    required this.index,
  });
}
