import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:eat_os_interview/data/api_repository.dart';
import 'package:eat_os_interview/models/news.dart';
import 'package:equatable/equatable.dart';

import '../../../di.dart';

part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  NewsBloc() : super(NewsState());

  News news;

  @override
  Stream<NewsState> mapEventToState(
    NewsEvent event,
  ) async* {
    if (event is GetNews) {
      if (event.refresh || news == null) {
        yield state.copyWith(
          loading: true,
        );

        news = await getNews(countryCode: event.countryCode);
      }

      yield state.copyWith(
        loading: false,
        places: news,
      );
    }
  }

  Future<News> getNews({String countryCode}) async {
    return await sl<ApiRepo>().getNews(
      parameters: {
        'country': countryCode,
        'category': 'business',
        'apiKey': '28cb80152e7c4f3fbbeebf6620c41544',
      },
    );
  }
}
