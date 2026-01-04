import 'dart:convert';
import 'dart:ui';
import 'package:weather_app/secrets.dart';

import 'hourly_forecast_item.dart';
import 'additional_info_item.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {

  double temp = 0;

  @override
  void initState() {
    super.initState();
    getCurrentWeather();
  }

  Future getCurrentWeather() async {
    try{
      String cityName = 'London';
      final res = await http.get(
        Uri.parse('https://http://api.openweathermap.org/data/2.5/weather?q=$cityName&APPID=$openweatherAPIKey'),
      );

      final data = jsonDecode(res.body);

      if(data['code'] != '200'){
        throw 'An Unexpected Error Occured';
      }

      setState(() {
        temp = data['list'][0]['main']['temp'];
      });
    }catch(e){
      throw e.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Weather App',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              SizedBox(
              width: double.infinity,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10,sigmaY: 10),
                    child:  Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Text(
                            '$temp° F',
                            style: TextStyle(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 16),
                          Icon(Icons.cloud,size: 64,),
                          SizedBox(height: 16),
                          Text('Rain', style: TextStyle(fontSize: 20),)
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Weather Forecast',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 14),
            const SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  HourlyForecastItem(time: '00:00',icon: Icons.cloud,temperature: '320.00',),
                  HourlyForecastItem(time: '03:00',icon: Icons.thunderstorm,temperature: '270.23',),
                  HourlyForecastItem(time: '06:00',icon: Icons.sunny_snowing,temperature: '301.10',),
                  HourlyForecastItem(time: '09:00',icon: Icons.sunny,temperature: '320.00',),
                  HourlyForecastItem(time: '12:00',icon: Icons.water_sharp,temperature: '320.00',),
                  HourlyForecastItem(time: '15:00',icon: Icons.cloud,temperature: '320.00',),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Additional Information',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                AdditionalInfoItem(
                  icon: Icons.water_drop_outlined,
                  label: 'Humidity',
                  value: '91'
                ),
                AdditionalInfoItem(
                   icon: Icons.air,
                  label: 'Wind speed',
                  value: '7.67'
                ),
                AdditionalInfoItem(
                   icon: Icons.beach_access,
                  label: 'Pressure',
                  value: '1006'
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

