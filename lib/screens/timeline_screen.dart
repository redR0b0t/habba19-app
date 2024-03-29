import 'dart:async';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habba2019/models/masterfetch_model.dart';
import 'package:habba2019/stores/auth_store.dart';
import 'package:habba2019/stores/event_store.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'package:habba2019/widgets/expandable_text.dart';
import 'package:url_launcher/url_launcher.dart';

class ScaffoldKeyChain {
  static final List<GlobalKey<ScaffoldState>> scaffoldKeyList = [
    GlobalKey<ScaffoldState>(debugLabel: 'key1'),
    GlobalKey<ScaffoldState>(debugLabel: 'key2'),
    GlobalKey<ScaffoldState>(debugLabel: 'key3'),
    GlobalKey<ScaffoldState>(debugLabel: 'key4')
  ];
}

class TimelineScreen extends StatefulWidget {
  @override
  _TimelineScreenState createState() => _TimelineScreenState();
}

class _TimelineScreenState extends State<TimelineScreen>
    with
        StoreWatcherMixin<TimelineScreen>,
        SingleTickerProviderStateMixin<TimelineScreen> {
  EventStore store;

  TextStyle _titleStyle = TextStyle(color: Colors.black, fontSize: 30);
  TextStyle _textStyle =
      TextStyle(color: Colors.black54, fontWeight: FontWeight.w100);
  bool isRegistering = false;

  String titleString = 'Acharya Habba';

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
    store = listenToStore(eventStoreToken);
    tabController.addListener(() {
      setState(() {
        switch (tabController.index) {
          case 0:
            titleString = 'Pre Habba';
            break;
          case 1:
            titleString = '28th March';
            break;
          case 2:
            titleString = '29th March';
            break;
          case 3:
            titleString = '30th March';
            break;
        }
      });
    });
  }

  TabController tabController;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tabController.dispose();
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
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text(titleString),
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 30.0,
            indicatorColor: Themex.CustomColors.iconActiveColor,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: <Widget>[
            Tab(text: 'Pre Habba'),
            Tab(
              text: 'Day 1',
            ),
            Tab(
              text: 'Day 2',
            ),
            Tab(
              text: 'Day 3',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [
          _buildEvents(0, store.day0Events),
          _buildEvents(1, store.day1Events),
          _buildEvents(2, store.day2Events),
          _buildEvents(3, store.day3Events),
        ],
        controller: tabController,
      ),
    );
  }

  Widget _buildEvents(int keyIndex, List<Event> events) {
    return Scaffold(
      backgroundColor: Colors.transparent,
//      key: ScaffoldKeyChain.scaffoldKeyList[keyIndex],
      body: ListView(
        children: events.map((Event event) {
          return EventContent(keyIndex, event);
        }).toList(),
      ),
    );
  }

  Widget buildContent(Event event, int keyIndex) {}

//

}

class EventContent extends StatelessWidget {
  int keyIndex;
  Event event;

  EventContent(this.keyIndex, this.event);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
      child: Container(
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
          borderRadius: BorderRadius.circular(10),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    event.name,
                    style: TextStyle(fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Description: '),
                  ),
                  Text(
                    event.description ?? ' ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text('Rules: '),
                  ),
                  Text(
                    event.rules ?? ' ',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Row(
                    children: <Widget>[
                      Text('Contact ${event.organizerName}: '),
                      IconButton(
                        icon: Icon(
                          FontAwesomeIcons.whatsapp,
                          size: 18,
                        ),
                        onPressed: () async {
                          String phoneNumber = '+91' + event.organizerPhone;
                          String url =
                              "https://api.whatsapp.com/send?phone=$phoneNumber&text=Hey%21+I+just+registered+to+your+event%2";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else
                            Scaffold.of(context).showSnackBar(SnackBar(
                                content: Text('Cannot open whatsapp')));
                        },
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.phone,
                          size: 18,
                        ),
                        onPressed: () async {
                          String phoneNumber = '+91' + event.organizerPhone;
                          String url = "tel://$phoneNumber";
                          if (await canLaunch(url)) {
                            await launch(url);
                          } else
                            Scaffold.of(context).showSnackBar(
                                SnackBar(content: Text('Cannot open dialer')));
                        },
                      )
                    ],
                  ),
                  Text(
                    'Starts On: ${DateTime.parse(event.startDate).day} March, ${DateTime.parse(event.startDate).hour}:${DateTime.parse(event.startDate).minute}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Text(
                    'Ends On: ${DateTime.parse(event.endDate).day} March, ${DateTime.parse(event.endDate).hour}:${DateTime.parse(event.endDate).minute}',
                    style: TextStyle(color: Colors.black54),
                  ),
                  Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.all(8),
                          child: Text(
                            event.fee.trim() == ''
                                ? 'Free Event'
                                : 'Fee: ₹${event.fee}',
                          )),
                      Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            event.fee.trim() == ''
                                ? 'You get Bragging Rights'
                                : 'Winner gets: ₹${event.prize}',
                          ),
                        ),
                      ),
                      FlatButton(
                        textColor: Themex.CustomColors.iconInactiveColor,
                        child: Text('REGISTER'),
                        onPressed: () =>
                            _handleRegister(keyIndex, event, context),
                      )
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _handleRegister(int keyIndex, Event event, BuildContext context) async {
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              'Registering',
              style: TextStyle(color: Colors.black),
            ),
            CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(
                  Themex.CustomColors.iconActiveColor),
            )
          ],
        ),
      ),
    );
    Completer<Map> eventRegCompleter = Completer<Map>();

    EventStoreActions.registerToEvent.call(
      EventRegistrationModel(
        completer: eventRegCompleter,
        eventId: event.eventId,
      ),
    );
    Map res = await eventRegCompleter.future;
    Scaffold.of(context).hideCurrentSnackBar();
    if (res['loginRequired'] ?? false) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login to register to events',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          action: SnackBarAction(
            label: 'Login',
            onPressed: () {
              AuthStoreActions.guestLogin.call(false);
              Navigator.of(context).pop();
            },
            textColor: Themex.CustomColors.iconActiveColor,
          ),
        ),
      );
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
            actions: <Widget>[
              FlatButton(
                child: Text('DISMISS'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
            title: Text('Note'),
            content: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Text(
                'Your registration is confirmed only after you pay the registration amount to one of the volunteers and obtain a registration reciept!',
              ),
            ),
          ),
    );
    if (!res['success']) {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.white,
          content: Text(
            'Error [${res['error']['code']}]: ${res['error']['message']}',
            style: TextStyle(color: Colors.black),
          ),
        ),
      );
      if (res['error']['code'] == 701) {
        Navigator.of(context).pop();
      }
      return;
    }
    Scaffold.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.white,
        content: Text(
          'Registered successfully!',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
