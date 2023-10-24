import 'package:flutter/material.dart';
import 'package:weather/ui/home.dart';
import 'package:weather/ui/welcome.dart';

void main(){
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Weather App',
      home: Welcome(),
      debugShowCheckedModeBanner: false,
    );
  }
}
