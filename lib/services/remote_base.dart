import 'package:flutter_movies/models/models.dart';

abstract class RemoteBase {
  Future<List<Movie>> getMovies(int page);
}