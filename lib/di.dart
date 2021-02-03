import 'package:dio/dio.dart';
import 'package:eat_os_interview/features/home/bloc/home_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'data/api_repository.dart';
import 'data/local_repository.dart';
import 'features/auth/bloc/auth_bloc.dart';
import 'features/news/bloc/news_bloc.dart';
import 'features/places_of_interest/bloc/poi_bloc.dart';
import 'features/weather/bloc/weather_bloc.dart';
import 'routing/navigation_service.dart';

/// sl: service locator
final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton<LocalRepo>(
    () => LocalRepo(
      sharedPreferences: sl(),
    ),
  );

  sl.registerLazySingleton<ApiRepo>(
    () => ApiRepo(
      client: sl(),
    ),
  );

  Dio client = Dio(
    BaseOptions(
      contentType: 'application/json',
    ),
  );
  sl.registerLazySingleton<Dio>(() => client);

  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton<SharedPreferences>(() => sharedPreferences);

  sl.registerLazySingleton(() => AuthBloc());
  sl.registerLazySingleton(() => HomeBloc());
  sl.registerLazySingleton(() => NewsBloc());
  sl.registerLazySingleton(() => POIBloc());
  sl.registerLazySingleton(() => WeatherBloc());

  sl.registerLazySingleton(() => NavigationService());
}
