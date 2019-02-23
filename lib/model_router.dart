import 'dart:async';

import 'package:flutter/material.dart';
import 'package:habba2019/widgets/flip_card.dart';

class PageDetailRoute extends ModalRoute {
  int index;
  PageDetailRoute(this.index);
  @override
  Color get barrierColor => Colors.white.withOpacity(0.1);

  @override
  bool get barrierDismissible => false;

  @override
  String get barrierLabel => '';

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    return PageDetail(index);
  }

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }

  @override
  bool get maintainState => true;

  @override
  bool get opaque => false;

  @override
  Duration get transitionDuration => Duration(milliseconds: 500);
}

class PageDetail extends StatefulWidget {
  int index;

  PageDetail(this.index);

  @override
  _PageDetailState createState() => _PageDetailState();
}

class _PageDetailState extends State<PageDetail> {
  Timer _timer;
  bool _loaded = false;
  Function _toggleCard;

  _PageDetailState() {
    _timer = Timer(Duration(milliseconds: 500), () {
      setState(() {
        _loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
        tag: widget.index,
        child: Scaffold(
          floatingActionButton: _loaded ? _buildFAB() : null,
          body: FlipCard(
            back: Container(
              color: Colors.redAccent,
            ),
            front: Container(color: Colors.blueAccent),
            cb: (Function actual) {
              _toggleCard = actual;
            },
          ),
        ));
  }

  FloatingActionButton _buildFAB() => FloatingActionButton(
        onPressed: _toggleCard,
        child: Icon(Icons.chevron_right),
      );
}
