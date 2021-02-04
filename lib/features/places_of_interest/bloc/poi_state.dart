part of 'poi_bloc.dart';

class POIState extends Equatable {
  final PopularPlaces places;
  final bool loading;

  const POIState({
    this.places,
    this.loading = false,
  });

  POIState copyWith({
    PopularPlaces places,
    bool loading,
  }) {
    return POIState(
      places: places ?? this.places,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [
        places,
        loading,
      ];
}
