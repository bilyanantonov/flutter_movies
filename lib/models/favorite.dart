class Favorite{
  String imdbID;
  Favorite({this.imdbID});

  factory Favorite.fromMap(Map data) {
    return Favorite(imdbID:data['imdbID']);
  }

  Map<String, dynamic> toMap() {
    return {
      "imdbID": imdbID
    };
  }
}