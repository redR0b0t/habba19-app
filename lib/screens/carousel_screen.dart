import 'dart:async';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:habba2019/screens/events_screen.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:vibrate/vibrate.dart';
import 'package:habba2019/widgets/category_card.dart';
import 'package:path_parsing/path_parsing.dart';
import 'package:habba2019/stores/event_store.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'dart:math' as math;

class CarouselContainer extends StatefulWidget {
  @override
  CarouselContainerState createState() {
    return new CarouselContainerState();
  }
}

class CarouselContainerState extends State<CarouselContainer>
    with
        StoreWatcherMixin<CarouselContainer>,
        TickerProviderStateMixin<CarouselContainer> {
  AnimationController controller;
  Animation<double> carouselXTranslation, carouselOpacityTranslation;
  EventStore store;
  bool isLoading = true;
  bool isError = false;

  @override
  void initState() {
    super.initState();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    carouselXTranslation = Tween(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.decelerate,
      ),
    );
    carouselOpacityTranslation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
    store = listenToStore(eventStoreToken);
    masterFetch();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void masterFetch() async {
    setState(() {
      bool isLoading = true;
      bool isError = false;
    });
    Completer completer = Completer();
    EventStoreActions.masterfetch.call(completer);
    bool res = await completer.future;
    isLoading = false;
    controller.forward();
    if (!res) {
      setState(() {
        isError = true;
      });
    }
  }

  BoxDecoration gradientBack() {
    return const BoxDecoration(
      gradient: const LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomCenter,
        colors: const <Color>[
          Color(0xff09203F), // <color name="pelorous">#2596B3</color>
          Color(0xff537895), // <color name="viking">#5FC9E2</color>
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: <Widget>[
//          Container(decoration: gradientBack(),),
//        Container(color: Colors.black,),
          _buildBackground(context),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              : isError
                  ? Center(
                      child: RaisedButton(
                        onPressed: masterFetch,
                        child: Text('Error. Retry'),
                      ),
                    )
                  : Center(
                      child: AnimatedBuilder(
                          animation: controller, builder: _buildCarousel),
                    ),
        ],
      ),
    );
  }

  Widget _buildCarousel(BuildContext context, Widget child) {
    return AspectRatio(
      aspectRatio: 0.85,
      child: Transform(
        transform: Matrix4.translationValues(carouselXTranslation.value, 0, 0),
        child: Opacity(
          opacity: carouselOpacityTranslation.value,
          child: Swiper(
            control: SwiperControl(
                color: Themex.CustomColors.iconActiveColor.withOpacity(0.7),
                iconNext: FontAwesomeIcons.angleDoubleRight,
                iconPrevious: FontAwesomeIcons.angleDoubleLeft),
            loop: false,
            outer: true,
            curve: Curves.linear,
            onIndexChanged: (int i) async {
              await Future.delayed(Duration(microseconds: 4000));
              Vibrate.feedback(FeedbackType.selection);
            },
            scale: 0.9,
            pagination: SwiperPagination(
              margin: EdgeInsets.all(0.0),
            ),
            viewportFraction: 0.85,
            itemCount: store.masterfetchModel.mainEvents.length + 1,
            itemBuilder: (BuildContext context, int i) {
              int index = i - 1;
              if (i == 0) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 0.0, vertical: 15.0),
                  child: Column(
                    children: <Widget>[
                      Expanded(
                        child: Center(
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Column(
                              children: <Widget>[
                                GradientText(
                                  'Welcome To\nAcharya Habba\n2019',
//                            textAlign: TextAlign.center,
                                  gradient: Gradients.haze,
                                  shaderRect: Rect.fromLTWH(100, 0, 100, 100),
                                  style: TextStyle(
                                      color: Colors.white,
                                      shadows: [
//                            Shadow(
//                              offset: Offset(10.0, 10.0),
//                              blurRadius: 3.0,
//                              color: Color.fromARGB(255, 0, 0, 0),
//                            ),
                                        Shadow(
                                          offset: Offset(5.0, 10.0),
                                          blurRadius: 20.0,
                                          color: Colors.black.withOpacity(0.55),
                                        ),
                                      ],
                                      fontSize: 54.0,
                                      fontFamily: 'ProductSans',
                                      fontWeight: FontWeight.w800),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          IconButton(
                            icon: Icon(FontAwesomeIcons.instagram, color: Colors.white, ),
                            onPressed: () async {
                              await launch('https://www.instagram.com/habba2019/');
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.snapchat, color: Colors.white),
                            onPressed: () async {
                              await launch('https://www.snapchat.com/add/acharya_habba');
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
                            onPressed: () async {
                              await launch('https://www.facebook.com/acharya.ac.in/');
                            },
                          ),
                          IconButton(
                            icon: Icon(FontAwesomeIcons.twitter, color: Colors.white),
                            onPressed: () async {
                              await launch('https://twitter.com/acharyahabba');
                            },
                          ),
                        ],
                      )
                    ],
                  ),
                );
              }
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    PageRouteBuilder(
                      opaque: false,
                      pageBuilder: (BuildContext context, _, __) => Container(
                            color: Colors.white.withOpacity(0.9),
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: EventsScreen(
                                events: store
                                    .masterfetchModel.mainEvents[index].events,
                              ),
                            ),
                          ),
                      transitionsBuilder:
                          (_, Animation<double> animation, __, Widget child) {
                        return new FadeTransition(
                            opacity: animation, child: child);
                      },
                    ),
                  );
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20.0, horizontal: 4.0),
                  child: CategoryCard(
                      name:
                          store.masterfetchModel.mainEvents[index].categoryName,
                      images: store
                          .masterfetchModel.mainEvents[index].categoryImages),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBackground(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Positioned(
//      left: -200,
//      right: 100,
//      top: -50,
//      bottom: 0,
      child: Image.asset(
        'assets/kaala.png',
        fit: BoxFit.cover,
//          color: Themex.CustomColors.iconInactiveColor,
      ),
    );
  }
}
