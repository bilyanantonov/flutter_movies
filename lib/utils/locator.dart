import 'package:flutter_movies/repositories/repositories.dart';
import 'package:flutter_movies/services/services.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;
void setupLocator(){
  locator.registerLazySingleton(() => RemoteService());
  locator.registerLazySingleton(() => Repository());
}