import 'package:eat_os_interview/features/auth/bloc/auth_bloc.dart';
import 'package:eat_os_interview/features/auth/login_screen.dart';
import 'package:eat_os_interview/features/home/bloc/home_bloc.dart';
import 'package:eat_os_interview/features/home/home_screen.dart';
import 'package:eat_os_interview/features/news/bloc/news_bloc.dart';
import 'package:eat_os_interview/features/news/news_screen.dart';
import 'package:eat_os_interview/features/places_of_interest/bloc/poi_bloc.dart';
import 'package:eat_os_interview/features/places_of_interest/poi_screen.dart';
import 'package:eat_os_interview/features/weather/bloc/weather_bloc.dart';
import 'package:eat_os_interview/features/weather/weather_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../di.dart';
import 'routes.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case home:
        return MaterialPageRoute(
          settings: RouteSettings(name: home),
          builder: (_) => BlocProvider.value(
            child: HomeScreen(),
            value: sl<HomeBloc>(),
          ),
        );
      case news:
        return MaterialPageRoute(
          settings: RouteSettings(name: news),
          builder: (_) => BlocProvider.value(
            child: NewsScreen(),
            value: sl<NewsBloc>(),
          ),
        );
      case placesOfInterest:
        return MaterialPageRoute(
          settings: RouteSettings(name: placesOfInterest),
          builder: (_) => BlocProvider.value(
            child: POIScreen(),
            value: sl<POIBloc>(),
          ),
        );
      case weather:
        return MaterialPageRoute(
          settings: RouteSettings(name: weather),
          builder: (_) => BlocProvider.value(
            child: WeatherScreen(
              position: (settings.arguments as List)[0],
            ),
            value: sl<WeatherBloc>(),
          ),
        );
      case login:
        return MaterialPageRoute(
          settings: RouteSettings(name: login),
          builder: (_) => BlocProvider.value(
            child: LoginScreen(),
            value: sl<AuthBloc>(),
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
