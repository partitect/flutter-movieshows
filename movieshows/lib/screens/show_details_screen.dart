import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:movieshows/models/show_details.dart';
import 'dart:convert';

import 'package:movieshows/widgets/app_loader.dart';
import 'package:palette_generator/palette_generator.dart';

class ShowDetails extends StatefulWidget {
  final ids;

  const ShowDetails({Key key, this.ids}) : super(key: key);
  @override
  _ShowDetailsState createState() => _ShowDetailsState();
}

class _ShowDetailsState extends State<ShowDetails> {
  ShowDetailsModel movies = ShowDetailsModel();
  bool isLoading = true;
  var containerColor;
  var contentColor;
  var titleColor;
  getData() async {
    var url = Uri.parse(
        "https://api.themoviedb.org/3/tv/${widget.ids}?api_key=79f9638dc1bcf9a4e5a09db68640db20&language=tr-TR");
    var response = await http.get(url);
    var decodedMovie;
    if (response.statusCode == 200) {
      decodedMovie = json.decode(response.body);

      setState(() {
        movies = ShowDetailsModel.fromJson(decodedMovie);
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

        /*   appBar: AppBar(
        title: isLoading == false
            ? Text(movies.title)
            : AppLoader(
                wdth: 40.0,
                hght: 40.0,
              ),
      ), */
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
                                Colors.blue.withOpacity(.1), BlendMode.color),
                          ),
                        ),
                      ),
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
                            movies.name.toString(),
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
                    ),
                  ],
                ),
                placeholder: (context, url) => AppLoader(
                  wdth: 100.0,
                  hght: 100.0,
                ),
                errorWidget: (context, url, error) => Icon(Icons.error),
              )
            : Center(child: CircularProgressIndicator()));
  }
}
