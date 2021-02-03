part of 'weather_bloc.dart';

abstract class WeatherEvent extends Equatable {
  const WeatherEvent();
}

class GetWeather extends WeatherEvent {
  final Position position;

  GetWeather({this.position});

  @override
  List<Object> get props => [position];
}
