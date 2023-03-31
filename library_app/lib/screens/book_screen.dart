import 'package:flutter/material.dart';
import 'package:library_app/models/book.dart';
import 'dart:typed_data';

import '../utilities/api.dart';

class BookScreen extends StatelessWidget {
  final Book book;
  const BookScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            elevation: 0,
          ),
          child: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              IntrinsicHeight(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      clipBehavior: Clip.hardEdge,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.amber),
                      width: MediaQuery.of(context).size.width * (3 / 5),
                      child: FutureBuilder(
                        future: getImage(book.image),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.done) {
                            return Image.memory(
                              snapshot.data ?? Uint8List(0),
                              fit: BoxFit.cover,
                            );
                          }
                          return const Icon(Icons.image);
                        },
                      ),
                    ),
                    Column(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.star,
                                  color: Colors.amber,
                                ),
                                Text(book.ratings.toString())
                              ],
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text('Ratings')
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.calendar_month_sharp,
                                    color: Colors.purple),
                                Text(book.year.toString())
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text('Published')
                          ],
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.shelves,
                                  color: Colors.blue,
                                ),
                                Text('${book.shelf}-${book.section}')
                              ],
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            const Text(
                              'Shelf',
                            )
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      book.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, fontSize: 30),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      book.author,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.black54),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "ISBN:${book.isbn}",
                      style: const TextStyle(color: Colors.black38),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 12, left: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Published by: ${book.publisher}",
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 12, left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Synopsis",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 8),
                child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      book.description,
                      style: const TextStyle(color: Colors.black54),
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Uint8List> getImage(String url) async {
    var response = await imageApi.get(url);
    return response.data;
  }
}
