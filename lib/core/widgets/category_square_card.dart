
import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';

class CategorySquareCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;
  final bool isSelected; // 👈 Nuevo parámetro

  const CategorySquareCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
    this.isSelected = false, // 👈 Por defecto no seleccionado
  });

  @override
  Widget build(BuildContext context) {
    final fg = color.computeLuminance() > 0.5 ? AppColors.textPrimary : Colors.white;

    // Estilos dinámicos según el estado
    final bgColor = isSelected ? color.withOpacity(0.15) : AppColors.surface;
    final borderColor = isSelected ? color : AppColors.textLight.withOpacity(0.2);
    final iconBgColor = isSelected ? color : color.withOpacity(0.15);
    final iconColor = isSelected ? Colors.white : color;
    final textColor = isSelected ? color : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: iconBgColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: iconColor),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: textColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/*
import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';

class CategorySquareCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback? onTap;

  const CategorySquareCard({
    super.key,
    required this.icon,
    required this.label,
    required this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final fg = color.computeLuminance() > 0.5 ? AppColors.textPrimary : Colors.white;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        height: 72,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.textLight.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: color),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: const TextStyle(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


*/