import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AppDetailsPage extends StatelessWidget {
  const AppDetailsPage({super.key});

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Partner Institution (INIFAP):',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'INIFAP Information Goes Here\nMission\nServices Provided\nContact Details',
              style: TextStyle(fontSize: 16.0),
            ),

            const Divider(height: 32.0),
            const Text(
              'Desarrollador:',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            const Text(
              'Alexia Hernandez Martinez\nhernandezmtzalexia@gmail.com',
              style: TextStyle(fontSize: 16.0),
            ),
            const SizedBox(height: 8.0),
            InkWell(
              onTap: () => _launchURL(
                  'https://alexlife2002003.github.io/react-portfolio/'),
              child: const Text(
                'https://alexlife2002003.github.io/react-portfolio/',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.blue,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
            const SizedBox(height: 8.0),
            Image.asset('lib/assets/Logos_Labsol.png',height: 200,width: 300,),
            const SizedBox(height: 8.0),
            Image.asset('lib/assets/GPLv3_Logo.svg.png',height:200,width: 300,), // GPL Logo
          ],
        ),
      ),
    );
  }
}
