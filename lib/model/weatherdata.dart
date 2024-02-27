import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class WeatherdataProvider with ChangeNotifier {
  bool isLoading = true;
  Map<String, dynamic> _weather = {};
  Map<String, dynamic> get weather => _weather;

  List<dynamic> _weeklyWeather = [];
  List<dynamic> get weeklyWeather => _weeklyWeather;
  String _cityName = "";
  String get cityName => _cityName;

  getWeather(String cityName) async {
    try {
      isLoading = true;
      var box = await Hive.openBox('testBox');
      var url = Uri.parse(
          "https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid={APIKEY}");
      var response = await http.get(url);
      //print(response.statusCode);
      var data = jsonDecode(response.body);
      _weather = data;
      box.put(0, data);
      await getWeeklyWeather(cityName);
      isLoading = false;
      notifyListeners();
      // print(_weather);
      //print(data);
    } catch (e) {
      var box = await Hive.openBox('testBox');
      //Converting Cast
      dynamic storedData = box.getAt(0);
      _weather = storedData.cast<String, dynamic>();

      isLoading = false;
      notifyListeners();
      print(box.getAt(0));
    }
  }

  getCityName() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission == await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          print("Permission Denie");
        }
      } else {
        // Get the current location
        Position position = await Geolocator.getCurrentPosition(
            desiredAccuracy: LocationAccuracy.high);

        // Use the geocoding package to get the city name
        List<Placemark> placemarks = await placemarkFromCoordinates(
            position.latitude, position.longitude);

        // Extract the city name
        _cityName = placemarks.first.locality ?? '';
        notifyListeners();
        print(cityName);
        getWeather(cityName);
        getWeeklyWeather(cityName);
        // return cityName;
      }
    } catch (e) {
      print("Error getting city name: $e");

      //return null;
    }
  }

  // Get weekly weather

  getWeeklyWeather(String cityName) async {
    try {
      var box = await Hive.openBox('weeklyWeather');
      var url = Uri.parse(
          "http://api.openweathermap.org/data/2.5/forecast?cnt=6&q=$cityName&appid={APIKEY}");
      var response = await http.get(url);
      var data = jsonDecode(response.body)["list"];
      _weeklyWeather = data;
      box.put(0, data);
      notifyListeners();
      print(_weeklyWeather);
    } catch (e) {
      var box = await Hive.openBox('weeklyWeather');
      //Converting Cast
      dynamic storedData = box.getAt(0);
      _weeklyWeather = storedData;
      isLoading = false;
      notifyListeners();
      print(box.getAt(0));
    }
  }
}
