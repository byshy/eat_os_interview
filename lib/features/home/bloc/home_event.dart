part of 'home_bloc.dart';

abstract class HomeEvent extends Equatable {
  const HomeEvent();
}

class GetCurrentLocation extends HomeEvent {
  @override
  List<Object> get props => [];
}

class GenerateLocation extends HomeEvent {
  const GenerateLocation({
    @required this.distance,
    @required this.position,
  });

  final double distance;
  final Position position;

  @override
  List<Object> get props => [distance, position];
}
