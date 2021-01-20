class Favorite {
  String title;
  String year;
  String imdbID;
  String type;
  String poster;
  Favorite({this.title, this.year, this.imdbID, this.type, this.poster});

  Favorite.fromMap(Map<String, dynamic> map) {
    this.title = map['title'] ?? '';
    this.year = map['year'] ?? '';
    this.imdbID = map['imdbID'] ?? '';
    this.type = map['type'] ?? '';
    this.poster = map['poster'] ?? 'https://dummyimage.com/720x1280/fff/aaa';
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    map['Title'] = title;
    map['Year'] = year;
    map['imdbID'] = imdbID;
    map['Type'] = type;
    map['Poster'] = poster;
    return map;
  }
}
