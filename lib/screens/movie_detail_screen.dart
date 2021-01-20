import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_movies/models/models.dart';
import 'package:flutter_movies/view_models/view_models.dart';
import 'package:provider/provider.dart';

class MovieDetailScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.white,
            leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.blue),
                onPressed: () {
                  Navigator.pop(context);
                }),
            title: Text(
              "Movie Detail",
              style: TextStyle(color: Colors.blue),
            )),
        body: Container(child: Consumer<MovieDetailViewModel>(
            builder: (context, movieDetailModel, child) {
          if (movieDetailModel.state == MovieDetailViewState.Loaded) {
            return _page(context, movieDetailModel.movie);
            // return Container(
            //   child: Text(movieDetailModel.movie.title),
            // );
          } else if (movieDetailModel.state == MovieDetailViewState.Busy) {
            return Center(child: CircularProgressIndicator());
          } else if (movieDetailModel.state == MovieDetailViewState.NoItem) {
            return Center(
              child: Text("No Movie"),
            );
          } else {
            return Center();
          }
        })));
  }

  _page(BuildContext context, Movie movie) {
    return SingleChildScrollView(
      physics: BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(movie),
          _buildRow("Released", movie.released),
           _buildRow("Director", movie.director),
          _buildRow("Actors", movie.actors),
          _buildRow("Writer", movie.writer),
          _buildRow("Plot", movie.plot)
        ],
      ),
    );
  }

  _header(Movie movie) {
    return Container(
      height: 220,
      child: Stack(
        children: [
          Stack(
            children: [
              CachedNetworkImage(
                imageBuilder: (context, imageProvider) => Container(
                  height: 220,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                      // colorFilter:
                      //     ColorFilter.mode(Colors.black, BlendMode.colorDodge)
                    ),
                  ),
                ),
                imageUrl: movie.poster,
                placeholder: (context, url) => Center(
                  child: Icon(Icons.image, size: 80, color: Colors.grey),
                ),
                errorWidget: (context, url, error) =>
                    Icon(Icons.error, size: 80, color: Colors.grey),
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                ),
              ),
              // Container(color : Colors.black)
            ],
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CachedNetworkImage(
                    imageBuilder: (context, imageProvider) => Container(
                      height: 200,
                      width: 120,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    imageUrl: movie.poster,
                    placeholder: (context, url) => Center(
                      child: Icon(Icons.image, size: 80, color: Colors.grey),
                    ),
                    errorWidget: (context, url, error) =>
                        Icon(Icons.error, size: 80, color: Colors.grey),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.access_time_outlined,
                            color: Colors.white,
                          ),
                          SizedBox(width: 10),
                          Text(movie.runtime,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 12)),
                          SizedBox(width: 10),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 1),
                            alignment: Alignment.center,
                            height: 20,
                            decoration: BoxDecoration(
                                border: Border.all(color: Colors.white)),
                            child: Text(movie.rated,
                                style: TextStyle(
                                    color: Colors.white, fontSize: 12)),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(movie.title,
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        width: 200,
                        child: Text(movie.genre,
                            style:
                                TextStyle(color: Colors.white, fontSize: 12)),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                          width: 200,
                          child: Text(movie.production,
                              style: TextStyle(
                                  color: Colors.white, fontSize: 12))),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.brightness_1, color: Colors.red),
                              Text(movie.metascore,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12))
                            ],
                          ),
                          SizedBox(width: 10),
                          Row(
                            children: [
                              Icon(Icons.brightness_1, color: Colors.green),
                              Text(movie.imdbRating,
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12))
                            ],
                          )
                        ],
                      )
                    ],
                  )
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildRow(String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w600),
          ),
          Text(
            description,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          Divider(color: Colors.grey,height: 1,)
        ],
      ),
    );
  }
}
