import 'package:flutter/material.dart';
import 'package:malo_movies/components/general/styled_tooltip.dart';
import 'package:malo_movies/models/movie_detailed.dart';
import 'package:malo_movies/states/themestate.dart';
import 'package:responsive_builder/responsive_builder.dart';

class TitleAndTagline extends StatelessWidget {
  const TitleAndTagline({
    required this.themeState,
    required this.sizingInformation,
    required this.movie,
  });

  final SetThemeState themeState;
  final MovieDetailed movie;
  final SizingInformation sizingInformation;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        StyledTooltip(
          text: movie.originalTitle,
          sizingInformation: sizingInformation,
          themeState: themeState,
          maxTextLength: 40,
          fontSize: sizingInformation.isMobile ? 20 : 40,
        ),
        StyledTooltip(
          sizingInformation: sizingInformation,
          themeState: themeState,
          maxTextLength: 15,
          text: movie.tagline,
          fontSize: sizingInformation.isMobile
              ? 15
              : sizingInformation.isTablet
                  ? 20
                  : 25,
        )
      ],
    );
  }
}
