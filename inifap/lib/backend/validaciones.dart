import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:http/http.dart' as http;

Future<bool> conexionInternt() async {
  var connectivityResult = await Connectivity().checkConnectivity();

  if (connectivityResult == ConnectivityResult.none) {
    return false;
  } else {
    // Check Wi-Fi speed
    double responseTime = await checkNetworkResponseTime();
    if (responseTime > 3000) {
      return false;
    } else {
      return true;
    }
  }
}

Future<double> checkNetworkResponseTime() async {
  final startTime = DateTime.now();

  try {
    final response = await http.get(Uri.parse('https://www.google.com'));
    if (response.statusCode == 200) {
      final endTime = DateTime.now();
      final duration = endTime.difference(startTime);
      return duration.inMilliseconds.toDouble();
    }
  } catch (e) {
    // Handle error
  }

  return double.infinity; // Return a large value for failed requests
}
