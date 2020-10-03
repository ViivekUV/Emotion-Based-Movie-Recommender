import 'package:flutter/material.dart';
import 'package:movies_app/home.dart';
import 'package:movies_app/search.dart';

class MainPage extends StatefulWidget {
  final String mood;
  MainPage(this.mood);
  @override
  _MyMainPageState createState() => _MyMainPageState();
}

class _MyMainPageState extends State<MainPage> {
  int page = 0;
  var suggestions = {'Angry': '28', 'Happy': '10749', 'Sad': '35'};
  // print(widget.mood);
  // var pageOptions = [HomePage(suggestions[widget.mood]), SearchPage()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), title: Text('Home')),
          BottomNavigationBarItem(
              icon: Icon(Icons.search), title: Text('Search')),
        ],
        onTap: (index) {
          setState(() {
            page = index;
            print(suggestions[widget.mood]);
            if (index == 1) {
              Navigator.push(
                  context, MaterialPageRoute(builder: (_) => SearchPage()));
            } else {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          HomePage(widget.mood, suggestions[widget.mood])));
            }
            // print(page);
          });
        },
      ),
      // body: pageOptions[page],
    );
  }
}
