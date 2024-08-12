import 'dart:convert';
import 'package:data_management_app/app_utilities/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../../app_utilities/constants.dart';

class WeatherUpdateScreen extends StatefulWidget {
  final String cityname;
  const WeatherUpdateScreen({super.key, required this.cityname});

  @override
  State<WeatherUpdateScreen> createState() => _WeatherUpdateScreenState();
}

class _WeatherUpdateScreenState extends State<WeatherUpdateScreen> {
  dynamic decodeData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    getCityWeather(widget.cityname);
  }

  Future<void> getCityWeather(String cityname) async {
    var client = http.Client();
    try {
      var uri = '${Constants.domain}q=$cityname&appid=${Constants.apiKey}';
      var url = Uri.parse(uri);
      var response = await client.get(url);
      if (response.statusCode == 200) {
        setState(() {
          decodeData = json.decode(response.body);
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    } finally {
      client.close();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        appBar:appBar('Weather Updates'),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade800, Colors.blue.shade200],
            ),
          ),
          child: const Center(
            child: CircularProgressIndicator(color: Colors.white),
          ),
        ),
      );
    }

    if (decodeData == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Weather Updates'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        extendBodyBehindAppBar: true,
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.blue.shade800, Colors.blue.shade200],
            ),
          ),
          child: const Center(
            child: Text(
              'Failed to fetch weather data',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ),
        ),
      );
    }

    // Extracting weather details from the data
    String cityName = decodeData['name'];
    String weatherDescription = decodeData['weather'][0]['description'];
    double temperature = decodeData['main']['temp'] - 273.15;
    double windSpeed = decodeData['wind']['speed'];
    int humidity = decodeData['main']['humidity'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Weather Updates'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade200],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const SizedBox(height: 100.0),
              Text(
                cityName,
                style: const TextStyle(
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                weatherDescription,
                style: const TextStyle(
                  fontSize: 24.0,
                  fontStyle: FontStyle.italic,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 16.0),
              Card(
                color: Colors.white.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 8.0,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.thermostat, color: Colors.orange),
                          const SizedBox(width: 8.0),
                          Text(
                            '${temperature.toStringAsFixed(1)}°C',
                            style: const TextStyle(
                              fontSize: 24.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.air, color: Colors.blue),
                          const SizedBox(width: 8.0),
                          Text(
                            'Wind Speed: ${windSpeed.toStringAsFixed(1)} m/s',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(Icons.water_drop, color: Colors.blueAccent),
                          const SizedBox(width: 8.0),
                          Text(
                            'Humidity: $humidity%',
                            style: const TextStyle(
                              fontSize: 18.0,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32.0),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  backgroundColor: Colors.orangeAccent,
                ),
                onPressed: () {
                  // Refresh or fetch the latest weather data
                  setState(() {
                    isLoading = true;
                    getCityWeather(widget.cityname);
                  });
                },
                child: const Text('Refresh', style: TextStyle(fontSize: 18.0)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
