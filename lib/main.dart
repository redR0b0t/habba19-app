import 'dart:async';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:habba2019/screens/about_screen.dart';
import 'package:habba2019/screens/insta_screen.dart';
import 'package:habba2019/screens/login_screen.dart';
import 'package:habba2019/screens/news_feed_screen.dart';
import 'package:habba2019/screens/olympics_screen.dart';
import 'package:habba2019/screens/splash_screen.dart';
import 'package:habba2019/screens/user_screen.dart';
import 'package:habba2019/stores/auth_store.dart';
import 'package:habba2019/stores/event_store.dart';

import 'package:flutter/material.dart';
import 'package:habba2019/screens/carousel_screen.dart';
import 'package:habba2019/stores/user_store.dart';

import 'package:habba2019/widgets/custom_tab_bar.dart';
import 'package:habba2019/widgets/custom_tab_scaffold.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habba2019/screens/timeline_screen.dart';
import 'package:habba2019/utils/theme.dart' as Themex;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        fontFamily: 'ProductSans',
        primaryColor: Themex.CustomColors.iconInactiveColor,
      ),
      home: SplashScreen(
        seconds: 3,
        image: Image.asset('assets/splash.gif'),
        backgroundColor: Colors.black,
        photoSize: 300,
        navigateAfterSeconds: Home(),
      ),
    );
  }
}

class Home extends StatefulWidget {
  @override
  HomeState createState() {
    return new HomeState();
  }
}

class HomeState extends State<Home> with StoreWatcherMixin<Home> {
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  EventStore store;
  AuthStore authStore;
  UserStore userStore;

//Color(0xffF55B9A), Color(0xffF9B16E)

  Color olympicsIconColor, habbaIconColor;

  HomeState() {
    olympicsIconColor = Themex.CustomColors.iconInactiveColor;
    habbaIconColor = null;
    store = listenToStore(eventStoreToken);
    authStore = listenToStore(authStoreToken);
    userStore = listenToStore(userStoreToken);
    _firebaseMessaging.getToken().then((token) {
      EventStoreActions.registerDevice.call(token);
      print(token);
    });
    AuthStoreActions.checkAuth.call();
  }

  @override
  Widget build(BuildContext context) {
    print('${authStore.isLoggedIn} ${authStore.guestLoggedIn}');
    return !authStore.isLoggedIn && !authStore.guestLoggedIn
        ? LoginScreen()
        : CustomTabScaffold(
            tabBar: CustomTabBar(
              iconSize: 23,
              onTap: (int index) {
                setState(() {
                  if (index == 0)
                    olympicsIconColor = Themex.CustomColors.iconActiveColor;
                  else
                    olympicsIconColor = Themex.CustomColors.iconInactiveColor;
                  if (index == 3)
                    habbaIconColor = null;
                  else
                    habbaIconColor = Themex.CustomColors.iconInactiveColor;
                });
              },
              currentIndex: 3,
              inactiveColor: Themex.CustomColors.iconInactiveColor,
              activeColor: Themex.CustomColors.iconActiveColor,
              items: <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/Olympics.png',
                    color: olympicsIconColor,
                    height: 23,
                    width: 23,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.megaport),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.instagram),
                ),
                BottomNavigationBarItem(
                  icon: Image.asset(
                    'assets/xpaw.png',
                    color: habbaIconColor,
                    height: 60,
                    width: 60,
                  ),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.timeline),
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.event),
                ),
                BottomNavigationBarItem(
                  icon: Icon(FontAwesomeIcons.questionCircle),
                ),
              ],
            ),
            tabBuilder: (BuildContext context, int index) {
              switch (index) {
                case 0:
                  return OlympicsScreen();
                case 1:
                  return NewsFeedScreen();
                case 2:
                  return InstaScreen();
                case 3:
                  return CarouselContainer();
                case 4:
                  return TimelineScreen();
                case 5:
                  return UserScreen();
                case 6:
                  return AboutScreen();
              }
            },
          );
  }
}
