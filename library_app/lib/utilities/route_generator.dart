import 'package:flutter/material.dart';
import 'package:library_app/admin_screens/book_issue_screen.dart';
import 'package:library_app/admin_screens/home_screen.dart';
import 'package:library_app/admin_screens/return_book_screen.dart';
import 'package:library_app/screens/book_list_screen.dart';
import 'package:library_app/screens/book_screen.dart';
import 'package:library_app/screens/home_screen.dart';
import 'package:library_app/screens/login_screen.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/screens/user_books.dart';
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

      case '/admin-home':
        return MaterialPageRoute(builder: (_) => const HomeScreenAdmin());

      case '/admin-book-issue':
        return MaterialPageRoute(builder: (_) => const BookIssueScreen());

      case '/admin-book-return':
        return MaterialPageRoute(builder: (_) => const ReturnBookScreen());

      case '/user-books':
        return MaterialPageRoute(builder: (_) => const UserBooks());

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
