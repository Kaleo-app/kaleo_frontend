import 'package:flutter/material.dart';

class AppFooter extends StatelessWidget {
  final EdgeInsetsGeometry padding;
  final String text;

  const AppFooter({super.key, this.padding = const EdgeInsets.all(16), this.text = 'Kaleo • Construyendo acceso a oportunidades'});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      ),
    );
  }
}


