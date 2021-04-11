// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

AllTrending welcomeFromJson(String str) =>
    AllTrending.fromJson(json.decode(str));

String welcomeToJson(AllTrending data) => json.encode(data.toJson());

class AllTrending {
  AllTrending({
    this.originalName,
    this.originCountry,
    this.overview,
    this.backdropPath,
    this.voteCount,
    this.genreIds,
    this.id,
    this.originalLanguage,
    this.name,
    this.title,
    this.posterPath,
    this.voteAverage,
    this.popularity,
    this.mediaType,
  });

  DateTime firstAirDate;
  String originalName;
  List<String> originCountry;
  String overview;
  String backdropPath;
  int voteCount;
  List<int> genreIds;
  int id;
  String originalLanguage;
  String name;
  String title;
  String posterPath;
  double voteAverage;
  double popularity;
  String mediaType;

  factory AllTrending.fromJson(Map<String, dynamic> json) => AllTrending(
        originalName: json["original_name"],
        overview: json["overview"],
        backdropPath: json["backdrop_path"],
        voteCount: json["vote_count"],
        genreIds: List<int>.from(json["genre_ids"].map((x) => x)),
        id: json["id"],
        originalLanguage: json["original_language"],
        name: json["name"],
        title: json["title"],
        posterPath: json["poster_path"],
        voteAverage: json["vote_average"].toDouble(),
        popularity: json["popularity"].toDouble(),
        mediaType: json["media_type"],
      );

  Map<String, dynamic> toJson() => {
        "first_air_date":
            "${firstAirDate.year.toString().padLeft(4, '0')}-${firstAirDate.month.toString().padLeft(2, '0')}-${firstAirDate.day.toString().padLeft(2, '0')}",
        "original_name": originalName,
        "origin_country": List<dynamic>.from(originCountry.map((x) => x)),
        "overview": overview,
        "backdrop_path": backdropPath,
        "vote_count": voteCount,
        "genre_ids": List<dynamic>.from(genreIds.map((x) => x)),
        "id": id,
        "original_language": originalLanguage,
        "name": name,
        "title": title,
        "poster_path": posterPath,
        "vote_average": voteAverage,
        "popularity": popularity,
        "media_type": mediaType,
      };
}
