import 'package:flutter/material.dart';
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

  Future<void> fetchWeather(double latitude, double longitude) async {
    _isLoading = true;
    _errorMessage = '';
    notifyListeners();

    final url = 'https://api.open-meteo.com/v1/forecast?latitude=$latitude&longitude=$longitude&current=relative_humidity_2m&hourly=temperature_2m&format=flatbuffers';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final jsonResponse = json.decode(response.body);
        _weather = Weather.fromJson(jsonResponse);
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
}