import 'package:flutter/material.dart';
import 'package:gradient_widgets/gradient_widgets.dart';

class EventListCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
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
        child: Material(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: <Widget>[
                eventNameText('CS GO'),
                eventNameText('COD'),
                eventNameText('COD'),
                eventNameText('DOTA'),
                eventNameText('FIFA'),
                eventNameText('Road Rash'),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Widget eventNameText(String s) => Container(
      padding: EdgeInsets.all(8),
      child: GradientText(s,
          textAlign: TextAlign.center,
          gradient: Gradients.hotLinear,
          shaderRect: Rect.fromLTWH(0.0, 0.0, 200.0, 100.0),
          style: TextStyle(
            fontFamily: 'S',
            fontSize: 30,
            fontWeight: FontWeight.w600,
          )),
    );
