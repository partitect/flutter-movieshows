import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movieshows/models/trending_movies.dart';
import 'package:movieshows/screens/movie_details_screen.dart';
import 'package:movieshows/screens/show_details_screen.dart';
import 'package:movieshows/widgets/lottie_loader.dart';
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
  int _currentIndex;
  var list = [];
  var isLoading = true;
  var imgpath;
  var snapshot;
  Color clr;
  Future<void> _getFirstColor() async {
    // Imagine that this function is more complex and slow
    Future.delayed(Duration(milliseconds: 1000), () async {
      imgpath = widget.images[_currentIndex];
      var paletteGenerator = await PaletteGenerator.fromImageProvider(
        Image.network(imgpath).image,
      );
      setState(() {
        isLoading = false;
        snapshot = paletteGenerator.dominantColor.color;
      });
    });
  }

  Future<void> _getPaletteGenerator() async {
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(
              "https://image.tmdb.org/t/p/original${widget.showList[_currentIndex].posterPath}")
          .image,
    );
    setState(() {
      snapshot = paletteGenerator.dominantColor.color;
    });
  }

  Future<void> _updatePaletteGenerator(int index) async {
    var imgpath = widget.images[index];
    var paletteGenerator = await PaletteGenerator.fromImageProvider(
      Image.network(imgpath).image,
    );
    setState(() {
      isLoading = false;
      snapshot = paletteGenerator.dominantColor.color;
    });
  }

  @override
  void initState() {
    _currentIndex = 0;
    _getFirstColor();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: MediaQuery.of(context).size.height,
      duration: Duration(milliseconds: 300),
      decoration: BoxDecoration(color: snapshot),
      child: CarouselSlider(
        options: CarouselOptions(
            height: 500.0,
            enlargeCenterPage: true,
            onPageChanged: (index, reason) {
              _getPaletteGenerator();
              setState(() {
                _currentIndex = index;
              });
            }),
        items: widget.showList.map((item) {
          return Builder(
            builder: (BuildContext context) {
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (context) {
                      return item.mediaType == "tv"
                          ? ShowDetails(ids: item.id)
                          : MovieDetails(ids: item.id);
                    },
                  ));
                },
                child: Container(
                  margin: EdgeInsets.all(5),
                  child: Stack(
                    alignment: Alignment.bottomLeft,
                    children: [
                      Material(
                        elevation: 5,
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
                            placeholder: (context, url) => LottieLoader(),
                            errorWidget: (context, url, error) =>
                                Icon(Icons.error),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}
