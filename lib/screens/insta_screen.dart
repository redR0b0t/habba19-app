import 'package:flutter/material.dart';
import 'package:habba2019/models/insta_model.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'dart:convert';

class InstaScreen extends StatefulWidget {
  @override
  _InstaScreenState createState() => _InstaScreenState();
}

class _InstaScreenState extends State<InstaScreen>
    with SingleTickerProviderStateMixin<InstaScreen> {
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

  List<String> instaPictures = <String>[];
  bool isLoading = false;
  bool isError = false;

  _fetchNewsFeed() async {
    http.Response response =
        await http.get('https://api.habba19.tk/events/instapics');
    Map jsonMap = await jsonDecode(response.body);
    _controller.forward();
    InstaModel instaModel = InstaModel.fromJson(jsonMap);
    setState(() {
      instaPictures.clear();
      instaPictures.addAll(instaModel.data);
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
              onPressed: () {},
              child: Text('Error occured! Retry'),
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
          title: Text('#habba19'),
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
                         CachedNetworkImage(
                                  imageUrl: 'https://images.habba19.tk/instagram/habba19/${instaPictures[index]}',
                                  fit: BoxFit.cover,
                                )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
            itemCount: instaPictures.length,
          ),
        ),
      ),
    );
  }
}
