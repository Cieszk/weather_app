import 'package:flutter/material.dart';
import '../config/api_config.dart';
import 'package:weather_app/models/location.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LocationViewModel extends ChangeNotifier {
    Location? _location;
    String _errorMessage = '';
    bool _isLoading = false;

    Location? get location => _location;
    String get errorMessage => '';
    bool get isLoading => _isLoading;

    Future<void> fetchCoordinates(String city, String country) async {
      _isLoading = true;
      notifyListeners();

      const String apiKey = ApiConfig.OPENWEATHER_API_KEY;
      final url = 'http://api.openweathermap.org/geo/1.0/direct?q=$city,$country&appid=$apiKey';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final jsonResponse = json.decode(response.body);
          if (jsonResponse.isNotEmpty) {
            _location = Location.fromJson(jsonResponse[0]);
          } else {
            _errorMessage = 'Location not found';
          }
        } else {
          _errorMessage = 'Error: Unable to fetch coordinates';
        }
      } catch (e) {
        _errorMessage = 'Exception: $e';
      } finally {
        _isLoading = false;
        notifyListeners();
      }
    }

    List<String> splitCityAndCountry(String input) {
      List<String> parts = input.split(',');

      if (parts.length == 2) {
        String city = parts[0].trim();
        String country = parts[1].trim();
        return [city, country];
      } else {
        throw const FormatException('Input must contain both city and country separated by a comma.');
      }
    }
}