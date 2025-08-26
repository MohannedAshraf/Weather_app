class WeatherModel {
  final String cityName;
  final String country;
  final double temperature;
  final String condition;
  final String icon;
  final int humidity;

  WeatherModel({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.condition,
    required this.icon,
    required this.humidity,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json) {
    return WeatherModel(
      cityName: json['location']['name'],
      country: json['location']['country'],
      temperature: (json['current']['temp_c'] as num).toDouble(),
      condition: json['current']['condition']['text'],
      icon: "https:${json['current']['condition']['icon']}",
      humidity: json['current']['humidity'],
    );
  }
}
