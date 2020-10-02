import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:movies_app/apikey.dart';
import 'package:http/http.dart' as http;
import 'package:movies_app/model.dart';

class ViewMovie extends StatefulWidget {
  final String poster;
  final String title;
  final String overview;
  final double rating;
  final int id;
  final String origin;
  final String original;
  ViewMovie(this.poster, this.title, this.overview, this.rating, this.id,
      this.origin, this.original);
  @override
  _ViewMovieState createState() => _ViewMovieState();
}

class _ViewMovieState extends State<ViewMovie> {
  getSimilarMovies() async {
    var url =
        'https://api.themoviedb.org/3/movie/${widget.id}/similar?api_key=$apiKey&language=en-US&page=1';
    var response = await http.get(url);
    var result = jsonDecode(response.body);
    List<Movie> similarMovieList = List<Movie>();
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
      similarMovieList.add(movie);
    }
    return similarMovieList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: <Widget>[
            ClipPath(
              clipper: OvalBottomBorderClipper(),
              child: Hero(
                tag: widget.poster,
                child: Container(
                  height: 400,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: NetworkImage(
                        'https://image.tmdb.org/t/p/w500/${widget.poster}'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Icon(Icons.video_library),
                    Text(
                      widget.title,
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                    Icon(Icons.favorite, color: Colors.red),
                    Text(
                      widget.rating.toString(),
                      style: GoogleFonts.montserrat(
                          fontWeight: FontWeight.w700, fontSize: 20),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                RatingBar(
                  // onRatingUpdate: (rating) {
                  //   print(rating);
                  // },
                  onRatingUpdate: null,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemSize: 45,
                  itemBuilder: (BuildContext context, _) =>
                      Icon(Icons.star, color: Colors.yellow),
                  initialRating: widget.rating,
                ),
                SizedBox(height: 10.0),
                Text(
                  'Overview',
                  style: GoogleFonts.montserrat(
                      fontWeight: FontWeight.w400, fontSize: 15),
                ),
                SizedBox(height: 5.0),
                Padding(
                  padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                  child: Text(
                    widget.overview,
                    style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w700, fontSize: 20),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Container(
              height: 200,
              child: FutureBuilder(
                  future: getSimilarMovies(),
                  builder: (BuildContext context, dataSnapshot) {
                    if (!dataSnapshot.hasData) {
                      return Text('Loading');
                    }
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
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
                              padding: EdgeInsets.all(10.0),
                              height: 200,
                              child: Image(
                                image: NetworkImage(
                                    'https://image.tmdb.org/t/p/w500/${dataSnapshot.data[index].poster}'),
                                fit: BoxFit.contain,
                              ),
                            ),
                          );
                        });
                  }),
            )
          ],
        ),
      ),
    );
  }
}

// class SimilarMovie {
//   final String poster;
//   SimilarMovie(this.poster);
// }
