import 'package:eat_os_interview/features/weather/bloc/weather_bloc.dart';
import 'package:eat_os_interview/utils/global_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';

import '../../di.dart';

class WeatherScreen extends StatefulWidget {
  final Position position;

  const WeatherScreen({Key key, @required this.position}) : super(key: key);

  @override
  _WeatherScreenState createState() => _WeatherScreenState();
}

class _WeatherScreenState extends State<WeatherScreen> {
  @override
  void initState() {
    super.initState();
    sl<WeatherBloc>().add(GetWeather(position: widget.position));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'Weather',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<WeatherBloc, WeatherState>(
        builder: (_, state) {
          if (state.loading) {
            return LoadingIndicator();
          }

          return RefreshIndicator(
            onRefresh: () {
              sl<WeatherBloc>().add(GetWeather(
                position: widget.position,
                refresh: true,
              ));

              return Future.value();
            },
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              children: [
                Text(
                  state.info?.name ?? '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 32,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 15),
                    SizedBox(width: 10),
                    Text(
                      '${state.info?.coord?.lat}, ${state.info?.coord?.lon}',
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(height: 30),
                Text(
                  '${((state.info?.main?.temp ?? 0) - 273.15).toStringAsPrecision(2)} C',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 50,
                  ),
                ),
                Text(
                  '${state.info?.weather != null ? state.info?.weather[0].main : ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
                Text(
                  '${state.info?.weather != null ? state.info?.weather[0].description : ''}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
