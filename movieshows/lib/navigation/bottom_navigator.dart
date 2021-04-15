import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movieshows/screens/home_screen.dart';
import 'package:movieshows/screens/movies_screen.dart';
import 'package:movieshows/screens/shows_screen.dart';

class CurvedBottomBar extends StatefulWidget {
  @override
  _CurvedBottomBarState createState() => _CurvedBottomBarState();
}

class _CurvedBottomBarState extends State<CurvedBottomBar> {
  //State class
  int selectedIdx = 0;

  GlobalKey _bottomNavigationKey = GlobalKey();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        centerTitle: false,
        titleSpacing: 0.0,
        title: Transform(
          // you can forcefully translate values left side using Transform
          transform: Matrix4.translationValues(15.0, 0.0, 0.0),
          child: Text(
            selectedIdx == 0
                ? "All Trending"
                : selectedIdx == 1
                    ? "Movies"
                    : "Tv Shows",
            style: GoogleFonts.quicksand(
              textStyle: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900),
            ),
          ),
        ),
        backgroundColor:
            Colors.blueAccent.withOpacity(selectedIdx == 0 ? 0 : 1),
        shadowColor: Colors.black54,
        brightness: Brightness.dark,
      ),
      extendBody: true,
      bottomNavigationBar: CurvedNavigationBar(
        key: _bottomNavigationKey,
        height: 65.0,
        items: <Widget>[
          SvgPicture.asset(
            'assets/svg/all.svg',
            height: 30.0,
            width: 30.0,
          ),
          SvgPicture.asset(
            'assets/svg/movie.svg',
            height: 30.0,
            width: 30.0,
          ),
          SvgPicture.asset(
            'assets/svg/shows.svg',
            height: 30.0,
            width: 30.0,
          ),
        ],
        onTap: (idx) => setState(() {
          selectedIdx = idx;
        }),
        animationCurve: Curves.easeInOut,
        color: Colors.blueAccent,
        animationDuration: Duration(milliseconds: 300),
        buttonBackgroundColor: Colors.white.withOpacity(1),
        backgroundColor: Colors.white.withOpacity(0),
      ),
      body: IndexedStack(
        index: selectedIdx,
        children: [HomeScreen(), MoviesScreen(), ShowsScreen()],
      ),
    );
  }
}
