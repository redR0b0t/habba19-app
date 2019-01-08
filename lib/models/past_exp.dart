import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:habba2019/widgets/volunteer_form.dart';
import 'dart:ui';

import 'package:habba2019/stores/volunteer_store.dart';

class PastExperienceModal extends ModalRoute {
  @override
  // TODO: implement barrierColor
  Color get barrierColor => Colors.grey.withOpacity(0.3);

  @override
  // TODO: implement barrierDismissible
  bool get barrierDismissible => true;

  @override
  // TODO: implement barrierLabel
  String get barrierLabel => null;

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation, Widget child) {
    // TODO: implement buildTransitions
    return FadeTransition(
      opacity: animation,
      child: ScaleTransition(
        scale: animation,
        child: child,
      ),
    );
  }

  @override
  Widget buildPage(BuildContext context, Animation<double> animation,
      Animation<double> secondaryAnimation) {
    // TODO: implement buildPage
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Center(child: PastExperienceSelector())),
    );
  }

  @override
  // TODO: implement maintainState
  bool get maintainState => false;

  @override
  // TODO: implement opaque
  bool get opaque => false;

  @override
  // TODO: implement transitionDuration
  Duration get transitionDuration => Duration(milliseconds: 100);
}

class PastExperienceSelector extends StatefulWidget {
  @override
  _PastExperienceSelectorState createState() => _PastExperienceSelectorState();
}

class _PastExperienceSelectorState extends State<PastExperienceSelector> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Center(
              child: Text(
                'Your Volunteer experience in Acharya Habba',
                style: TextStyle(fontSize: 40.0),
                textAlign: TextAlign.center,
              ),
            ),
            ExperienceClickable(Experience.Zero),
            ExperienceClickable(Experience.One),
            ExperienceClickable(Experience.Two),
            ExperienceClickable(Experience.Three),
          ],
        ),
      ),
    );
  }
}

class ExperienceClickable extends StatelessWidget {
  final String ex;

  ExperienceClickable(this.ex);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaY: 5.0, sigmaX: 5.0),
        child: Container(
          color: Colors.white70.withOpacity(0.5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                RegStoreActions.selectExperience.call(ex);
                RegStoreActions.addValue.call('Participated in $ex years of Habba');
                Navigator.pop(context);
              },
              child: Container(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  ex,
                  style: TextStyle(
                    fontSize: 50.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
