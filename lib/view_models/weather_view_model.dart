import 'package:flutter/material.dart';
import 'package:weather_app/database/database_helper.dart';
import '../config/api_config.dart';
import 'package:weather_app/models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherViewModel extends ChangeNotifier {
  Weather? _weather;
  bool _isLoading = false;
  String _errorMessage = '';

  Weather? get weather => _weather;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  Future<void> fetchWeather(double latitude, double longitude, String city, String country) async {
    _isLoading = true;
    notifyListeners();

    const String apiKey = ApiConfig.OPENWEATHER_API_KEY;
    final url = 'https://api.openweathermap.org/data/2.5/weather?lat=$latitude&lon=$longitude&units=metric&appid=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _weather = Weather.fromJson(jsonResponse);

        await _storeWeatherData(city, country, _weather!);
      } else {
        _errorMessage = 'Error: Unable to fetch weather data';
      }
    } catch (e) {
      _errorMessage = 'Exception: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _storeWeatherData(String city, String country, Weather weather) async {
    final weatherData = {
      'city': city,
      'country': country,
      'temperature': weather.temperature,
      'weather_description': weather.description,
      'timestamp': DateTime.now().microsecondsSinceEpoch
    };

    await DatabaseHelper().insertWeatherData(weatherData);
  }

  Future<List<Map<String, dynamic>>> getWeatherHistory() async {
    return await DatabaseHelper().getWeatherHistory();
  }

}