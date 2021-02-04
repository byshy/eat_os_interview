import 'package:dio/dio.dart';
import 'package:eat_os_interview/models/news.dart';
import 'package:eat_os_interview/models/popular_places.dart';
import 'package:eat_os_interview/models/weather.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApiRepo {
  final Dio client;

  ApiRepo({@required this.client});

  Future<List<LatLng>> getSteps({Map<String, dynamic> parameters}) async {
    Response response = await client.get(
      'https://maps.googleapis.com/maps/api/directions/json',
      queryParameters: parameters,
    );

    List<LatLng> steps = List();

    for (Map<String, dynamic> s in response.data["routes"][0]["legs"][0]
        ["steps"]) {
      steps.add(LatLng(s['end_location']['lat'], s['end_location']['lng']));
    }

    return steps;
  }

  Future<WeatherInfo> getWeather({Map<String, dynamic> parameters}) async {
    Response response = await client.get(
      'https://api.openweathermap.org/data/2.5/weather',
      queryParameters: parameters,
    );

    return WeatherInfo.fromJson(response.data);
  }

  Future<PopularPlaces> getPopularPlaces(
      {Map<String, dynamic> parameters}) async {
    Response response = await client.get(
      'https://maps.googleapis.com/maps/api/place/search/json',
      queryParameters: parameters,
    );

    return PopularPlaces.fromJson(response.data);
  }

  Future<News> getNews({Map<String, dynamic> parameters}) async {
    Response response = await client.get(
      'http://newsapi.org/v2/top-headlines',
      queryParameters: parameters,
    );

    return News.fromJson(response.data);
  }
}
