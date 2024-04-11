import 'package:flutter/material.dart';

informacion_singular(String titulo, String valor, IconData icon) {
  return Column(
    children: [
      Center(
        child: Text(
          titulo,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              Icon(
                icon,
                size: 40,
              ),
              Text(
                valor,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

Temperatura(String title, String max, String med, String min) {
  return Column(
    children: [
      Center(
        child: Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      const SizedBox(height: 5),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Column(
            children: [
              const Icon(
                Icons.thermostat,
                color: Colors.red,
                size: 40,
              ),
              const Text(
                'Max',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                max,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],
          ),
          Column(
            children: [
              const Icon(
                Icons.thermostat,
                size: 40,
              ),
              const Text(
                'Med',
                style: TextStyle(fontSize: 18),
              ),
              Text(
                med,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],
          ),
          Column(
            children: [
              Icon(Icons.thermostat, size: 40, color: Colors.blue[200]),
              const Text(
                "Min",
                style: TextStyle(fontSize: 18),
              ),
              Text(
                min,
                style: const TextStyle(fontSize: 18, color: Colors.blue),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}


  estacion_municipio(String estacion, String municipio) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Estacion:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              estacion,
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              'Municipio:',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              municipio,
              style: const TextStyle(fontSize: 20, color: Colors.blue),
            ),
          ],
        ),
      ],
    );
  }