import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '/ui/home_page_screen.dart';
import '/utils/route/page_entity.dart';
import '/utils/route/route_name.dart';

class AppRoute {
  static final RouteObserver<Route> observer = RouteObserver();

  // ignore: non_constant_identifier_names
  static List<PageEntity> Routes() {
    return [
      PageEntity(path: RouteName.HomePage, page: HomePageScreen()),
      PageEntity(path: RouteName.Main, page: HomePageScreen()),
    ];
  }

  // ignore: non_constant_identifier_names
  static MaterialPageRoute GenecateRouteSetting(RouteSettings settings) {
    if (settings.name != null) {
      var result = Routes().where((element) => element.path == settings.name);
      if (result.isNotEmpty) {
        return MaterialPageRoute(
            builder: (context) => result.first.page, settings: settings);
      }
    }
    return MaterialPageRoute(
        builder: (context) => HomePageScreen(), settings: settings);
  }
}
