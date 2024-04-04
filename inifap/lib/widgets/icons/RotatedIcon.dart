import 'package:flutter/material.dart';

class RotatedIcon extends StatelessWidget {
  final IconData icon;
  final double size;
  final String direction;

  RotatedIcon({required this.icon, required this.size, required this.direction});

  @override
  Widget build(BuildContext context) {
    double angle = 0;

    switch (direction) {
      case 'Norte':
        angle = 0;
        break;
      case 'NNE':
        angle = 22.5;
        break;
      case 'NE':
        angle = 45;
        break;
      case 'ENE':
        angle = 67.5;
        break;
      case 'Este':
        angle = 90;
        break;
      case 'ESE':
        angle = 112.5;
        break;
      case 'SE':
        angle = 135;
        break;
      case 'SSE':
        angle = 157.5;
        break;
      case 'Sur':
        angle = 180;
        break;
      case 'SSO':
        angle = 202.5;
        break;
      case 'SO':
        angle = 225;
        break;
      case 'OSO':
        angle = 247.5;
        break;
      case 'Oeste':
        angle = 270;
        break;
      case 'ONO':
        angle = 292.5;
        break;
      case 'NO':
        angle = 315;
        break;
      case 'NNO':
        angle = 337.5;
        break;
      default:
        angle = 0;
    }

    return Transform.rotate(
      angle: angle * (3.14 / 180), // Convertir el ángulo de grados a radianes
      child: Icon(
        icon,
        size: size,
      ),
    );
  }
}
