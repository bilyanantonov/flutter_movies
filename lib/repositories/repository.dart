import 'package:flutter_movies/models/movie.dart';
import 'package:flutter_movies/services/services.dart';
import 'package:flutter_movies/utils/utils.dart';

enum AppMode {Debug, Release}

class Repository implements RemoteBase{
 
  AppMode appMode = AppMode.Debug;
  RemoteService _remoteService = locator<RemoteService>();

   @override
  Future<List<Movie>> getMovies(int page, String name) {
    if(appMode == AppMode.Debug){
      return _remoteService.getMovies(page, name);
    }else{
      return null;
    }
  }
}