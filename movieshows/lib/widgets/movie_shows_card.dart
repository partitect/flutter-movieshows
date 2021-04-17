import 'dart:ui';

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
  int _currentIndex = 0;
  var list = [];
  var isLoading = true;

  @override
  void initState() {
    isLoading = false;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.showList.isNotEmpty
        ? Stack(
            children: [
              CachedNetworkImage(
                imageUrl:
                    "https://image.tmdb.org/t/p/original${widget.showList[_currentIndex].posterPath}",
                imageBuilder: (context, imageProvider) => AnimatedContainer(
                  duration: Duration(milliseconds: 500),
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 100.0, sigmaY: 50.0),
                    child: Container(
                      decoration:
                          BoxDecoration(color: Colors.white.withOpacity(0.0)),
                    ),
                  ),
                ),
                placeholder: (context, url) => LottieLoader(),
                errorWidget: (context, url, error) => Icon(Icons.error),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                child: CarouselSlider(
                  options: CarouselOptions(
                      height: 500.0,
                      enlargeCenterPage: true,
                      onPageChanged: (index, reason) {
                        //_updatePaletteGenerator(index);
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
                            child: Stack(
                              alignment: Alignment.bottomLeft,
                              children: [
                                ClipRRect(
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
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                          image: imageProvider,
                                          fit: BoxFit.cover,
                                          colorFilter: ColorFilter.mode(
                                              Colors.black.withOpacity(.3),
                                              BlendMode.hue),
                                        ),
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        LottieLoader(),
                                    errorWidget: (context, url, error) =>
                                        Icon(Icons.error),
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
              )
            ],
          )
        : LottieLoader();
  }
}
