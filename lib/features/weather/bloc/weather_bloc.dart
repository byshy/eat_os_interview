import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eat_os_interview/data/api_repository.dart';
import 'package:eat_os_interview/models/weather.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../../di.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  WeatherBloc() : super(const WeatherState());

  WeatherInfo info;

  @override
  Stream<WeatherState> mapEventToState(
    WeatherEvent event,
  ) async* {
    if (event is GetWeather) {
      if (event.refresh || info == null) {
        yield state.copyWith(
          loading: true,
        );

        info = await getWeather(currentPosition: event.position);
      }

      yield state.copyWith(
        info: info,
        loading: false,
      );
    }
  }

  Future<WeatherInfo> getWeather({Position currentPosition}) async {
    return await sl<ApiRepo>().getWeather(
      parameters: {
        'lat': currentPosition.latitude,
        'lon': currentPosition.longitude,
        'appid': '4459af0f6630bbf6f12bb6bd28dddfcb',
      },
    );
  }
}
