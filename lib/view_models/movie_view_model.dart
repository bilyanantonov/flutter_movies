import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_movies/repositories/repository.dart';

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

  List<Favorite> _favoriteList;
  List<Favorite> get favoriteList => _favoriteList;

  MovieViewModel(int page, String name) {
    _movieList = [];
    _favoriteList = [];
    getMovies(page, name);
  }

  void getMovies(int page, String name) async {
    try {
      state = MovieViewState.Busy;
      await getFavorites();
      List<Movie> _movies = await _repository.getMovies(page, name);
      movieList.clear();
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

  bool checkFav(String imdbID) {
    var result = _favoriteList
        .singleWhere((element) => element.imdbID == imdbID, orElse: () {
      return null;
    });
    if (result != null) {
      return true;
    } else {
      return false;
    }
  }

  Future<void> getFavorites() async {
    List<Favorite> _favs = await _repository.getFavorites();
    if (_favs.length > 0) {
      favoriteList.clear();
      favoriteList.addAll(_favs);
    }
  }

  Future<int> addFavorite(String imdbID) async {
    var result = await _repository.addFavorite(imdbID);
    if (result > 0) {
      favoriteList.add(Favorite(imdbID: imdbID));
    }
    return result;
  }

  Future<int> removeFavorite(String imdbID) async {
    var result = await _repository.removeFavorite(imdbID);
    if (result > 0) {
      favoriteList.removeWhere((element) => element.imdbID == imdbID);
    }
    return result;
  }
}
