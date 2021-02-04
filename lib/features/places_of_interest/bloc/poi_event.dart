part of 'poi_bloc.dart';

abstract class POIEvent extends Equatable {
  const POIEvent();
}

/// POI: places of interest
class GetPOI extends POIEvent {
  final Position position;
  final bool refresh;

  GetPOI({
    this.position,
    this.refresh = false,
  });

  @override
  List<Object> get props => [position, refresh];
}
