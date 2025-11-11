import 'package:flutter/material.dart';

/// Widget para mostrar el logo de Kaleo en forma circular
class CircularLogo extends StatelessWidget {
  final double size;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;

  const CircularLogo({
    super.key,
    this.size = 60.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor,
        border: borderColor != null
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipOval(
        child: Image.asset(
          'logo.jpg',
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            // Fallback si no se puede cargar la imagen
            return Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.business,
                color: Colors.grey,
                size: 30,
              ),
            );
          },
        ),
      ),
    );
  }
}
