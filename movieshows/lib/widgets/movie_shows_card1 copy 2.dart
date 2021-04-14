import 'dart:async';

import 'package:flutter/material.dart';
import 'package:movieshows/models/trending_movies.dart';
import 'package:palette_generator/palette_generator.dart';

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

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    fetchUserOrder();
  }

  Future<void> fetchUserOrder() async {
    Future.delayed(Duration(milliseconds: 1000), () async {
      bgColors = [];

      for (String image in widget.images) {
        print(image);
        PaletteGenerator palette = await PaletteGenerator.fromImageProvider(
            NetworkImage(image),
            size: Size(200, 100));
        palette.darkMutedColor != null
            ? bgColors.add(palette.darkMutedColor)
            : bgColors.add(PaletteColor(Colors.red, 3));
      }
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.images);
    return isLoading == false
        ? Container(
            color: Colors.red,
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: 500,
                  color: bgColors.length > 0
                      ? bgColors[_currentIndex].color
                      : Colors.white,
                  child: PageView(
                    onPageChanged: (index) {
                      setState(() {
                        _currentIndex = index;
                      });
                    },
                    children: widget.showList
                        .map((image) => Container(
                              padding: const EdgeInsets.all(16.0),
                              margin: const EdgeInsets.all(16.0),
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.5),
                                    spreadRadius: 1,
                                    blurRadius: 7,
                                    offset: Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                                borderRadius: BorderRadius.circular(30.0),
                                image: DecorationImage(
                                    image: NetworkImage(
                                        "https://image.tmdb.org/t/p/original${image.posterPath}"),
                                    fit: BoxFit.cover),
                              ),
                            ))
                        .toList(),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(32.0),
                    width: double.infinity,
                    decoration: BoxDecoration(
                        color: bgColors.length > 0
                            ? bgColors[_currentIndex].color
                            : Colors.white),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "Nepal, The 8th Wonder",
                          style: TextStyle(
                              color: bgColors.isNotEmpty
                                  ? bgColors[_currentIndex].titleTextColor
                                  : Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 30.0),
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                            "Lorem ipsum dolor sit amet consectetur adipisicing elit. Id obcaecati tenetur enim et dolore aut dolorum! Fugiat omnis amet atque quos sapiente similique, tempore, vitae eos perferendis cupiditate libero odit.",
                            textAlign: TextAlign.justify,
                            style: TextStyle(
                                color: bgColors.isNotEmpty
                                    ? bgColors[_currentIndex].bodyTextColor
                                    : Colors.black,
                                fontSize: 20.0))
                      ],
                    ),
                  ),
                )
              ],
            ),
          )
        : Text("Yükleniyor");
  }
}
