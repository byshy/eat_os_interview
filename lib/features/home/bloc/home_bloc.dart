import 'dart:async';
import 'dart:math';

import 'package:bloc/bloc.dart';
import 'package:eat_os_interview/data/api_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../di.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  HomeBloc() : super(const HomeState());

  String currentAddress;

  final Geolocator geoLocator = Geolocator()..forceAndroidLocationManager;

  @override
  Stream<HomeState> mapEventToState(
    HomeEvent event,
  ) async* {
    if (event is GetCurrentLocation) {
      Position position = await geoLocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.best);

      final Marker marker = Marker(
        markerId: MarkerId('my_current_location'),
        position: LatLng(
          position.latitude,
          position.longitude,
        ),
      );

      String fullAddress = await _getAddressFromLatLng(position);

      String addressName = fullAddress.split(':')[0];
      String addressCode = fullAddress.split(':')[1];

      yield state.copyWith(
        marker: marker,
        currentLocation: position,
        currentLocationName: addressName,
        currentLocationCode: addressCode,
      );
    } else if (event is GenerateLocation) {
      LatLng randomLocation = getRandomLocation(
        distance: event.distance,
        lon1: event.position.longitude,
        lat1: event.position.latitude,
      );

      String markerIdVal = 'random_location';
      final MarkerId markerId = MarkerId(markerIdVal);

      final Marker marker = Marker(
        markerId: markerId,
        position: LatLng(
          randomLocation.latitude ?? 37.43296265331129,
          randomLocation.longitude ?? -122.08832357078792,
        ),
      );

      Position destination = Position(
        longitude: randomLocation.longitude,
        latitude: randomLocation.latitude,
      );

      Polyline polyline = await getSteps(
        currentPosition: event.position,
        destinationPosition: destination,
      );

      Set<Polyline> polyLines = Set();
      polyLines.add(polyline);

      yield state.copyWith(
        destinationLocation: destination,
        marker: marker,
        polyLine: polyLines,
      );
    }
  }

  Future<String> _getAddressFromLatLng(Position position) async {
    try {
      List<Placemark> p = await geoLocator.placemarkFromCoordinates(
          position.latitude, position.longitude);
      Placemark place = p[0];
      return '${place.locality}, ${place.postalCode}, ${place.country}:${place.isoCountryCode}';
    } catch (e) {
      print(e);
      return 'Address Unavailable';
    }
  }

  LatLng getRandomLocation({double distance, double lon1, double lat1}) {
    // Using Haversine Formula.

    double lat = (lat1 * pi / 180);
    double lon = (lon1 * pi / 180);
    int earthRadius = 6371000;

    double miles = 1609.34 * (Random().nextDouble() * distance);

    double deltaLat = cos(Random().nextDouble() * pi) * miles / earthRadius;
    int sign = Random().nextInt(2) * 2 - 1;
    double deltaLon = sign *
        acos(((cos(miles / earthRadius) - cos(deltaLat)) /
                (cos(lat) * cos(deltaLat + lat))) +
            1);

    return LatLng((lat + deltaLat) * 180 / pi, (lon + deltaLon) * 180 / pi);
  }

  Future<Polyline> getSteps({
    Position currentPosition,
    Position destinationPosition,
  }) async {
    List<LatLng> _steps = await sl<ApiRepo>().getSteps(
      parameters: {
        'origin': '${currentPosition.latitude},${currentPosition.longitude}',
        'destination':
            '${destinationPosition.latitude},${destinationPosition.longitude}',
        'key': 'AIzaSyABm7VMoYfjmq1JuddufJMDASvgjj-YBi0',
      },
    );

    _steps.insert(
        0,
        LatLng(
          currentPosition.latitude,
          currentPosition.longitude,
        ));

    return Polyline(
      visible: true,
      polylineId: new PolylineId(currentPosition.hashCode.toString()),
      points: _steps,
      color: Colors.blue,
      width: 6,
    );
  }
}
