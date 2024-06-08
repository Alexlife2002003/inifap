import 'package:flutter/material.dart';
import 'package:inifap/widgets/Colors.dart';

class WeatherCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final String? max;
  final String? min;
  final String? avg;
  final String? total;

  const WeatherCard({super.key, 
    required this.icon,
    required this.label,
    required this.value,
    this.max,
    this.min,
    this.avg,
    this.total,
  });

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double cardWidth = screenWidth - 40;
    return Container(
      padding: const EdgeInsets.only(left: 16, bottom: 10),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10.0),
            width: cardWidth,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.grey,
                width: 1.0,
              ),
              borderRadius: BorderRadius.circular(10.0),
              color: lightGreen,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: Colors.blue,
                  size: 32.0,
                ),
                const SizedBox(width: 5.0),
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          style: const TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          value,
                          style: const TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                    const SizedBox(width: 15),
                    Column(
                      children: [
                        const Text(
                          'Resumen registrado:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (max != null) Text(max!),
                        if (min != null) Text(min!),
                        if (avg != null) Text(avg!),
                        if (total != null) Text(total!),
                      ],
                    )
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
