import 'package:flutter/material.dart';

class ShowDetailsScreen extends StatefulWidget {
  final ids;

  const ShowDetailsScreen({Key key, this.ids}) : super(key: key);
  @override
  _ShowDetailsScreenState createState() => _ShowDetailsScreenState();
}

class _ShowDetailsScreenState extends State<ShowDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("data"),
      ),
    );
  }
}
