import 'package:flutter/material.dart';
import 'package:flutter_app_fontend/bloc/bloc/post_bloc.dart';
import 'utils/route/app_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'ui/home_page_screen.dart';
import 'utils/route/route_name.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => PostBloc(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        navigatorObservers: [AppRoute.observer],
        initialRoute: RouteName.Main,
        onGenerateRoute: AppRoute.GenecateRouteSetting,
      ),
    );
  }
}
