import 'package:flutter/material.dart';
import 'package:kaleo_frontend/core/theme/app_colors.dart';

class DeadlineChip extends StatelessWidget {
  final DateTime? deadline;
  const DeadlineChip({super.key, required this.deadline});

  Color _colorForDeadline(DateTime? d) {
    if (d == null) return AppColors.textLight;
    final now = DateTime.now();
    final days = d.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (days < 0) return Colors.redAccent; // vencido
    if (days <= 3) return Colors.orangeAccent; // muy pronto
    if (days <= 14) return AppColors.accent; // próximo
    return AppColors.textSecondary; // lejano
  }

  String _labelForDeadline(DateTime? d) {
    if (d == null) return 'Sin fecha';
    final now = DateTime.now();
    final days = d.difference(DateTime(now.year, now.month, now.day)).inDays;
    if (days < 0) return 'Vencida';
    if (days == 0) return 'Hoy';
    if (days == 1) return 'Mañana';
    return 'En $days días';
  }

  @override
  Widget build(BuildContext context) {
    final color = _colorForDeadline(deadline);
    final label = _labelForDeadline(deadline);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.event, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}



