class Book {
  final int id;
  final String title;
  final String description;
  final String author;
  final bool available;
  final int shelf;
  final String section;
  final String image;
  final int ratings;
  final int year;
  final String isbn;
  final List<dynamic> genre;
  final String publisher;

  Book({
    required this.id,
    required this.title,
    required this.description,
    required this.author,
    required this.available,
    required this.shelf,
    required this.section,
    required this.image,
    required this.isbn,
    required this.genre,
    required this.ratings,
    required this.year,
    required this.publisher,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['_id'],
      title: json['title'],
      description: json['description'],
      author: json['author'],
      available: json['copies'] > 0,
      shelf: json['location']['shelf'],
      section: json['location']['section'],
      image: json['image'],
      isbn: json['ISBN'],
      genre: json['genre'],
      ratings: json['number_of_ratings'],
      year: json['year'],
      publisher: json['publisher'],
    );
  }

  static List<Book> listFromJson(List<dynamic> list) =>
      List<Book>.from(list.map((e) => Book.fromJson(e)));
}
