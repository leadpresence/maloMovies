import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malo_movies/models/movie_detailed.dart';
import 'package:malo_movies/states/themestate.dart';
import 'package:responsive_builder/responsive_builder.dart';

class MovieDuration extends StatelessWidget {
  const MovieDuration({
    required this.themeState,
    required this.movie,
    required this.sizingInformation,
    Key? key,
  }) : super(key: key);

  final SetThemeState themeState;
  final SizingInformation sizingInformation;
  final MovieDetailed movie;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Duration',
          textAlign: TextAlign.center,
          style: GoogleFonts.newsCycle(
            fontSize: sizingInformation.isMobile ? 15 : 25,
            fontWeight: FontWeight.bold,
            color: themeState.selectedTheme == ThemeSelected.light
                ? Colors.black
                : const Color(0xFFf7f7f7),
          ),
        ),
        Text(
          "${movie.runtime.toString()}'",
          textAlign: TextAlign.center,
          style: GoogleFonts.newsCycle(
            fontSize: sizingInformation.isMobile ? 15 : 25,
            color: themeState.selectedTheme == ThemeSelected.light
                ? Colors.black
                : const Color(0xFFf7f7f7),
          ),
        ),
      ],
    );
  }
}
