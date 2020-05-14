import 'package:flutter/material.dart';
import 'services/authentication.dart';
import 'pages/root_page.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        title: 'Movie Order',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Colors.amber,
          accentColor: Colors.amberAccent,
          brightness: Brightness.dark,
        ),
        home: RootPage(auth: Auth()));
  }
}