part of 'news_bloc.dart';

class NewsState extends Equatable {
  final News news;
  final bool loading;

  const NewsState({
    this.news,
    this.loading = false,
  });

  NewsState copyWith({
    News places,
    bool loading,
  }) {
    return NewsState(
      news: places ?? this.news,
      loading: loading ?? this.loading,
    );
  }

  @override
  List<Object> get props => [
        news,
        loading,
      ];
}
