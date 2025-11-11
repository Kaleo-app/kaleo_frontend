import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';

class WebCategoryNavbar extends StatelessWidget {
  final String? selectedCategory;
  final Function(String) onCategorySelected;

  const WebCategoryNavbar({
    super.key,
    this.selectedCategory,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final categories = [
      _CategoryData(
        name: 'Becas',
        icon: Icons.school_rounded,
        color: const Color(0xFF3B82F6),
      ),
      _CategoryData(
        name: 'Empleo',
        icon: Icons.work_rounded,
        color: const Color(0xFF10B981),
      ),
      _CategoryData(
        name: 'Investigación',
        icon: Icons.biotech_rounded,
        color: const Color(0xFF8B5CF6),
      ),
      _CategoryData(
        name: 'Voluntariado',
        icon: Icons.volunteer_activism_rounded,
        color: const Color(0xFFEF4444),
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: categories.map((category) {
          final isSelected = selectedCategory == category.name;
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: _CategoryNavItem(
              category: category,
              isSelected: isSelected,
              onTap: () => onCategorySelected(
                isSelected ? '' : category.name,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _CategoryNavItem extends StatelessWidget {
  final _CategoryData category;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryNavItem({
    required this.category,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected 
              ? category.color.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          border: isSelected
              ? Border.all(color: category.color.withOpacity(0.3), width: 1)
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              category.icon,
              size: 20,
              color: isSelected ? category.color : Colors.grey[600],
            ),
            const SizedBox(width: 8),
            Text(
              category.name,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                color: isSelected ? category.color : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryData {
  final String name;
  final IconData icon;
  final Color color;

  const _CategoryData({
    required this.name,
    required this.icon,
    required this.color,
  });
}
