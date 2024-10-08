import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/views/weather_history_detail_screen.dart';
import '../view_models/weather_history_view_model.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class WeatherHistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weatherHistoryViewModel = Provider.of<WeatherHistoryViewModel>(context);
    final localizations = AppLocalizations.of(context);

    String formattedDate = weatherHistoryViewModel.selectedDate != null
        ? DateFormat.yMMMMd().format(weatherHistoryViewModel.selectedDate!.toLocal())
        : '';

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations!.weatherHistory),
        actions: [
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: () {
              weatherHistoryViewModel.clearFilters();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: weatherHistoryViewModel.cityController,
              decoration: InputDecoration(
                labelText: localizations.filterByCity,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            TextField(
              controller: weatherHistoryViewModel.countryController,
              decoration: InputDecoration(
                labelText: localizations.filterByCountry,
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  weatherHistoryViewModel.setSelectedDate(pickedDate);
                }
              },
              child: Text(weatherHistoryViewModel.selectedDate == null
                  ? localizations.pickDate
                  : localizations.selectedDate(formattedDate).split(' ')[0]),
            ),
            SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                weatherHistoryViewModel.notifyListeners();
              },
              child: Text(localizations.applyFilters),
            ),
            SizedBox(height: 20),

            Expanded(
              child: FutureBuilder<List<Map<String, dynamic>>>(
                future: weatherHistoryViewModel.getFilteredWeatherHistory(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text(localizations.errorLoadingHistory));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text(localizations.noWeatherHistory));
                  } else {
                    final history = snapshot.data!;
                    return ListView.builder(
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
                        return ListTile(
                          title: Text('${item['city']}, ${item['country']}'),
                          subtitle: Text(
                            DateTime.fromMillisecondsSinceEpoch(item['timestamp']).toString(),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => WeatherHistoryDetailsScreen(
                                  weatherData: item,
                                ),
                              ),
                            );
                          },
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}