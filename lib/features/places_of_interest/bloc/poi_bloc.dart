import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'poi_event.dart';
part 'poi_state.dart';

class POIBloc extends Bloc<POIEvent, POIState> {
  POIBloc() : super(const POIState());

  @override
  Stream<POIState> mapEventToState(
    POIEvent event,
  ) async* {
    // TODO: implement mapEventToState
  }
}
