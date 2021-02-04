part of 'news_bloc.dart';

abstract class NewsEvent extends Equatable {
  const NewsEvent();
}

class GetNews extends NewsEvent {
  final String countryCode;
  final bool refresh;

  GetNews({
    this.countryCode,
    this.refresh = false,
  });

  @override
  List<Object> get props => [countryCode, refresh];
}
