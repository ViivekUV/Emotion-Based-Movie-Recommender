import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/genre.dart';
import 'package:movies_app/model.dart';
import 'package:movies_app/viewmovie.dart';

class HomePage extends StatefulWidget {
  final String mood;
  final String id;
  HomePage(this.mood, this.id);
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  TabController tabController;
  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 5, vsync: this);
  }

  getMoodMovies() async {
    print(widget.id);
    var url =
        'https://api.themoviedb.org/3/discover/movie?api_key=$apiKey&language=en-US&sort_by=popularity.desc&page=1&with_genres=${widget.id}';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    print(result);

    List<Movie> moodList = List<Movie>();
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
      moodList.add(movie);
    }
    return moodList;
  }

  getGenreList() async {
    var url =
        'https://api.themoviedb.org/3/genre/movie/list?api_key=$apiKey&language=en-US';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    // print(result['results']);
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(children: <Widget>[
          Container(
            alignment: Alignment.centerLeft,
            margin: EdgeInsets.only(left: 20.0, top: 30.0),
            child: Text(
              "Here's our recommendation for ${widget.mood} mood",
              style: GoogleFonts.montserrat(
                  fontWeight: FontWeight.w500, fontSize: 20.0),
            ),
          ),
          SizedBox(height: 10.0),
          Container(
            height: 400,
            child: FutureBuilder(
                future: getMoodMovies(),
                builder: (BuildContext context, dataSnapshot) {
                  if (!dataSnapshot.hasData) {
                    return Text("Loading");
                  }
                  return CarouselSlider.builder(
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
                            height: 400,
                            width: MediaQuery.of(context).size.width,
                            child: Hero(
                              tag: dataSnapshot.data[index].poster,
                              child: Image(
                                image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w500/${dataSnapshot.data[index].poster}'),
                                fit: BoxFit.contain,
                              ),
                            ),
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
                  // return GenrePage(widget.id);
                }),
          ),
          TabBar(
            controller: tabController,
            isScrollable: true,
            indicatorColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            labelColor: Colors.black,
            labelStyle: GoogleFonts.montserrat(fontWeight: FontWeight.bold),
            tabs: [
              Tab(text: "Action"),
              Tab(text: "Comedy"),
              Tab(text: "Crime"),
              Tab(text: "Thriller"),
              Tab(text: "Romance"),
            ],
          ),
          SingleChildScrollView(
            child: Container(
              height: 200.0,
              child: TabBarView(controller: tabController, children: [
                GenrePage('28'),
                GenrePage('35'),
                GenrePage('80'),
                GenrePage('53'),
                GenrePage('10749')
              ]),
            ),
          )
        ]),
      ),
    );
  }
}
