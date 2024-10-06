import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:weather_app/database/database_helper.dart';

class WeatherHistoryViewModel extends ChangeNotifier {
  final TextEditingController cityController = TextEditingController();
  final TextEditingController countryController = TextEditingController();
  DateTime? selectedDate;

  Future<List<Map<String, dynamic>>> getFilteredWeatherHistory() async {
    final db = DatabaseHelper();
    List<Map<String, dynamic>> weatherList = await db.getWeatherHistory();

    if (cityController.text.isNotEmpty) {
      weatherList = weatherList.where((item) => item['city'].toLowerCase().contains(cityController.text.toLowerCase())).toList();
    }

    if (countryController.text.isNotEmpty) {
      weatherList = weatherList.where((item) => item['country'].toLowerCase().contains(countryController.text.toLowerCase())).toList();
    }

    if (selectedDate != null) {
      weatherList = weatherList.where((item) {
        final itemDate = DateTime.fromMillisecondsSinceEpoch(item['timestamp']);
        return itemDate.year == selectedDate!.year &&
              itemDate.month == selectedDate!.month &&
              itemDate.day == selectedDate!.day;
      }).toList();
    }

    return weatherList;
  }

  void clearFilters() {
    cityController.clear();
    countryController.clear();
    selectedDate = null;
    notifyListeners();
  }

  void setSelectedDate(DateTime date) {
    selectedDate = date;
    notifyListeners();
  }

  @override
  void dispose() {
    cityController.dispose();
    countryController.dispose();
    super.dispose();
  }
}