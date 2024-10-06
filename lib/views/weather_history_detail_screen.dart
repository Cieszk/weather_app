import 'package:flutter/material.dart';

class WeatherHistoryDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> weatherData;

  WeatherHistoryDetailsScreen({required this.weatherData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${weatherData['city']}, ${weatherData['country']}'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weather Details',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Text('Date: ${DateTime.fromMillisecondsSinceEpoch(weatherData['timestamp'])}'),
            SizedBox(height: 8),
            Text('City: ${weatherData['city']}'),
            SizedBox(height: 8),
            Text('Country: ${weatherData['country']}'),
            SizedBox(height: 8),
            Text('Temperature: ${weatherData['temperature']}°C'),
            SizedBox(height: 8),
            Text('Description: ${weatherData['weather_description']}'),
          ],
        ),
      ),
    );
  }
}
