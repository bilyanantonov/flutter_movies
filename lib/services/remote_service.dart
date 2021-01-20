import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/services/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemoteService implements RemoteBase{

  @override
  Future<List<Movie>> getMovies(int page, String name) async {
    final url = 'https://www.omdbapi.com/?s=${name}&apikey=c9f946ff&page=${page}';
    final headers = {'Accept': 'application/json'};
    final result = await http.get(url, headers: headers);
    if (result.statusCode == 200) {
      final searchResult = (SearchResult.fromJson(json.decode(result.body)));
      return searchResult.movies.toList();
    } else {
      throw Exception("Connection problem ${result.statusCode}");
    }
  }

  @override
  Future<Movie> getMovie(String imdbID) async {
    final url = 'https://www.omdbapi.com/?i=${imdbID}&apikey=c9f946ff';
    final headers = {'Accept': 'application/json'};
    final result = await http.get(url, headers: headers);
    if (result.statusCode == 200) {
      final movie = (Movie.fromJson(json.decode(result.body)));
      return movie;
    } else {
      throw Exception("Connection problem ${result.statusCode}");
    }
  }
  
}