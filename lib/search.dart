import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:movies_app/apikey.dart';
import 'package:movies_app/model.dart';
import 'package:movies_app/viewmovie.dart';
import 'package:http/http.dart' as http;

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController textController = TextEditingController();
  bool valueEntered = false;
  displayNoFilms() {
    final Orientation orientation = MediaQuery.of(context).orientation;
    return Center(
      child: Container(
        child: ListView(
          shrinkWrap: true,
          children: [
            Icon(Icons.movie, color: Colors.grey, size: 200.0),
            Text(
              'Search for users',
              style: TextStyle(
                  fontFamily: "Montserrat",
                  fontWeight: FontWeight.w700,
                  fontSize: 25),
            )
          ],
        ),
      ),
    );
  }

  displayFilms() {
    return FutureBuilder(
        future: getSearchQuery(),
        builder: (BuildContext context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return Text("Loading");
          }
          return GridView.builder(
              itemCount: dataSnapshot.data.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => ViewMovie(
                              dataSnapshot.data[index].poster,
                              dataSnapshot.data[index].title,
                              dataSnapshot.data[index].overview,
                              dataSnapshot.data[index].rating,
                              dataSnapshot.data[index].id,
                              dataSnapshot.data[index].origin,
                              dataSnapshot.data[index].original))),
                  child: Container(
                    padding: EdgeInsets.all(5),
                    height: 200,
                    child: Image(
                      image: NetworkImage(
                          'https://image.tmdb.org/t/p/w500/${dataSnapshot.data[index].poster}'),
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              });
        });
  }

  getSearchQuery() async {
    var url =
        'https://api.themoviedb.org/3/search/movie?api_key=$apiKey&language=en-US&query=${textController.text}&page=1&include_adult=false';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<Movie> searchMovieList = List<Movie>();
    for (var cinema in result['results']) {
      cinema['vote_average'] > 0.0
          ? cinema['vote_average'] = cinema['vote_average'] / 2
          : cinema['vote_average'] = 0.0;
      Movie movie = Movie(
          cinema['poster_path'],
          cinema['title'],
          cinema['overview'],
          cinema['vote_average'],
          cinema['id'],
          cinema['original_language'],
          cinema['original_title']);
      searchMovieList.add(movie);
    }
    return searchMovieList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black26,
        shadowColor: Colors.black,
        title: TextField(
          controller: textController,
          decoration: InputDecoration(
              hintText: "Search here.....",
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white)),
              filled: true,
              suffixIcon: RaisedButton(
                onPressed: () {
                  setState(() {
                    valueEntered = true;
                  });
                },
                color: Colors.white70,
                child: Text('Search'),
              )),
        ),
      ),
      body: valueEntered == false ? displayNoFilms() : displayFilms(),
    );
  }
}
