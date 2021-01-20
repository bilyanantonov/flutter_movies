import 'package:flutter/material.dart';
import 'package:flutter_movies/screens/screens.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_movies/view_models/view_models.dart';
import 'package:provider/provider.dart';

void main() {
  setupLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<MovieViewModel>(
          create: (context) => MovieViewModel(1, "batman"),
        ),
        ChangeNotifierProvider<MovieDetailViewModel>(
          create: (context) => MovieDetailViewModel(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Movies',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: TestScreen(),
      ),
    );
  }
}
