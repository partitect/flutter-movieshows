import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieshows/models/trending_movies.dart';
import 'package:movieshows/screens/movie_details_screen.dart';
import 'package:movieshows/screens/show_details_screen.dart';
import 'package:movieshows/widgets/app_loader.dart';

class MoviesGridCard extends StatelessWidget {
  const MoviesGridCard({
    Key key,
    @required this.showList,
  }) : super(key: key);

  final List<AllTrending> showList;

  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.countBuilder(
      crossAxisCount: 4,
      itemCount: showList.length,
      itemBuilder: (BuildContext context, int index) {
        return InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) {
                return showList[index].mediaType == "tv"
                    ? ShowDetails(ids: showList[index].id)
                    : MovieDetails(ids: showList[index].id);
              },
            ));
          },
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
                    imageUrl: showList[index].posterPath != null
                        ? "https://image.tmdb.org/t/p/original${showList[index].posterPath}"
                        : "https://logowik.com/content/uploads/images/flutter5786.jpg",
                    imageBuilder: (context, imageProvider) => Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                          colorFilter: new ColorFilter.mode(
                              Colors.black.withOpacity(.3), BlendMode.hue),
                        ),
                      ),
                    ),
                    placeholder: (context, url) => AppLoader(
                      wdth: 100.0,
                      hght: 100.0,
                    ),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
              /*  Container(
                padding: EdgeInsets.only(left: 10, bottom: 10),
                child: Text(
                  showList[index].mediaType == "tv"
                      ? showList[index].name ?? "NoName"
                      : showList[index].title ?? "NoName",
                  style: GoogleFonts.quicksand(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ), */
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
                        showList[index].voteAverage != null
                            ? showList[index].voteAverage.toString()
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
      staggeredTileBuilder: (int index) {
        return StaggeredTile.count(index == 0 ? 4 : 2, index == 0 ? 2.5 : 3);
      },
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
    );
  }
}
