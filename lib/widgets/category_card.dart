import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CategoryCard extends StatelessWidget {
  String name;
  List items;
  String images;
  int eventsLength;

  CategoryCard(
      {@required this.name,
      @required this.images,
      @required this.eventsLength}) {
    List<String> imgs = images.split(',').toList();

    items = imgs.map((i) {
      return new Builder(
        builder: (BuildContext context) {
          return new Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
//            decoration: new BoxDecoration(
//              image: DecorationImage(
//                  image: CachedNetworkImageProvider(i), fit: BoxFit.cover),
//            ),
            child: CachedNetworkImage(
              imageUrl: i,
              fit: BoxFit.cover,
            ),
          );
        },
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: 15.0 - 15, horizontal: 8.0 - 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.4),
              blurRadius: 10.0, // has the effect of softening the shadow
              spreadRadius: 0.0, // has the effect of extending the shadow
              offset: Offset(
                0.0, // horizontal, move right 10
                5.0, // vertical, move down 10
              ),
            )
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: Stack(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                color: Colors.black,
              ),
              CarouselSlider(
                items: items,
                viewportFraction: 1.0,
                initialPage: 0,
                aspectRatio: 16 / 9,
                height: 600,
                reverse: false,
                autoPlay: true,
                autoPlayCurve: Curves.ease,
                interval: const Duration(seconds: 3),
                autoPlayDuration: const Duration(milliseconds: 1000),
              ),
              Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.black87,
                      Colors.black54,
                      Colors.transparent
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        name ?? 'Anon',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 30.0,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
