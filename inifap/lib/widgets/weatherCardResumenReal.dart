import 'package:flutter/material.dart';

class WeatherCardResumenReal extends StatelessWidget {
  final IconData icon;
  final String label;
  final String max;
  final String min;
  final String avg;
  final String precipitation; // Add precipitation field

  WeatherCardResumenReal({
    required this.icon,
    required this.label,
    required this.max,
    required this.min,
    required this.avg,
    required this.precipitation, // Add precipitation to constructor
  });

  @override
  Widget build(BuildContext context) {
    Color lightGreen = const Color(0xffE5EFE7);
    return Card(
      color: lightGreen,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    icon,
                    size: 40,
                    color: Colors.blue,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    label,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.blue,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.end, // Align children to the end
                children: [
                  _buildWeatherInfoRow("Max", max),
                  _buildWeatherInfoRow("Min", min),
                  _buildWeatherInfoRow("Avg", avg),
                  _buildWeatherInfoRow("Precipitation", precipitation), // Display precipitation
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeatherInfoRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(
              "$value°C",
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[800],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
