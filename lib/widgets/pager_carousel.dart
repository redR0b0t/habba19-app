import 'package:flutter/material.dart';
import 'transformer.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:vibrate/vibrate.dart';

class PagerCarousel extends StatefulWidget {
  IndexedWidgetBuilder itemBuilder;
  int itemCount;

  PagerCarousel({@required this.itemCount, @required this.itemBuilder});

  @override
  PagerCarouselState createState() {
    return new PagerCarouselState(itemCount);
  }
}

class PagerCarouselState extends State<PagerCarousel> {
  TransformerPageController _controller;


  PagerCarouselState(int count) {
    _controller =
        TransformerPageController(viewportFraction: 0.85, itemCount: count);

  }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 0.85,
        child: TransformerPageView(
          viewportFraction: 0.8,
          pageController: _controller,
          transformer:  ZoomOutPageTransformer(),
          itemBuilder: widget.itemBuilder,
          itemCount: widget.itemCount,
          onPageChanged: (int i) async {
              await Future.delayed(Duration(microseconds: 4000));
              Vibrate.feedback(FeedbackType.impact);
          },
        ),
      ),
    );
  }
}
