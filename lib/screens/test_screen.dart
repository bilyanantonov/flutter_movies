import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<String> favorites = ["tt0118688"];

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

  void setFavorite(String imdbID) {
    if (!favorites.contains(imdbID)) {
      favorites.add(imdbID);
    } else {
      favorites.remove(imdbID);
    }
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Movies",
          style: TextStyle(color: Colors.blue),
        ),
        backgroundColor: Colors.white,
      ),
      body: FutureBuilder(
          future: getMovies(),
          builder: (BuildContext context, AsyncSnapshot<List<Movie>> snapshot) {
            if (snapshot.hasData) {
              return Column(
                children: [
                  _searchBar(),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: GridView.builder(
                        itemCount: snapshot.data.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: 0.5,
                            crossAxisCount:
                                (orientation == Orientation.portrait) ? 2 : 3),
                        physics: BouncingScrollPhysics(),
                        itemBuilder: (BuildContext context, int index) {
                          return _buildMovieCard(context, snapshot, index);
                        },
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return Center(child: CircularProgressIndicator());
            }
          }),
    );
  }

  _buildMovieCard(
      BuildContext context, AsyncSnapshot<List<Movie>> snapshot, int index) {
    return Container(
      margin: EdgeInsets.only(right: 5, bottom: 5),
      height: 600,
      width: 160,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: NetworkImage(snapshot.data[index].poster),
                    fit: BoxFit.cover),
                borderRadius: BorderRadius.circular(5)),
          ),
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                    colors: [
                      Colors.black,
                      Colors.black87.withOpacity(0.6),
                      Colors.black54.withOpacity(0.3),
                      Colors.black38.withOpacity(0.3)
                    ],
                    stops: [
                      0.1,
                      0.3,
                      0.6,
                      1.0
                    ])),
          ),
          Positioned(
            bottom: 65,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  width: 160,
                  child: Text(
                    snapshot.data[index].title,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(
                  height: 5,
                ),
                Text(snapshot.data[index].year,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2))
              ],
            ),
          ),
          Positioned(
              bottom: 10,
              right: 10,
              child: Opacity(
                opacity:
                    favorites.contains(snapshot.data[index].imdbID) ? 1 : 0.4,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                      icon: Icon(Icons.star),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        setFavorite(snapshot.data[index].imdbID);
                        setState(() {});
                      }),
                ),
              ))
        ],
      ),
    );
  }

  _searchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
      child: TextField(
        decoration: InputDecoration(
            contentPadding: EdgeInsets.symmetric(vertical: 15),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(width: 0.8)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide(
                    width: 0.8, color: Theme.of(context).primaryColor)),
            hintText: 'Search Movie',
            prefixIcon: Icon(
              Icons.search,
              size: 30,
            ),
            suffixIcon: IconButton(
              icon: Icon(Icons.clear),
              onPressed: () {},
            )),
      ),
    );
  }
}
