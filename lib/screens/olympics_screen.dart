import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:habba2019/models/olympics_model.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'dart:convert';

class OlympicsScreen extends StatefulWidget {
  @override
  _OlympicsScreenState createState() => _OlympicsScreenState();
}

class _OlympicsScreenState extends State<OlympicsScreen>
    with SingleTickerProviderStateMixin<OlympicsScreen> {
  TextStyle _collegeTextStyle = TextStyle(fontSize: 20);
  TextStyle _pointsTextStyle = TextStyle(fontSize: 15, color: Colors.black87);
  AnimationController _controller;
  Animation<double> _yTranlationAnimation, _opacityAnimation;
  String _aboutHabbaOlympics =
      'Acharya Habba’19 is planning something massive and breath-taking. Get ready to get your mind blown with the new concept about to unveil this year. The sense of  true sportsmanship, comradery, leadership and brotherhood are the most common things to be witnessed in this very event. New records are to be set and cheering for your representative would be nothing less than a treat. It shall ignite within you a spark that shall set the stage of Habba ablaze with a competitive edge as well as unbound cheer. ';

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
    _fetchColleges();
  }

  OlympicsModel _olympicsModel;
  bool _isLoading = false;

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
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Text('Habba Olympics'),
          centerTitle: true,
        ),
        body: Center(
          child: CircularProgressIndicator(
            valueColor:
                AlwaysStoppedAnimation(Themex.CustomColors.iconActiveColor),
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
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.info_outline),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => SimpleDialog(
                        title: Text('About Habba Olympics 2019'),
                        children: <Widget>[
                          Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(_aboutHabbaOlympics)),
                        ],
                      ),
                );
              },
            ),
          ],
          title: Text('Habba Olympics'),
          centerTitle: true,
          elevation: 0,
        ),
        body: AnimatedBuilder(
          animation: _controller,
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
          child: Container(
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                if (index == 0) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
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
                        borderRadius: BorderRadius.circular(10.0),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: <Widget>[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => _handleCollegePopup(
                                            _olympicsModel.data[index],
                                          ),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Image.asset(
                                                  'assets/1stplace.png'),
                                              Text(
                                                _olympicsModel.data[index].name,
                                                style: _collegeTextStyle,
                                              ),
                                              Row(
                                                children: <Widget>[
                                                  Text(
                                                    '${_olympicsModel.data[index].points} points',
                                                    style: _pointsTextStyle,
                                                  ),
                                                ],
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.info_outline,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: <Widget>[
                                    GestureDetector(
                                      onTap: () => _handleCollegePopup(
                                            _olympicsModel.data[index + 1],
                                          ),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Image.asset(
                                                  'assets/3rdplace.png'),
                                              Text(
                                                _olympicsModel
                                                    .data[index + 1].name,
                                                style: _collegeTextStyle,
                                              ),
                                              Text(
                                                '${_olympicsModel.data[index + 1].points} points',
                                                style: _pointsTextStyle,
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.info_outline,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () => _handleCollegePopup(
                                            _olympicsModel.data[index + 2],
                                          ),
                                      child: Row(
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Image.asset(
                                                  'assets/2ndplace.png'),
                                              Text(
                                                '${_olympicsModel.data[index + 2].name}',
                                                style: _collegeTextStyle,
                                              ),
                                              Text(
                                                '${_olympicsModel.data[index + 2].points} points',
                                                style: _pointsTextStyle,
                                              )
                                            ],
                                          ),
                                          Icon(
                                            Icons.info_outline,
                                            size: 15,
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }
                if (index == 1 || index == 2) {
                  return Container(
                    height: 0,
                    width: 0,
                  );
                }
                return Padding(
                  padding:
                      const EdgeInsets.only(left: 8.0, bottom: 8.0, right: 8.0),
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
                        borderRadius: BorderRadius.circular(10.0),
                        child: InkWell(
                          onTap: () => _handleCollegePopup(
                                _olympicsModel.data[index],
                              ),
                          child: Container(
                            color: Colors.white,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
//                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8.0),
                                    child: CircleAvatar(
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 7.0),
                                        child: Text(
                                          (index + 1).toString(),
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                      backgroundImage:
                                          AssetImage('assets/prize.png'),
                                      backgroundColor: Colors.white,
                                    ),
                                  ),
                                  Expanded(
                                    child: Text(
                                      _olympicsModel.data[index].name,
                                      textAlign: TextAlign.center,
                                      style: _collegeTextStyle,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      '${_olympicsModel.data[index].points} points',
                                      textAlign: TextAlign.right,
                                      style: _pointsTextStyle,
                                    ),
                                  ),
                                  Icon(Icons.info_outline, size: 15,)
                                ],
                              ),
                            ),
                          ),
                        )),
                  ),
                );
              },
              itemCount: _olympicsModel.data.length,
            ),
          ),
        ),
      ),
    );
  }

  void _fetchColleges() async {
    setState(() {
      _isLoading = true;
    });
    http.Response response =
        await http.get('https://api.habba19.tk/holy/colleges');
    Map jsonResponse = await jsonDecode(response.body);
    _controller.forward();
    setState(() {
      _isLoading = false;
      _olympicsModel = OlympicsModel.fromJson(jsonResponse);
    });
  }

  void _handleCollegePopup(Data data) {
    showDialog(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
            title: Text(
              data.name,
              textAlign: TextAlign.center,
            ),
            children: <Widget>[
              Image.network(
                data.imgUrl,
                width: 60,
                height: 60,
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(data.description),
              )
            ],
          ),
    );
  }
}
