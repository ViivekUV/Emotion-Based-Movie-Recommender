import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/model.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  getTrendingMovies() async {
    var url = "https://api.themoviedb.org/3/trending/movie/day?api_key=$apiKey";
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    // print(result['results']);
    List<Movie> trendingList = List<Movie>();
    for (var cinema in result['results']) {
      Movie movie = Movie(
          cinema['poster_path'],
          cinema['title'],
          cinema['overview'],
          cinema['vote_average'],
          cinema['id'],
          cinema['original_language'],
          cinema['original_title']);
      trendingList.add(movie);
    }
    print(trendingList);
    return trendingList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 20.0, top: 30.0),
            child: Text(
              'Trending now',
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w700, fontSize: 20.0),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 400,
            child: FutureBuilder(
                future: getTrendingMovies(),
                builder: (BuildContext context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Text("Loading");
                  }
                  return CarouselSlider.builder(
                      itemCount: dataSnapshot.data.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Container(
                          height: 400,
                          width: MediaQuery.of(context).size.width,
                          child: Image(
                            image: NetworkImage(
                                'https://image.tmdb.org/t/p/w500/${dataSnapshot.data[index].poster}'),
                            fit: BoxFit.contain,
                          ),
                        );
                      },
                      options: CarouselOptions(
                        height: 400,
                        viewportFraction: 0.8,
                        initialPage: 0,
                        enableInfiniteScroll: true,
                        reverse: true,
                        autoPlay: true,
                        autoPlayInterval: Duration(seconds: 4),
                        autoPlayAnimationDuration: Duration(milliseconds: 800),
                        enlargeCenterPage: true,
                        scrollDirection: Axis.horizontal,
                      ));
                }),
          )
        ]),
      ),
    );
  }
}