import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/view_models/location_view_model.dart';
import 'package:weather_app/view_models/weather_view_model.dart';
import 'package:weather_app/views/weather_history_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.appTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _locationController,
              decoration: InputDecoration(
                labelText: localizations.inputLabel,
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

                  await locationViewModel.fetchCoordinates(city, country);
                  if (locationViewModel.location != null) {
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
              child: Text(localizations.getWeather),
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
                localizations.weatherInLocation(city, country),
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(localizations.mainWeather(weatherViewModel.weather!.mainWeather)),
              Text(localizations.weatherDescription(weatherViewModel.weather!.description)),
              Text(localizations.temperatureDetail(weatherViewModel.weather!.temperature.toStringAsFixed(1))),
              Text(localizations.feelsLike(weatherViewModel.weather!.temperatureFeelsLike.toStringAsFixed(1))),
              Text(localizations.humidity(weatherViewModel.weather!.humidity.toStringAsFixed(1))),
              Text(localizations.windSpeed(weatherViewModel.weather!.windSpeed.toStringAsFixed(1))),
              Text(localizations.pressure(weatherViewModel.weather!.pressure.toString())),
              Text(localizations.sunrise(DateTime.fromMillisecondsSinceEpoch(weatherViewModel.weather!.sunrise * 1000).toLocal().toString())),
              Text(localizations.sunset(DateTime.fromMillisecondsSinceEpoch(weatherViewModel.weather!.sunset * 1000).toLocal().toString())),
              ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => WeatherHistoryScreen()),
                );
              },
              child: Text(localizations.viewWeatherHisotryButton),
),
          ],
        ),
      ),
    );
  }
}
