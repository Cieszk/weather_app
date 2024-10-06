import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/view_models/location_view_model.dart';
import 'package:weather_app/view_models/weather_view_model.dart';
import 'package:weather_app/views/weather_history_screen.dart';

class WeatherScreen extends StatefulWidget {
  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _locationController = TextEditingController();
  String city = '';
  String country = '';

  @override
  Widget build(BuildContext context) {
    final locationViewModel = Provider.of<LocationViewModel>(context);
    final weatherViewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: 'Enter City, Country',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () async {
                try {
                  final location = locationViewModel.splitCityAndCountry(
                    _locationController.text,
                  );
                  city = location[0];
                  country = location[1];

                  // Fetch location coordinates
                  await locationViewModel.fetchCoordinates(city, country);
                  if (locationViewModel.location != null) {
                    // Fetch weather data using coordinates
                    await weatherViewModel.fetchWeather(
                      locationViewModel.location!.latitude,
                      locationViewModel.location!.longitude,
                      city,
                      country
                    );
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error: ${e.toString()}')),
                  );
                }
              },
              child: Text('Get Weather'),
            ),
            SizedBox(height: 16),
            if (locationViewModel.isLoading || weatherViewModel.isLoading)
              CircularProgressIndicator(),
            if (locationViewModel.errorMessage.isNotEmpty)
              Text(
                locationViewModel.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (weatherViewModel.errorMessage.isNotEmpty)
              Text(
                weatherViewModel.errorMessage,
                style: TextStyle(color: Colors.red),
              ),
            if (weatherViewModel.weather != null) ...[
              SizedBox(height: 16),
              Text(
                'Weather in $city, $country:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text('Main: ${weatherViewModel.weather!.mainWeather}'),
              Text('Description: ${weatherViewModel.weather!.description}'),
              Text(
                  'Temperature: ${weatherViewModel.weather!.temperature.toStringAsFixed(1)}°C'),
              Text(
                  'Feels Like: ${weatherViewModel.weather!.temperatureFeelsLike.toStringAsFixed(1)}°C'),
              Text(
                  'Humidity: ${weatherViewModel.weather!.humidity.toStringAsFixed(1)}%'),
              Text(
                  'Wind Speed: ${weatherViewModel.weather!.windSpeed.toStringAsFixed(1)} m/s'),
              Text('Pressure: ${weatherViewModel.weather!.pressure} hPa'),
              Text(
                  'Sunrise: ${DateTime.fromMillisecondsSinceEpoch(weatherViewModel.weather!.sunrise * 1000).toLocal()}'),
              Text(
                  'Sunset: ${DateTime.fromMillisecondsSinceEpoch(weatherViewModel.weather!.sunset * 1000).toLocal()}'),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherHistoryScreen()),
                );
              },
              child: Text('View Weather History'),
),
          ],
        ),
      ),
    );
  }
}
