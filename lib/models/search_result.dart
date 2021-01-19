import 'package:flutter_movies/models/models.dart';

class SearchResult {
  List<Movie> movies;
  String totalResults;
  String response;

  SearchResult({this.movies, this.totalResults, this.response});

  SearchResult.fromJson(Map<String, dynamic> json) {
    if (json['Search'] != null) {
      movies = new List<Movie>();
      json['Search'].forEach((v) {
        movies.add(new Movie.fromJson(v));
      });
    }
    totalResults = json['totalResults'];
    response = json['Response'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.movies != null) {
      data['Search'] = this.movies.map((v) => v.toJson()).toList();
    }
    data['totalResults'] = this.totalResults;
    data['Response'] = this.response;
    return data;
  }
}
