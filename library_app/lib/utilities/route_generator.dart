import 'package:flutter/material.dart';
import 'package:library_app/screens/book_list_screen.dart';
import 'package:library_app/screens/book_screen.dart';
import 'package:library_app/screens/home_screen.dart';
import 'package:library_app/screens/login_screen.dart';
import 'package:library_app/models/book.dart';
import '../screens/signup_screen.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final dynamic args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case '/home':
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case '/signup':
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case '/book':
        return MaterialPageRoute(
            builder: (_) => BookScreen(
                  book: args,
                ));
      case '/booklist':
        return MaterialPageRoute(
            builder: (_) =>
                BookListScreen(booklist: args ?? List<Book>.empty()));
      default:
        // If there is no such named route in the switch statement
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}
