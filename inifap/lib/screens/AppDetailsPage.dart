import 'package:flutter/material.dart';
import 'package:inifap/screens/AppWithDrawer.dart';


class AppDetailsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AppWithDrawer(
      content: Scaffold(
        appBar: AppBar(
          title: Text('App Details'),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Partner Institution (INIFAP):',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'INIFAP Information Goes Here\nMission\nServices Provided\nContact Details',
                style: TextStyle(fontSize: 16.0),
              ),
              Divider(height: 32.0),
              Text(
                'Institution (Labsol):',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Labsol Information Goes Here\nAddress\nContact Details',
                style: TextStyle(fontSize: 16.0),
              ),
              Divider(height: 32.0),
              Text(
                'App Developer:',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                'Alexia Hernandez Martinez\nhernandezmtzalexia@gmail.com\n4922253957\nhttps://alexlife2002003.github.io/react-portfolio/',
                style: TextStyle(fontSize: 16.0),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
