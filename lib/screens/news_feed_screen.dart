import 'package:flutter/material.dart';
import 'package:habba2019/models/newsfeed_model.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class NewsFeedScreen extends StatefulWidget {
  @override
  _NewsFeedScreenState createState() => _NewsFeedScreenState();
}

class _NewsFeedScreenState extends State<NewsFeedScreen>
    with SingleTickerProviderStateMixin<NewsFeedScreen> {
  AnimationController _controller;
  Animation<double> _yTranlationAnimation, _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _yTranlationAnimation = Tween(begin: 300.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOut),
    );
    _opacityAnimation = Tween(begin: 0.0, end: 1.0)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));
    _fetchNewsFeed();
  }

  List<NewsItem> newsItems = [];
  bool isLoading = false;
  bool isError = false;

  _fetchNewsFeed() async {
    setState(() {
      isLoading = true;
    });
    http.Response response =
        await http.get('https://api.habba19.tk/newsfeed/all');
    Map jsonMap = await jsonDecode(response.body);
    _controller.forward();
    setState(() {
      isLoading = false;
      newsItems.clear();
      newsItems.addAll(NewsFeedModel.fromJson(jsonMap).newsItems.reversed.toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/kaala.png',
            fit: BoxFit.cover,
          ),
        ),
        _buildActual(context)
      ],
    );
  }

  Widget _buildActual(BuildContext context) {
    if (isError) {
      return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: RaisedButton(
              onPressed: () {
                _fetchNewsFeed();
              },
              child: Text('Error occured! Retry'),
            ),
          ),
        ),
      );
    }
    if (isLoading) {
      return NotificationListener<OverscrollIndicatorNotification>(
        onNotification: (OverscrollIndicatorNotification overscroll) {
          overscroll.disallowGlow();
        },
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Themex.CustomColors.iconActiveColor),
            ),
          ),
        ),
      );
    }
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Whats Happening in Habba19'),
          centerTitle: true,
          elevation: 0,
        ),
        body: AnimatedBuilder(
          builder: (BuildContext context, Widget child) {
            return Transform(
              transform: Matrix4.translationValues(
                  0.0, _yTranlationAnimation.value, 0.0),
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: child,
              ),
            );
          },
          animation: _controller,
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 100),
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0),
                child: Container(
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.5),
                        blurRadius: 10.0,
                        // has the effect of softening the shadow
                        spreadRadius: 0.0,
                        // has the effect of extending the shadow
                        offset: Offset(
                          0.0, // horizontal, move right 10
                          5.0, // vertical, move down 10
                        ),
                      )
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              newsItems[index].title,
                              style: TextStyle(fontSize: 20),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 8.0, bottom: 8.0, right: 8.0),
                            child: Text(
                              newsItems[index].body,
                              style: TextStyle(color: Colors.black54),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          newsItems[index].url == null
                              ? Container()
                              : CachedNetworkImage(
                                  imageUrl: newsItems[index].url,
                                  placeholder: Container(
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: CircularProgressIndicator(
                                          valueColor: AlwaysStoppedAnimation(
                                            Themex.CustomColors.iconActiveColor,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  fit: BoxFit.cover,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: newsItems.length,
          ),
        ),
      ),
    );
  }
}
