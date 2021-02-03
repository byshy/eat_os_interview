import 'package:flutter/material.dart';

import 'di.dart';
// TODO: export them all as one or only routes and navigation_service
import 'routing/navigation_service.dart';
import 'routing/router.dart' as router;
import 'routing/routes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await init();

  runApp(App());
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Basel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      navigatorKey: sl<NavigationService>().navigatorKey,
      initialRoute: home,
      // initialRoute: login,
      onGenerateRoute: router.Router.generateRoute,
    );
  }
}
