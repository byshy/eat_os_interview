import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eat_os_interview/data/api_repository.dart';
import 'package:eat_os_interview/models/popular_places.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';

import '../../../di.dart';

part 'poi_event.dart';
part 'poi_state.dart';

class POIBloc extends Bloc<POIEvent, POIState> {
  POIBloc() : super(const POIState());

  PopularPlaces places;

  @override
  Stream<POIState> mapEventToState(
    POIEvent event,
  ) async* {
    if (event is GetPOI) {
      if (event.refresh || places == null) {
        yield state.copyWith(
          loading: true,
        );

        places = await getWeather(currentPosition: event.position);
      }

      yield state.copyWith(
        loading: false,
        places: places,
      );
    }
  }

  Future<PopularPlaces> getWeather({Position currentPosition}) async {
    return await sl<ApiRepo>().getPopularPlaces(
      parameters: {
        'keyword': 'tourist',
        'location': '${currentPosition.latitude},${currentPosition.longitude}',
        'radius': 5000,
        'sensor': false,
        'key': 'AIzaSyABm7VMoYfjmq1JuddufJMDASvgjj-YBi0',
      },
    );
  }
}
