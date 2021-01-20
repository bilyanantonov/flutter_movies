import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_movies/repositories/repository.dart';

enum MovieViewState { Idle, Busy, Loaded, NoItem }

class MovieViewModel with ChangeNotifier {
  MovieViewState _state = MovieViewState.Idle;
  Repository _repository = locator<Repository>();
  int _page;
  String _name;
  bool canGetMore = true;

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
    _page = page;
    _name = name;
    try {
      state = MovieViewState.Busy;
      await getFavorites();
      List<Movie> _movies = await _repository.getMovies(page, name);
      movieList.clear();
      if (_movies.length > 0) {
        state = MovieViewState.Loaded;
        movieList.addAll(_movies);
        _page++;
      } else {
        state = MovieViewState.NoItem;
      }
    } catch (e) {
      state = MovieViewState.NoItem;
    }
  }

  Future<void> getMoreMovies() async {
    if (canGetMore) {
      try {
        canGetMore = false;
        await getFavorites();
        List<Movie> _movies = await _repository.getMovies(_page, _name);
        if (_movies.length > 0) {
          movieList.addAll(_movies);
          _page++;
          canGetMore = true;
        }
      } catch (e) {
        canGetMore = true;
        print("no more item");
      }
    }
  }

  bool checkFav(Movie movie) {
    var result = _favoriteList
        .singleWhere((element) => element.imdbID == movie.imdbID, orElse: () {
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

  Future<int> addFavorite(Movie movie) async {
    var result = await _repository.addFavorite(movie);
    if (result > 0) {
      favoriteList.add(Favorite(
          title: movie.title,
          year: movie.year,
          imdbID: movie.imdbID,
          type: movie.type,
          poster: movie.poster));
    }
    return result;
  }

  Future<int> removeFavorite(Movie movie) async {
    var result = await _repository.removeFavorite(movie);
    if (result > 0) {
      favoriteList.removeWhere((element) => element.imdbID == movie.imdbID);
    }
    return result;
  }
}
