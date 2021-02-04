part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeather extends WeatherEvent {
  final Position position;
  final bool refresh;

  GetWeather({
    this.position,
    this.refresh = false,
  });

  @override
  List<Object> get props => [
        position,
        refresh,
      ];
}
