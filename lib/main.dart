import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'views/weather_screen.dart';
import 'view_models/weather_view_model.dart';
import 'view_models/location_view_model.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocationViewModel()),
        ChangeNotifierProvider(create: (_) => WeatherViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather App',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: WeatherScreen(),
      ),
    );
  }
}