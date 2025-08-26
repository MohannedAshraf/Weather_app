import 'package:flutter/material.dart';
import 'package:weather_app/helper/api_services.dart';
import 'package:weather_app/models/weather_model.dart';

class WeatherController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  WeatherModel? _weather;
  bool _isLoading = false;
  String? _errorMessage;

  WeatherModel? get weather => _weather;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // search by city
  Future<void> fetchWeatherByCity(String cityName) async {
    _setLoading(true);
    try {
      _weather = await _apiService.getWeatherByCity(cityName);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _weather = null;
    }
    _setLoading(false);
  }

  // search by current location
  Future<void> fetchWeatherByLocation(double lat, double lon) async {
    _setLoading(true);
    try {
      _weather = await _apiService.getWeatherByLocation(lat, lon);
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _weather = null;
    }
    _setLoading(false);
  }

  // change background color
  Color get backgroundColor {
    final temp = _weather?.temperature;
    if (temp == null) return Colors.white;
    if (temp < 10) {
      return Colors.blue.shade200;
    } else if (temp < 25) {
      return Colors.green.shade200;
    } else {
      return Colors.orange.shade200;
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
