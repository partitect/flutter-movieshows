import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieshows/models/trending_movies.dart';
import 'package:http/http.dart' as http;
import 'package:movieshows/widgets/movie_shows_card.dart';

class ShowsScreen extends StatefulWidget {
  @override
  _ShowsScreenState createState() => _ShowsScreenState();
}

class _ShowsScreenState extends State<ShowsScreen> {
  AllTrending shows = AllTrending();
  List<AllTrending> showList = [];

  getData() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/trending/tv/week?api_key=79f9638dc1bcf9a4e5a09db68640db20&language=tr");
    var response = await http.get(url);
    var decodedShows;
    if (response.statusCode == 200) {
      decodedShows = json.decode(response.body);
      setState(() {
        for (var item in decodedShows["results"]) {
          showList.add(AllTrending.fromJson(item));
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
      body: SingleChildScrollView(
        child: Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 120),
            height: MediaQuery.of(context).size.height,
            child: MovieShowsCard(showList: showList)),
      ),
    );
  }
}
