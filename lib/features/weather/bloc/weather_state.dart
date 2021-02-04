part of 'weather_bloc.dart';

class WeatherState extends Equatable {
  final WeatherInfo info;
  final bool loading;

  const WeatherState({
    this.info,
    this.loading = false,
  });

  WeatherState copyWith({
    WeatherInfo info,
    bool loading,
  }) {
    return WeatherState(
      info: info ?? this.info,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [
        info,
        loading,
      ];
}
