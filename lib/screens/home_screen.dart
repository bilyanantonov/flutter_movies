import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    // listMovies();
  }

  void listMovies() async {
    List<Movie> movies = await getMovies();
    for (var movie in movies) {
      print(movie.title);
    }
  }

  Future<List<Movie>> getMovies() async {
    final url = 'https://www.omdbapi.com/?s=batman&apikey=c9f946ff&page=1';
    final headers = {'Accept': 'application/json'};
    final result = await http.get(url, headers: headers);
    if (result.statusCode == 200) {
      final searchResult = (SearchResult.fromJson(json.decode(result.body)));
      return searchResult.movies.toList();
    } else {
      throw Exception("Bağlanamadık ${result.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Movies")),
      body: FutureBuilder(
          future: getMovies(),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasData) {
              return ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return buildMovieCard(context, snapshot, index);
                  });
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  Widget buildMovieCard(
      BuildContext context, AsyncSnapshot<List<Movie>> snapshot, int index) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.black,
          child: Image(
            image: NetworkImage(snapshot.data[index].poster.toString()),
            height: 300,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
        ),
        Container(
          color: Color.fromRGBO(0, 0, 0, 0.5),
          height: 300,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  snapshot.data[index].title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                child: Text(
                  snapshot.data[index].year,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400),
                ),
              )
            ],
          ),
        ),
      ],
    );
  }
}
