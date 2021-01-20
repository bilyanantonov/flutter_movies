import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/repositories/repositories.dart';
import 'package:flutter_movies/utils/utils.dart';

enum MovieDetailViewState { Idle, Busy, Loaded, NoItem }

class MovieDetailViewModel with ChangeNotifier {
  MovieDetailViewState _state = MovieDetailViewState.Idle;
  Repository _repository = locator<Repository>();

  MovieDetailViewState get state => _state;
  set state(MovieDetailViewState value) {
    _state = value;
    notifyListeners();
  }

  Movie _movie;
  Movie get movie => _movie;

  void getMovie(String imdbID) async {
    try {
      state = MovieDetailViewState.Busy;
      Movie _m = await _repository.getMovie(imdbID);
      if (_m != null) {
        state = MovieDetailViewState.Loaded;
        _movie = _m;
      } else {
        state = MovieDetailViewState.NoItem;
      }
    } catch (e) {
      state = MovieDetailViewState.NoItem;
    }
  }
}
