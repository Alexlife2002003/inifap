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

  const WeatherCard({
    super.key,
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
                Flexible(
                  child: Row(
                    children: [
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                label,
                                style: TextStyle(
                                  fontSize: screenWidth * 0.045,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                value,
                                style: TextStyle(fontSize: screenWidth * 0.04),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 15),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                'Resumen registrado:',
                                style: TextStyle(
                                  fontSize: screenWidth * 0.04,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            if (max != null)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  max!,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.035),
                                ),
                              ),
                            if (min != null)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  min!,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.035),
                                ),
                              ),
                            if (avg != null)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  avg!,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.035),
                                ),
                              ),
                            if (total != null)
                              FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  total!,
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.035),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
