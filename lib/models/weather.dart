import 'dart:convert';

class Weather {
  final double temperature;
  final String? time;
  final double windspeed;
  final int relativeHumidity2m;

  Weather({
    required this.temperature,
    required this.windspeed,
    required this.relativeHumidity2m,
    this.time,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      temperature: (json['current_weather']['temperature'] ?? 0.0).toDouble(),
      windspeed: (json['current_weather']['windspeed'] ?? 0.0).toDouble(),
      relativeHumidity2m: (json['current_weather']['relative_humidity_2m'] ?? 0).toInt(),
      time: (json['current_weather']['time'] ?? '').toString()
    );
  }

}