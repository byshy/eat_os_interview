import 'dart:async';

import 'package:eat_os_interview/features/home/bloc/home_bloc.dart';
import 'package:eat_os_interview/routing/navigation_service.dart';
import 'package:eat_os_interview/routing/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../di.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Completer<GoogleMapController> _completer = Completer();
  GoogleMapController _mapController;
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 5.4746,
  );

  Position _currentPosition;

  double _milesSelected = 5;

  @override
  void initState() {
    super.initState();
    initMapController();
  }

  void initMapController() async {
    _mapController = await _completer.future;
    sl<HomeBloc>().add(GetCurrentLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener(
        cubit: sl<HomeBloc>(),
        listener: (_, HomeState state) {
          if (state.currentLocation != _currentPosition) {
            _mapController.animateCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: LatLng(
                    state.currentLocation.latitude ?? 37.43296265331129,
                    state.currentLocation.longitude ?? -122.08832357078792,
                  ),
                  zoom: 15,
                ),
              ),
            );
          }

          if (state.marker != null) {
            setState(() {
              _markers[state.marker.markerId] = state.marker;
              _currentPosition = state.currentLocation;
            });
          }
        },
        child: BlocBuilder<HomeBloc, HomeState>(
          builder: (_, state) {
            return Stack(
              children: [
                GoogleMap(
                  mapType: MapType.terrain,
                  initialCameraPosition: _kGooglePlex,
                  onMapCreated: (GoogleMapController controller) {
                    _completer.complete(controller);
                  },
                  padding: const EdgeInsets.only(bottom: 60),
                  myLocationButtonEnabled: false,
                  markers: Set<Marker>.of(_markers.values),
                  polylines: state.polyLine,
                ),
                Container(
                  child: SafeArea(
                    minimum: const EdgeInsets.symmetric(horizontal: 10),
                    child: Row(
                      children: [
                        Card(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () => sl<NavigationService>().navigateTo(
                              placesOfInterest,
                              arguments: [_currentPosition],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.star,
                                color: Colors.yellow,
                              ),
                            ),
                          ),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        Card(
                          color: Colors.transparent,
                          elevation: 0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.star,
                              color: Colors.transparent,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Text(
                            state.currentLocationName ?? '',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Card(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () => sl<NavigationService>().navigateTo(
                              weather,
                              arguments: [_currentPosition],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.cloud,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        Card(
                          clipBehavior: Clip.hardEdge,
                          child: InkWell(
                            onTap: () =>
                                sl<NavigationService>().navigateTo(news),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.assignment_outlined,
                                color: Colors.red,
                              ),
                            ),
                          ),
                          elevation: 8,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.5, 1],
                      colors: [
                        Colors.white,
                        Color(0x00FFFFFF),
                      ],
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    child: SafeArea(
                      minimum: const EdgeInsets.only(bottom: 10),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Slider(
                                  min: 1,
                                  max: 10,
                                  divisions: 9,
                                  label: '${_milesSelected.toInt()}',
                                  value: _milesSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      _milesSelected = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          FloatingActionButton.extended(
                            heroTag: 'Surprise',
                            onPressed: () => sl<HomeBloc>().add(
                              GenerateLocation(
                                distance: _milesSelected,
                                position: _currentPosition,
                              ),
                            ),
                            label: Text('Surprise'),
                            icon: Icon(Icons.location_on),
                          ),
                          SizedBox(width: 10),
                          FloatingActionButton(
                            heroTag: 'my_location',
                            child: Icon(Icons.my_location),
                            onPressed: () =>
                                sl<HomeBloc>().add(GetCurrentLocation()),
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        end: Alignment.topCenter,
                        begin: Alignment.bottomCenter,
                        stops: [0.4, 1],
                        colors: [
                          Colors.white,
                          Color(0x00FFFFFF),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
