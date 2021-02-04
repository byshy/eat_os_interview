part of 'home_bloc.dart';

class HomeState extends Equatable {
  final Marker marker;
  final Set<Polyline> polyLine;
  final Position currentLocation;
  final Position destinationLocation;
  final String currentLocationName;
  final String currentLocationCode;

  const HomeState({
    this.marker,
    this.polyLine,
    this.currentLocationName,
    this.currentLocation,
    this.destinationLocation,
    this.currentLocationCode,
  });

  HomeState copyWith({
    Marker marker,
    Set<Polyline> polyLine,
    Position currentLocation,
    String currentLocationName,
    Position destinationLocation,
    String currentLocationCode,
  }) {
    return HomeState(
      marker: marker ?? this.marker,
      polyLine: polyLine ?? this.polyLine,
      currentLocation: currentLocation ?? this.currentLocation,
      currentLocationName: currentLocationName ?? this.currentLocationName,
      destinationLocation: destinationLocation ?? this.destinationLocation,
      currentLocationCode: currentLocationCode ?? this.currentLocationCode,
    );
  }

  @override
  List<Object> get props => [
        marker,
        polyLine,
        currentLocation,
        currentLocationName,
        destinationLocation,
        currentLocationCode,
      ];
}
