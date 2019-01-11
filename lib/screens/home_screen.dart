import 'package:flutter/material.dart';
import 'dart:ui';

import 'package:habba2019/screens/apl_screen.dart';
import 'package:habba2019/screens/volunteer_screen.dart';
import 'package:habba2019/widgets/stepper.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

ImageFilter imgFilter = ImageFilter.blur(sigmaY: 10, sigmaX: 10);

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(
                "assets/bg2.jpg",
              ),
              fit: BoxFit.cover,
              colorFilter: ColorFilter.mode(Colors.white, BlendMode.modulate),
            ),
          ),
        ),
        BlurBackDrop(),
        Scaffold(
          backgroundColor: Colors.transparent,
          body: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: Image.asset(
                    'assets/habbalogo.png',
                    scale: 1.5,
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '🏏APL🏏\nPlayer',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 25.0, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(
                          '🎉Habba🎉\nVolunteer',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 25.0,
                              color: Colors.white,
                              shadows: [Shadow()]),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              StepperTouch(
                initialValue: 0,
                onChanged: (int v) {
                  if (v == 1) {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context, _, __) =>
                            VolunteerScreen(),
                        transitionsBuilder: (_, Animation<double> animation, __,
                                Widget child) =>
                            FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                      ),
                    );
                  } else {
                    Navigator.of(context).push(
                      PageRouteBuilder(
                        pageBuilder: (BuildContext context, _, __) =>
                            APLScreen(),
                        transitionsBuilder: (_, Animation<double> animation, __,
                                Widget child) =>
                            FadeTransition(
                              opacity: animation,
                              child: child,
                            ),
                      ),
                    );
                  }
                },
              ),
              Expanded(
                child: Container(),
              ),
              Text(
                'Upon successful registration, a Registration Email will be sent to the provided email addresses. '
                    'In case of any queries, please contact the Habba19 Team at the CPRD block\n'
                    ''
                    'Acharya Premier League (APL) and Acharya Football League (AFL) are a part of Habba 2019',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white70),
              )
            ],
          ),
        ),
      ],
    );
  }
}

class BlurBackDrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.withOpacity(0.5),
      ),
    );
  }
}
