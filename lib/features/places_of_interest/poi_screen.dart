import 'package:eat_os_interview/features/places_of_interest/bloc/poi_bloc.dart';
import 'package:eat_os_interview/utils/global_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../di.dart';

class POIScreen extends StatefulWidget {
  final Position position;

  const POIScreen({Key key, this.position}) : super(key: key);

  @override
  _POIScreenState createState() => _POIScreenState();
}

class _POIScreenState extends State<POIScreen> {
  @override
  void initState() {
    super.initState();
    sl<POIBloc>().add(GetPOI(position: widget.position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Places of interest',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<POIBloc, POIState>(
        builder: (_, state) {
          if (state.loading) {
            return LoadingIndicator();
          }

          return RefreshIndicator(
            onRefresh: () {
              sl<POIBloc>().add(GetPOI(
                position: widget.position,
                refresh: true,
              ));

              return Future.value();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: state.places?.results?.length ?? 0,
              itemBuilder: (_, index) => ListTile(
                title: Text(state.places.results[index].name),
              ),
              separatorBuilder: (_, index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
