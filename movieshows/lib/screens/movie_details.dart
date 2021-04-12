import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieshows/models/movie_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:movieshows/widgets/app_loader.dart';
import 'package:glassmorphism/glassmorphism.dart';

class MovieDetailsScreen extends StatefulWidget {
  final ids;

  const MovieDetailsScreen({Key key, this.ids}) : super(key: key);
  @override
  _MovieDetailsScreenState createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  MovieDetailsModel movies = MovieDetailsModel();
  bool isLoading = true;
  getData() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/${widget.ids}?api_key=79f9638dc1bcf9a4e5a09db68640db20&language=tr-TR");
    var response = await http.get(url);
    var decodedMovie;
    if (response.statusCode == 200) {
      decodedMovie = json.decode(response.body);
      setState(() {
        movies = MovieDetailsModel.fromJson(decodedMovie);
        isLoading = false;
      });
    }
    print(movies);
  }

  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,

      /*   appBar: AppBar(
        title: isLoading == false
            ? Text(movies.title)
            : AppLoader(
                wdth: 40.0,
                hght: 40.0,
              ),
      ), */
      body: CachedNetworkImage(
        imageUrl: movies.backdropPath != null
            ? "https://image.tmdb.org/t/p/original${movies.backdropPath}"
            : "https://logowik.com/content/uploads/images/flutter5786.jpg",
        imageBuilder: (context, imageProvider) => Stack(
          alignment: Alignment.bottomCenter,
          children: [
            ShaderMask(
              shaderCallback: (rect) {
                return LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(1),
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(0),
                    Colors.black.withOpacity(.5),
                  ],
                ).createShader(
                    Rect.fromLTRB(0, -140, rect.width, rect.height - 20));
              },
              blendMode: BlendMode.darken,
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                    colorFilter: new ColorFilter.mode(
                        Colors.blue.withOpacity(.1), BlendMode.color),
                  ),
                ),
              ),
            ),
            GlassmorphicContainer(
              width: MediaQuery.of(context).size.width - 50,
              height: 250,
              borderRadius: 20,
              blur: 5,
              margin: EdgeInsets.only(bottom: 50),
              alignment: Alignment.bottomCenter,
              border: 0,
              linearGradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFFffffff).withOpacity(0.1),
                    Color(0xFFFFFFFF).withOpacity(0.05),
                  ],
                  stops: [
                    0.1,
                    1,
                  ]),
              borderGradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFFffffff).withOpacity(0.5),
                  Color((0xFFFFFFFF)).withOpacity(0.5),
                ],
              ),
              child: Center(
                child: Text(
                  movies.title.toString(),
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        placeholder: (context, url) => AppLoader(
          wdth: 100.0,
          hght: 100.0,
        ),
        errorWidget: (context, url, error) => Icon(Icons.error),
      ),
    );
  }
}
