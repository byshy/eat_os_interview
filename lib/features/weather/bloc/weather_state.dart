part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final WeatherInfo info;

  const WeatherState({
    this.info,
  });

  WeatherState copyWith({
    WeatherInfo info,
  }) {
    return WeatherState(
      info: info ?? this.info,
    );
  }

  @override
  List<Object> get props => [
        info,
      ];
}
