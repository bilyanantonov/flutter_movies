import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/services/services.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RemoteService implements RemoteBase{

  @override
  Future<List<Movie>> getMovies(int page) async {
    final url = 'https://www.omdbapi.com/?s=batman&apikey=c9f946ff&page=${page}';
    final headers = {'Accept': 'application/json'};
    final result = await http.get(url, headers: headers);
    if (result.statusCode == 200) {
      final searchResult = (SearchResult.fromJson(json.decode(result.body)));
      // return await Future.delayed(Duration(seconds: 1), () => searchResult.movies);
      return searchResult.movies.toList();
    } else {
      throw Exception("Bağlanamadık ${result.statusCode}");
    }
  }
  
}