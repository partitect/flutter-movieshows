import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppLoader extends StatelessWidget {
  final wdth;
  final hght;
  const AppLoader({
    Key key,
    this.wdth,
    this.hght,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child:
          SvgPicture.asset('assets/svg/popcorn.svg', height: hght, width: wdth),
    );
  }
}
