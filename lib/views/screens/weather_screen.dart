// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weather_app/controller/weather_controller.dart';

class WeatherScreen extends StatefulWidget {
  const WeatherScreen({super.key});

  @override
  State<WeatherScreen> createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getCurrentLocation(context);
    });
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are not available')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('تم رفض إذن الموقع')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('إذن الموقع مرفوض دائمًا')));
      return;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    await Provider.of<WeatherController>(
      context,
      listen: false,
    ).fetchWeatherByLocation(position.latitude, position.longitude);
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<WeatherController>(context);

    return Scaffold(
      backgroundColor: controller.backgroundColor,
      appBar: AppBar(
        title: const Text("Home screen"),
        centerTitle: true,
        backgroundColor: controller.backgroundColor,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _cityController,
              decoration: InputDecoration(
                labelText: "search by city ",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: () {
                    if (_cityController.text.isNotEmpty) {
                      controller.fetchWeatherByCity(_cityController.text);
                    }
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),

            if (controller.isLoading)
              const CircularProgressIndicator()
            else if (controller.errorMessage != null)
              Text(
                controller.errorMessage!,
                style: const TextStyle(color: Colors.red),
              )
            else if (controller.weather != null) ...[
              Center(
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 6,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${controller.weather!.cityName}, ${controller.weather!.country}",
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Image.network(
                          controller.weather!.icon,
                          width: 80,
                          height: 80,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "${controller.weather!.temperature}°C",
                          style: const TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.weather!.condition,
                          style: const TextStyle(fontSize: 20),
                        ),
                        const SizedBox(height: 8),
                        Text("Humidity: ${controller.weather!.humidity}%"),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                height: 50,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.lightBlue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(
                  onPressed: () => _getCurrentLocation(context),
                  icon: const Icon(Icons.my_location, color: Colors.black),
                  label: const Text(
                    "weather in current location",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ] else
              const Text("Search by current location or city "),
          ],
        ),
      ),
    );
  }
}
