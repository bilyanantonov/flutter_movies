import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/utils/utils.dart';
import 'package:flutter_movies/view_models/view_models.dart';
import 'package:provider/provider.dart';

class FavoriteMoviesScreen extends StatefulWidget {
  @override
  _FavoriteMoviesScreenState createState() => _FavoriteMoviesScreenState();
}

class _FavoriteMoviesScreenState extends State<FavoriteMoviesScreen> {
  Future<bool> _onBackPressed() {
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final orientation = MediaQuery.of(context).orientation;
    MovieViewModel _movieViewModel = Provider.of<MovieViewModel>(context);

    return WillPopScope(
      onWillPop: _onBackPressed,
      child: Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.blue),
              onPressed: () => _onBackPressed(),
            ),
            title: Text(
              "Favorites",
              style: TextStyle(color: Colors.blue),
            )),
        body: Container(
          child:
              Consumer<MovieViewModel>(builder: (context, movieModel, child) {
            if (movieModel.state == MovieViewState.Loaded) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: GridView.builder(
                  itemCount: movieModel.favoriteList.length,
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: 0.5,
                      crossAxisCount:
                          (orientation == Orientation.portrait) ? 2 : 3),
                  physics: BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return _buildMovieCard(context,
                        movieModel.favoriteList[index], _movieViewModel);
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
      ),
    );
  }

  _buildMovieCard(
      BuildContext context, Favorite favMovie, MovieViewModel movieViewModel) {
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
                    image: NetworkImage(favMovie.poster), fit: BoxFit.cover),
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
                    favMovie.title,
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
                Text(favMovie.year,
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
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red, borderRadius: BorderRadius.circular(30)),
              child: IconButton(
                  icon: Icon(Icons.delete),
                  iconSize: 30,
                  color: Colors.white,
                  onPressed: () async {
                    Movie movie = Movie();
                    movie.imdbID = favMovie.imdbID;

                    var result = await RemoveAlert.alertMessage(context);
                    if (result != null) {
                      if (result) {
                        await movieViewModel.removeFavorite(movie);
                        setState(() {});
                      }
                    }
                  }),
            ),
          )
        ],
      ),
    );
  }
}
