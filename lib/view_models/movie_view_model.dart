import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_movies/repositories/repository.dart';
import 'package:flutter_movies/view_models/view_models.dart';

enum MovieViewState { Idle, Busy, Loaded, NoItem }

class MovieViewModel with ChangeNotifier {
  MovieViewState _state = MovieViewState.Idle;
  Repository _repository = locator<Repository>();

  MovieViewState get state => _state;
  set state(MovieViewState value) {
    _state = value;
    notifyListeners();
  }

  List<Movie> _movieList;
  List<Movie> get movieList => _movieList;

  MovieViewModel() {
    _movieList = [];
    getMovies(1);
  }

  void getMovies(int page) async {
    try {
      state = MovieViewState.Busy;
      List<Movie> _movies = await _repository.getMovies(page);
      if (_movies.length > 0) {
        state = MovieViewState.Loaded;
        movieList.addAll(_movies);
      } else {
        state = MovieViewState.NoItem;
      }
    } catch (e) {
      state = MovieViewState.NoItem;
    }
  }
}
