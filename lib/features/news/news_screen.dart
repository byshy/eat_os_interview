import 'package:eat_os_interview/utils/global_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../di.dart';
import 'bloc/news_bloc.dart';

class NewsScreen extends StatefulWidget {
  final String countryCode;

  const NewsScreen({Key key, this.countryCode}) : super(key: key);

  @override
  _NewsScreenState createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  @override
  void initState() {
    super.initState();
    sl<NewsBloc>().add(GetNews(countryCode: widget.countryCode));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text(
          'News',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (_, state) {
          if (state.loading) {
            return LoadingIndicator();
          }

          return RefreshIndicator(
            onRefresh: () {
              sl<NewsBloc>().add(GetNews(
                countryCode: widget.countryCode,
                refresh: true,
              ));

              return Future.value();
            },
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              itemCount: state.news?.articles?.length ?? 0,
              itemBuilder: (_, index) => ListTile(
                title: Text(state.news.articles[index].title),
              ),
              separatorBuilder: (_, index) => Divider(),
            ),
          );
        },
      ),
    );
  }
}
