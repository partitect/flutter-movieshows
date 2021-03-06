import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:movieshows/models/trending_movies.dart';
import 'package:http/http.dart' as http;
import 'package:movieshows/widgets/movie_shows_card.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  AllTrending shows = AllTrending();
  List<AllTrending> showList = [];
  List<String> images = [];
  getData() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/trending/all/day?api_key=79f9638dc1bcf9a4e5a09db68640db20&language=tr");
    var response = await http.get(url);
    var decodedShows;
    if (response.statusCode == 200) {
      decodedShows = json.decode(response.body);
      setState(() {
        for (var item in decodedShows["results"]) {
          showList.add(AllTrending.fromJson(item));
          images.add(
              "https://image.tmdb.org/t/p/original${AllTrending.fromJson(item).backdropPath}");
        }
      });
      //print(showList[0].name);
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        //padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 120),
        height: MediaQuery.of(context).size.height,
        child: MovieShowsCard(
          showList: showList,
          images: images,
        ),
      ),
    );
  }
}
