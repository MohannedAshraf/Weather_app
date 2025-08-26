import 'package:dio/dio.dart';
import 'package:weather_app/models/weather_model.dart';

class ApiService {
  final Dio _dio = Dio();
  final String baseUrl = "https://api.weatherapi.com/v1/current.json";
  final String apiKey = "d2209a70879f4d068b0152158252008";

  // get weather by city
  Future<WeatherModel> getWeatherByCity(String cityName) async {
    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {"key": apiKey, "q": cityName},
      );

      return WeatherModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to get weather: $e");
    }
  }

  // get weather by (lat long)
  Future<WeatherModel> getWeatherByLocation(double lat, double lon) async {
    try {
      final response = await _dio.get(
        baseUrl,
        queryParameters: {"key": apiKey, "q": "$lat,$lon"},
      );

      return WeatherModel.fromJson(response.data);
    } catch (e) {
      throw Exception("Failed to get weather: $e");
    }
  }
}
