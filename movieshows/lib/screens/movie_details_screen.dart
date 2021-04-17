import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieshows/models/movie_details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:movieshows/widgets/lottie_loader.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieDetails extends StatefulWidget {
  final ids;

  const MovieDetails({Key key, this.ids}) : super(key: key);
  @override
  _MovieDetailsState createState() => _MovieDetailsState();
}

class _MovieDetailsState extends State<MovieDetails> {
  MovieDetailsModel movies = MovieDetailsModel();
  bool isLoading = true;
  var containerColor;
  var contentColor;
  var titleColor;
  var like = 0;
  getData() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/movie/${widget.ids}?api_key=79f9638dc1bcf9a4e5a09db68640db20&language=tr-TR");
    var response = await http.get(url);
    var decodedMovie;
    if (response.statusCode == 200) {
      decodedMovie = json.decode(response.body);

      setState(() {
        movies = MovieDetailsModel.fromJson(decodedMovie);
      });

      var paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.network(
                "https://image.tmdb.org/t/p/original${movies.backdropPath}")
            .image,
      );
      setState(() {
        isLoading = false;
        containerColor = paletteGenerator.dominantColor.color.withOpacity(.8);
        titleColor = paletteGenerator.dominantColor.titleTextColor;
        contentColor = paletteGenerator.dominantColor.bodyTextColor;
      });
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
        extendBody: true,
        body: isLoading == false
            ? CachedNetworkImage(
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
                        ).createShader(Rect.fromLTRB(
                            0, -140, rect.width, rect.height - 20));
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
                                Colors.black.withOpacity(.2), BlendMode.darken),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 50),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.pop(context);
                                  },
                                  child: SvgPicture.asset(
                                    'assets/svg/arrow_back.svg',
                                    height: 30.0,
                                    width: 30.0,
                                    color: Colors.white,
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      like = like == 0 ? 1 : 0;
                                    });
                                    final snackbar = SnackBar(
                                      backgroundColor: Colors.green,
                                      content: Container(
                                        width: double.infinity,
                                        padding: EdgeInsets.only(bottom: 0),
                                        height: 40,
                                        child: Center(
                                          child: Text(
                                            like == 1
                                                ? "Favorilere Eklendi"
                                                : "Favorilerden Çıkartıldı",
                                            style: GoogleFonts.exo2(
                                              textStyle: TextStyle(
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    );
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(snackbar);
                                  },
                                  child: SvgPicture.asset(
                                      like == 0
                                          ? 'assets/svg/follow.svg'
                                          : 'assets/svg/following.svg',
                                      height: 30.0,
                                      width: 30.0,
                                      color: like == 0
                                          ? Colors.white
                                          : contentColor),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 100),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SvgPicture.asset(
                                      'assets/svg/messege.svg',
                                      height: 30.0,
                                      width: 30.0,
                                      color: Colors.white,
                                    ),
                                    Container(
                                      child: Text(
                                        movies.voteAverage.toString(),
                                        style: GoogleFonts.exo2(
                                          textStyle: TextStyle(
                                            color: Colors.white,
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/visible.svg',
                                    height: 30.0,
                                    width: 30.0,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    child: Text(
                                      movies.voteCount
                                          .toString()
                                          .substring(0, 3),
                                      style: GoogleFonts.exo2(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    'assets/svg/collect.svg',
                                    height: 30.0,
                                    width: 30.0,
                                    color: Colors.white,
                                  ),
                                  Container(
                                    child: Text(
                                      movies.popularity
                                          .toString()
                                          .substring(0, 3),
                                      style: GoogleFonts.exo2(
                                        textStyle: TextStyle(
                                          color: Colors.white,
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(10),
                            width: MediaQuery.of(context).size.width - 50,
                            height: 250,
                            margin: EdgeInsets.only(bottom: 50),
                            alignment: Alignment.bottomCenter,
                            decoration: BoxDecoration(
                              color: containerColor,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  movies.title.toString(),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: titleColor,
                                      fontSize: 30,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  movies.overview.toString(),
                                  style: GoogleFonts.quicksand(
                                    textStyle: TextStyle(
                                      color: contentColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  textAlign: TextAlign.center,
                                  maxLines: 8,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                placeholder: (context, url) => LottieLoader(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : Center(child: LottieLoader()));
  }
}
