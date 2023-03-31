import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';
import 'package:library_app/utilities/api.dart';

class BookListScreen extends StatelessWidget {
  final List<Book> booklist;
  const BookListScreen({super.key, required this.booklist});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          const SizedBox(
            height: 10,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.search_rounded),
              Text('Your Search Results ....')
            ],
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: booklist.length,
              itemBuilder: (context, index) {
                return createBookContainer(booklist[index], context);
              },
            ),
          ),
        ],
      ),
    );
  }

  ListTile createBookContainer(Book book, BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/book', arguments: book);
      },
      visualDensity: const VisualDensity(vertical: 4),
      horizontalTitleGap: 1,
      leading: FutureBuilder(
        future: getImage(book.image),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Image.memory(
              snapshot.data ?? Uint8List(0),
              fit: BoxFit.fill,
            );
          }
          return const Icon(Icons.image);
        },
      ),
      title: Text(book.title),
      subtitle: Text(book.author),
    );
  }

  Future<Uint8List> getImage(String url) async {
    var response = await imageApi.get(url);
    return response.data;
  }
}
