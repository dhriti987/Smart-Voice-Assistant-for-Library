import 'package:flutter/material.dart';
import 'package:library_app/utilities/route_generator.dart';
import 'utilities/util.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Util.kToDark,
        primaryColor: Util.kToDark,
        textTheme: const TextTheme(
          titleLarge: TextStyle(
              color: Util.kToDark, fontWeight: FontWeight.bold, fontSize: 40),
          titleSmall: TextStyle(
              color: Util.kToDark, fontWeight: FontWeight.bold, fontSize: 15),
          labelLarge: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
      ),
      onGenerateRoute: (settings) => RouteGenerator.generateRoute(settings),
      initialRoute: '/',
    );
  }
}
