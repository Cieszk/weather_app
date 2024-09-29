import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/views/weather_screen.dart';
import 'view_models/weather_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<WeatherViewModel>(
      create: (_) => WeatherViewModel(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WeatherScreen(latitude: 50.9477, longitude: 17.2917),
      ),
);
  }
}
