import 'package:flutter/material.dart';
import 'package:habba2019/widgets/volunteer_form.dart';
import 'dart:ui';

class ListModal extends ModalRoute {
  List<String> options;
  String heading;
  Function onClick;

  ListModal({this.options, this.heading, this.onClick});

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
        child: Center(
          child: ListModalContent(
            options: this.options,
            onClick: this.onClick,
            heading: this.heading,
          ),
        ),
      ),
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

class ListModalContent extends StatefulWidget {
  List<String> options;
  String heading;
  Function onClick;

  ListModalContent({this.options, this.heading, this.onClick});

  @override
  _ListModalContentState createState() => _ListModalContentState();
}

class _ListModalContentState extends State<ListModalContent> {
  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: ListView.builder(
        itemBuilder: (BuildContext context, int index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                widget.heading,
                style: TextStyle(fontSize: 30.0),
                textAlign: TextAlign.center,
              ),
            );
          } else
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10.0),
                child: Container(
                  color: Colors.white70.withOpacity(0.5),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: () {
                        widget.onClick(index - 1);
                        Navigator.pop(context);
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              color: Colors.transparent,
                              child: Wrap(
                                children: <Widget>[
                                  Text(
                                    widget.options[index - 1],
                                    style: TextStyle(
                                      fontSize: 20.0,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
        },
        itemCount: widget.options.length + 1,
      ),
    );
  }
}
