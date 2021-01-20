import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/screens/screens.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_movies/view_models/movie_view_model.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  List<String> favorites = ["tt0118688"];
  TextEditingController _textEditingController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  void setFavorite(Movie movie, MovieViewModel movieViewModel) async {
    if (movieViewModel.checkFav(movie)) {
      await movieViewModel.removeFavorite(movie);
      setState(() {});
    } else {
      await movieViewModel.addFavorite(movie);
      setState(() {});
    }
  }

  void navigateToFavoriteScreen() async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => FavoriteMoviesScreen(),
        ));

    if (result) {
      setState(() {});
    }
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(builder: (context) => FavoriteMoviesScreen()),
    // );
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    MovieViewModel _movieViewModel = Provider.of<MovieViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Movies",
          style: TextStyle(color: Colors.blue),
        ),
        actions: [
          RaisedButton(
            color: Colors.white,
            child: Text(
              "Favorites",
              style: TextStyle(color: Colors.blue),
            ),
            onPressed: () {
              navigateToFavoriteScreen();
              // List<Favorite> favorites = [];
              // favorites.addAll(_movieViewModel.favoriteList);
              // for (var item in favorites) {
              //   print(item.title);
              // }
            },
          )
        ],
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          _searchBar(_movieViewModel),
          Expanded(
            child:
                Consumer<MovieViewModel>(builder: (context, movieModel, child) {
              if (movieModel.state == MovieViewState.Loaded) {
                return Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: GridView.builder(
                    itemCount: movieModel.movieList.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.5,
                        crossAxisCount:
                            (orientation == Orientation.portrait) ? 2 : 3),
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return _buildMovieCard(context,
                          movieModel.movieList[index], _movieViewModel);
                    },
                  ),
                );
              } else if (movieModel.state == MovieViewState.Busy) {
                return Center(child: CircularProgressIndicator());
              } else if (movieModel.state == MovieViewState.NoItem) {
                return Center(
                  child: Text("No Movie"),
                );
              } else {
                return Center();
              }
            }),
          ),
        ],
      ),
    );
  }

  _buildMovieCard(
      BuildContext context, Movie movie, MovieViewModel movieViewModel) {
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
                    image: NetworkImage(movie.poster), fit: BoxFit.cover),
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
                    movie.title,
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
                Text(movie.year,
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
                opacity: movieViewModel.checkFav(movie) ? 1 : 0.4,
                child: Container(
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(30)),
                  child: IconButton(
                      icon: Icon(Icons.star),
                      iconSize: 30,
                      color: Colors.white,
                      onPressed: () {
                        setFavorite(movie, movieViewModel);
                        setState(() {});
                      }),
                ),
              ))
        ],
      ),
    );
  }

  _searchBar(MovieViewModel movieViewModel) {
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
              onPressed: () {
                _textEditingController.clear();
              },
            )),
        controller: _textEditingController,
        onEditingComplete: () {
          var validateSearch =
              ValidationHelper.validateSearchText(_textEditingController.text);
          if (validateSearch != null) {
            print(validateSearch);
            FocusScope.of(context).unfocus();
            Future.delayed(const Duration(milliseconds: 500), () {
              AlertMessage.alertMessage(context, "Warning", validateSearch);
            });
          } else {
            movieViewModel.getMovies(1, _textEditingController.text);
            FocusScope.of(context).unfocus();
          }
        },
      ),
    );
  }
}
