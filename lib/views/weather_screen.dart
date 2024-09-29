import 'package:flutter/material.dart';
import '../view_models/weather_view_model.dart';
import 'package:provider/provider.dart';

class WeatherScreen extends StatelessWidget {
  final double latitude;
  final double longitude;

  const WeatherScreen({super.key, required this.latitude, required this.longitude});

  @override
  Widget build(BuildContext context) {
    final weatherViewModel = Provider.of<WeatherViewModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather App')
      ),
      body: Center(
        child: weatherViewModel.isLoading
         ? const CircularProgressIndicator()
         :weatherViewModel.errorMessage.isNotEmpty
          ? Text(weatherViewModel.errorMessage)
          : weatherViewModel.weather != null
            ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Temperature: ${weatherViewModel.weather!.temperature}°C'),
                Text('Wind Speed: ${weatherViewModel.weather!.windspeed} km/h'),
                Text('Humidity: ${weatherViewModel.weather!.relativeHumidity2m}%'),
                Text('Time: ${weatherViewModel.weather!.time}')
              ],
            ) : ElevatedButton(onPressed: () {
              weatherViewModel.fetchWeather(latitude, longitude);
            }, child: const Text('Get Weather'))
      ),
    );
  }
}