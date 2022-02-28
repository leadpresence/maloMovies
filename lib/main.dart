import 'package:flutter/material.dart';
import 'package:malo_movies/screens/home_screen.dart';
import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:malo_movies/screens/movie_screen.dart';
import 'package:malo_movies/screens/search_screen.dart';
import 'package:malo_movies/states/loadingstate.dart';
import 'package:malo_movies/states/themestate.dart';
import 'package:provider/provider.dart';

 Future main() async {
  await dotenv.load(fileName: 'dotenv');
  runApp(const MyMaloApp());
}

class MyMaloApp extends StatelessWidget {
  const MyMaloApp({Key? key}) : super(key: key);

   // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // LOCK THE ORIENTATION
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

  //Wrap the application with a multiprovider
  return MultiProvider(
      providers: [
        // provider to control light and dark mode
        ListenableProvider<SetThemeState>(
          create: (_) => SetThemeState(selectedTheme: ThemeSelected.dark),
        ),
        //provider to handle loading states
        ListenableProvider<SetLoading>(
          create: (_) => SetLoading(isLoading: false),
        ),
      ],
      child: GetMaterialApp(
        //disable the debug banner
        debugShowCheckedModeBanner: false,

        scrollBehavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        // Set the  navigation to various screens
        getPages: [
          GetPage(name: '/', page: () => HomeScreen()),
          GetPage(name: '/search', page: () => SearchResults()),
          GetPage(
            name: '/movie',
            page: () => MovieScreen(),
          ),
        ],
        title: 'Malo movies',
        home: HomeScreen(),
      ),
    );
  }
}

 