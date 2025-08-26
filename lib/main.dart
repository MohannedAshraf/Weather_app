import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather_app/controller/weather_controller.dart';
import 'package:weather_app/views/screens/weather_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherController(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const WeatherScreen(),
      ),
    );
  }
}
