import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieshows/models/trending_movies.dart';
import 'package:palette_generator/palette_generator.dart';

import 'app_loader.dart';

class MovieShowsCard extends StatefulWidget {
  const MovieShowsCard({
    Key key,
    @required this.showList,
    @required this.images,
  }) : super(key: key);

  final List<AllTrending> showList;
  final List<String> images;
  @override
  _MovieShowsCardState createState() => _MovieShowsCardState();
}

class _MovieShowsCardState extends State<MovieShowsCard> {
  List<PaletteColor> bgColors;
  int _currentIndex = 1;
  var list = [];
  var isLoading = true;

  @override
  void initState() {
    super.initState();
    //_updatePaletteGenerator(0);
  }

  var snapshot;
  Future<void> _updatePaletteGenerator(int index) async {
    var imgpath = widget.images[index];
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(imgpath).image,
    );
    setState(() {
      snapshot = paletteGenerator.dominantColor.color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: snapshot,
      child: CarouselSlider(
        options: CarouselOptions(
            height: 600.0,
            onPageChanged: (index, reason) {
              _updatePaletteGenerator(index);
              setState(() {
                _currentIndex = index;
              });
            }),
        items: widget.showList.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return Container(
                margin: EdgeInsets.all(5),
                child: Stack(
                  alignment: Alignment.bottomLeft,
                  children: [
                    Material(
                      elevation: 2,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(5),
                        topRight: Radius.circular(30),
                        bottomLeft: Radius.circular(30),
                        bottomRight: Radius.circular(5),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(5),
                          topRight: Radius.circular(30),
                          bottomLeft: Radius.circular(30),
                          bottomRight: Radius.circular(5),
                        ),
                        child: CachedNetworkImage(
                          imageUrl: item.posterPath != null
                              ? "https://image.tmdb.org/t/p/original${item.posterPath}"
                              : "https://logowik.com/content/uploads/images/flutter5786.jpg",
                          imageBuilder: (context, imageProvider) => Container(
                            decoration: BoxDecoration(
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(.3),
                                    BlendMode.hue),
                              ),
                            ),
                          ),
                          placeholder: (context, url) => AppLoader(
                            wdth: 100.0,
                            hght: 100.0,
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                      ),
                    ),
                    Positioned(
                        right: 0.0,
                        top: 0.0,
                        child: ClipOval(
                          child: Container(
                            width: 30.0,
                            height: 30.0,
                            decoration: BoxDecoration(color: Colors.red),
                            child: Center(
                                child: Text(
                              item.voteAverage != null
                                  ? item.voteAverage.toString()
                                  : "0.0",
                              style: GoogleFonts.quicksand(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            )),
                          ),
                        )),
                  ],
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
