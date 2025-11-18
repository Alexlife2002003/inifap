import 'package:flutter/material.dart';
import 'package:inifap/widgets/colors.dart';

class WeatherCardViento extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? max;
  final String? min;
  final String? avg;

  const WeatherCardViento({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
    this.max,
    this.min,
    this.avg,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Colors.blue[700];

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: lightGreen.withOpacity(0.9),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ICONO AZUL EN CÍRCULO BLANCO
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: iconColor,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            // TEXTO (EXPANDED)
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: darkGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (max != null && max!.isNotEmpty) ...[
                    _extraLine(max!),
                  ],
                  if (min != null && min!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    _extraLine(min!),
                  ],
                  if (avg != null && avg!.isNotEmpty) ...[
                    const SizedBox(height: 3),
                    _extraLine(avg!),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _extraLine(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        color: Colors.black87,
      ),
      softWrap: true,
    );
  }
}
