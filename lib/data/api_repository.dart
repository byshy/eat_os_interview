import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class ApiRepo {
  final Dio client;

  ApiRepo({@required this.client});

  Future<List<LatLng>> getSteps({Map<String, dynamic> parameters}) async {
    Response response = await client.get(
      'https://maps.googleapis.com/maps/api/directions/json?',
      queryParameters: parameters,
    );

    List<LatLng> steps = List();

    for (Map<String, dynamic> s in response.data["routes"][0]["legs"][0]
        ["steps"]) {
      print('s: ${s}');
      steps.add(LatLng(s['end_location']['lat'], s['end_location']['lng']));
    }

    return steps;
  }
}
