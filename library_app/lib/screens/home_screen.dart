import 'package:flutter/material.dart';
import 'package:library_app/widgets/mic_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;
  bool _isSearching = false;
  String name = "Name";

  void onNavButtonTap(int index) {
    _navIndex = index;
    setState(() {});
  }

  @override
  void initState() {
    setvalues();
    super.initState();
  }

  void setvalues() async {
    final pref = await SharedPreferences.getInstance();
    name = pref.getString('username') ?? "Name";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: !_isSearching
            ? const Text('')
            : TextField(
                autofocus: true,
                decoration: InputDecoration(
                    hintText: 'search book by name',
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    contentPadding: const EdgeInsets.all(8)),
                onSubmitted: (value) {
                  print(value);
                },
              ),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
              });
            },
            icon: !_isSearching
                ? const Icon(
                    Icons.search,
                    size: 35,
                  )
                : const Icon(
                    Icons.cancel_outlined,
                    size: 35,
                  ),
          ),
          const Padding(
            padding: EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Colors.yellow,
              radius: 17,
            ),
          ),
        ],
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Container(
        height: double.maxFinite,
        width: double.maxFinite,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/backgrounds/home_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width / 6,
                      left: 10,
                      bottom: 50),
                  child: Text(
                    "Hii $name, it's ShelfGenius your personalized library voice assistant",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontSize: 25, color: Colors.white),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Image.asset('assets/backgrounds/library.gif'),
                ),
              ],
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: const MicButton(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: onNavButtonTap,
        currentIndex: _navIndex,
        selectedFontSize: 10,
        unselectedFontSize: 10,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white,
        elevation: 0,
        backgroundColor: Colors.transparent,
        items: [
          BottomNavigationBarItem(
            icon: IconButton(
              icon: const Icon(Icons.my_library_books_outlined),
              onPressed: () => Navigator.pushNamed(context, '/user-books'),
            ),
            label: "Your Books",
          ),
          const BottomNavigationBarItem(
              icon: Icon(Icons.shelves), label: "Recommended"),
        ],
      ),
    );
  }
}
