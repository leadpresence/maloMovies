import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:malo_movies/components/general/apptitle.dart';
import 'package:malo_movies/components/general/drawer.dart';
import 'package:malo_movies/components/general/loading.dart';
import 'package:malo_movies/components/general/mobile_menu.dart';
import 'package:malo_movies/components/movies_builder.dart';
import 'package:malo_movies/components/search_field.dart';
import 'package:malo_movies/models/movie.dart';
import 'package:malo_movies/networking/connection.dart';
import 'package:malo_movies/states/themestate.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../constants.dart';

var _textController = TextEditingController();
var _trendingScrollController = ScrollController();
var _upcomingScrollController = ScrollController();
var _pageController = PageController();
enum ActivePage { trending, upcoming }
var currentPage = ActivePage.trending;
bool _showSearchBar = false;
RefreshController _refreshTrendingController =
    RefreshController(initialRefresh: false);
RefreshController _refreshUpcomingController =
    RefreshController(initialRefresh: false);
bool hasLoaded = false;
List<Movie>? cachedTrendingMovies;
List<Movie>? cachedUpcomingMovies;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future getData() async {
    var res = await Future.wait([getTrending(), getUpcoming()]);
    cachedTrendingMovies = res[0];
    cachedUpcomingMovies = res[1];
    hasLoaded = true;
    setState(() {});
  }

  void refreshTrendingMovies() async {
    cachedTrendingMovies = await getTrending();
    setState(() {});
    _refreshTrendingController.refreshCompleted();
  }

  void refreshUpcomingMovies() async {
    cachedUpcomingMovies = await getUpcoming();
    setState(() {});
    _refreshUpcomingController.refreshCompleted();
  }

  @override
  void initState() {
    super.initState();
    if (!hasLoaded) {
      getData();
    }
    _pageController.addListener(() {
      if (_pageController.page == 1) {
        currentPage = ActivePage.upcoming;
      } else if (_pageController.page == 0) {
        currentPage = ActivePage.trending;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    super.dispose();
    _pageController.removeListener(() {});
  }

  @override
  Widget build(BuildContext context) {
    var themeState = context.watch<SetThemeState>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeState.selectedTheme == ThemeSelected.light
                ? const Color(0xFFf7f7f7)
                : const Color(0xff16213e),
            themeState.selectedTheme == ThemeSelected.light
                ? const Color(0xFF198FD8).withOpacity(0.4)
                : const Color(0xff1a1a2e),
          ],
        ),
      ),
      child: ResponsiveBuilder(
        builder: (context, sizingInformation) => Scaffold(
          backgroundColor: Colors.transparent,
          drawer: NewsDrawer(),
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            shadowColor: themeState.selectedTheme == ThemeSelected.dark
                ? const Color(0xFFf7f7f7).withOpacity(0.3)
                : Colors.black.withOpacity(0.7),
            toolbarHeight: sizingInformation.isMobile
                ? sizingInformation.isTablet
                    ? 110
                    : 110
                : 140,
            leading: Builder(
              builder: (BuildContext context) => IconButton(
                icon: Icon(
                  Icons.menu,
                  size: 40,
                  color: themeState.selectedTheme == ThemeSelected.dark
                      ? const Color(0xFFf7f7f7)
                      : Colors.black.withOpacity(0.5),
                ),
                onPressed: () => Scaffold.of(context).openDrawer(),
              ),
            ),
            title: AppTitle(
              onSearchTap: () {
                _showSearchBar ? _showSearchBar = false : _showSearchBar = true;
                setState(() {});
              },
              searchIconColor: themeState.selectedTheme == ThemeSelected.dark
                  ? const Color(0xFFf7f7f7)
                  : Colors.black.withOpacity(0.5),
              settingsIconColor: themeState.selectedTheme == ThemeSelected.dark
                  ? const Color(0xFFf7f7f7)
                  : Colors.black.withOpacity(0.5),
            ),
          ),
          body: Padding(
            padding: const EdgeInsets.only(
              top: 5.0,
              // left: sizingInformation.isMobile ? 30 : 60,
              // right: sizingInformation.isMobile ? 30 : 60,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 10,
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 400),
                  switchOutCurve: Curves.easeOut,
                  switchInCurve: Curves.easeIn,
                  key: const Key('topBar'),
                  child: _showSearchBar
                      ? Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Flexible(
                              flex: 0,
                              child: SearchField(
                                borderColor: Colors.red,
                                sizingInformation: sizingInformation,
                                shadowColor: Colors.white,
                                onClose: () {
                                  _showSearchBar = false;
                                  setState(() {});
                                },
                                textColor: selectedTheme == ThemeSelected.light
                                    ? Colors.black.withOpacity(0.6)
                                    : Colors.white.withOpacity(0.6),
                                hintTextColor:
                                    selectedTheme == ThemeSelected.light
                                        ? Colors.black.withOpacity(0.6)
                                        : Colors.white.withOpacity(0.6),
                                buttonColor:
                                    selectedTheme == ThemeSelected.light
                                        ? Colors.white.withOpacity(0.6)
                                        : Colors.white,
                                buttonTextColor:
                                    const Color(0xFFEC1E79).withOpacity(0.7),
                                controller: _textController,
                                textFontSize: 30,
                                buttonTextFontSize: 25,
                              ),
                            )
                          ],
                        )
                      : const SizedBox(),
                ),
                sizingInformation.isDesktop
                    ? !_showSearchBar
                        ? hasLoaded
                            ? Text(
                                'Trending Movies',
                                style: GoogleFonts.newsCycle(
                                  fontSize:
                                      sizingInformation.isMobile ? 23 : 30,
                                  fontWeight: FontWeight.bold,
                                  color: themeState.selectedTheme ==
                                          ThemeSelected.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )
                            : const SizedBox()
                        : const SizedBox()
                    : const SizedBox(),
                (sizingInformation.isMobile || sizingInformation.isTablet) &&
                        !_showSearchBar
                    ? MobileMenu(
                        activePage: currentPage,
                        pageController: _pageController,
                      )
                    : const SizedBox(),
                Expanded(
                  child: sizingInformation.isDesktop
                      ? !_showSearchBar
                          ? hasLoaded
                              ? MoviesBuilder(
                                  widgetOrigin: 'Trending Movies',
                                  scrollController: _trendingScrollController,
                                  rowCount: trendingRowCount(sizingInformation),
                                  movies: cachedTrendingMovies ?? [],
                                  itemCount: cachedTrendingMovies!.length,
                                  sizingInformation: sizingInformation,
                                  scrollDirection: Axis.horizontal,
                                )
                              : const Loading()
                          : const SizedBox()
                      : !_showSearchBar && hasLoaded
                          ? PageView(
                              controller: _pageController,
                              children: [
                                MoviesBuilder(
                                  widgetOrigin: 'Trending Movies',
                                  scrollController: _trendingScrollController,
                                  refreshController: _refreshTrendingController,
                                  onRefresh: refreshTrendingMovies,
                                  rowCount: trendingRowCount(sizingInformation),
                                  movies: cachedTrendingMovies ?? [],
                                  itemCount: cachedTrendingMovies!.length,
                                  sizingInformation: sizingInformation,
                                  scrollDirection: Axis.vertical,
                                ),
                                MoviesBuilder(
                                  widgetOrigin: 'Upcoming movies',
                                  scrollController: _upcomingScrollController,
                                  refreshController: _refreshUpcomingController,
                                  onRefresh: refreshUpcomingMovies,
                                  rowCount: upcomingRowCount(sizingInformation),
                                  movies: cachedUpcomingMovies ?? [],
                                  itemCount: cachedUpcomingMovies!.length,
                                  sizingInformation: sizingInformation,
                                  scrollDirection: Axis.vertical,
                                ),
                              ],
                            )
                          : _showSearchBar
                              ? const SizedBox()
                              : const Loading(),
                ),
                sizingInformation.isDesktop
                    ? !_showSearchBar
                        ? hasLoaded
                            ? Text(
                                'Upcoming Movies',
                                style: GoogleFonts.newsCycle(
                                  fontSize:
                                      sizingInformation.isMobile ? 23 : 30,
                                  fontWeight: FontWeight.bold,
                                  color: themeState.selectedTheme ==
                                          ThemeSelected.dark
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              )
                            : const SizedBox()
                        : const SizedBox()
                    : const SizedBox(),
                sizingInformation.isDesktop
                    ? !_showSearchBar
                        ? hasLoaded
                            ? Expanded(
                                child: MoviesBuilder(
                                  widgetOrigin: 'Upcoming movies',
                                  scrollController: _upcomingScrollController,
                                  rowCount: upcomingRowCount(sizingInformation),
                                  movies: cachedUpcomingMovies ?? [],
                                  itemCount: cachedUpcomingMovies!.length,
                                  sizingInformation: sizingInformation,
                                  scrollDirection: Axis.horizontal,
                                ),
                              )
                            : const Loading()
                        : const SizedBox()
                    : const SizedBox(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
