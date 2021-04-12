import 'package:flutter/material.dart';
import 'package:movieshows/models/trending_movies.dart';
import 'package:palette_generator/palette_generator.dart';

class MovieShowsCard extends StatefulWidget {
  MovieShowsCard({
    Key key,
    @required this.showList,
  }) : super(key: key);

  List<AllTrending> showList;
  @override
  _MovieShowsCardState createState() => _MovieShowsCardState();
}

class _MovieShowsCardState extends State<MovieShowsCard> {
  List<PaletteColor> bgColors = [];
  int _currentIndex;
  var colorS = [];

  Future<PaletteGenerator> _generatePalette(var imagePath) async {
    print('generate çalışıyor..');
    PaletteGenerator _paletteGenerator =
        await PaletteGenerator.fromImageProvider(NetworkImage(imagePath),
            size: Size(110, 150), maximumColorCount: 20);
    return _paletteGenerator;
  }

  _updatePalette() async {
    for (var item in widget.showList) {
      var path = "https://image.tmdb.org/t/p/original/${item.posterPath}";
      print("start function");

      _generatePalette(path).then((_palette) {
        print(_palette.darkMutedColor);
        _palette.darkMutedColor != null
            ? bgColors.add(_palette.darkMutedColor)
            : bgColors.add(PaletteColor(Colors.red, 3));
      });
    }
  }

  @override
  void initState() {
    _updatePalette();
    print('init state..');
    super.initState();
    _currentIndex = 0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: double.infinity,
          height: 600,
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
                            offset: Offset(0, 3), // changes position of shadow
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
    );
  }
}
