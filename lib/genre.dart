import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:movies_app/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/model.dart';
import 'package:movies_app/viewmovie.dart';

class GenrePage extends StatefulWidget {
  final String id;
  GenrePage(this.id);
  @override
  _GenrePageState createState() => _GenrePageState();
}

class _GenrePageState extends State<GenrePage> {
  getGenres() async {
    var url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&page=1&with_genres=${widget.id}';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<Movie> genreList = List<Movie>();
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
      genreList.add(movie);
    }
    return genreList;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getGenres(),
        builder: (BuildContext context, dataSnapshot) {
          if (!dataSnapshot.hasData) {
            return Text("Loading");
          }
          return ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: dataSnapshot.data.length,
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
                  height: 200,
                  padding: EdgeInsets.all(10.0),
                  child: Image(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500/${dataSnapshot.data[index].poster}'),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            },
          );
        });
  }
}
