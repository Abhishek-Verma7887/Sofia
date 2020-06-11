import 'package:flutter/material.dart';
import 'package:sofia/utils/database.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Database database = Database();

  @override
  void initState() {
    super.initState();
    database.uploadTracks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(),
    );
  }
}
