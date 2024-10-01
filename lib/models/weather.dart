class Weather {
  final String mainWeather;
  final String description;
  final double temperature;
  final double temperatureFeelsLike;
  final double windSpeed;
  final int pressure;
  final double humidity;
  final int sunrise;
  final int sunset;

  Weather({
    required this.mainWeather,
    required this.description,
    required this.temperature,
    required this.temperatureFeelsLike,
    required this.windSpeed,
    required this.pressure,
    required this.humidity,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      mainWeather: (json['weather'][0]['main'] ?? "").toString(),
      description: (json['weather'][0]['description'] ?? "").toString(),
      
      temperature: _toDouble(json['main']['temp']),
      temperatureFeelsLike: _toDouble(json['main']['feels_like']),
      
      windSpeed: _toDouble(json['wind']['speed']),
      pressure: _toInt(json['main']['pressure']),
      humidity: _toDouble(json['main']['humidity']),
      
      sunrise: _toInt(json['sys']['sunrise']),
      sunset: _toInt(json['sys']['sunset']),
    );
  }

  static double _toDouble(dynamic value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is double) {
      return value;
    } else if (value is int) {
      return value.toDouble();
    } else {
      return 0.0;
    }
  }

  static int _toInt(dynamic value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    } else {
      return 0;
    }
  }
}