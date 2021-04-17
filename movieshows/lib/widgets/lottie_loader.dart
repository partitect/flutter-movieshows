import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieLoader extends StatefulWidget {
  @override
  _LottieLoaderState createState() => _LottieLoaderState();
}

class _LottieLoaderState extends State<LottieLoader> {
  @override
  Widget build(BuildContext context) {
    return Center(child: Lottie.asset('assets/lottie/popcorn.json'));
  }
}
