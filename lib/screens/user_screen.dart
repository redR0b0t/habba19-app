import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:habba2019/models/error_model.dart';
import 'package:habba2019/stores/user_store.dart';
import 'package:habba2019/utils/custom_painter.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'package:habba2019/stores/auth_store.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter/services.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:url_launcher/url_launcher.dart';

class UserScreen extends StatefulWidget {
  @override
  _UserScreenState createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen>
    with StoreWatcherMixin<UserScreen>, TickerProviderStateMixin<UserScreen> {
  AuthStore authStore;
  UserStore store;
  TabController tabController;

  Color left = Colors.black;
  Color right = Colors.white;

  bool _isLoading = false;
  bool _isError = false;
  ErrorModel _errorModel;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    authStore = listenToStore(authStoreToken);
    store = listenToStore(userStoreToken);
    _fetchDetails();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
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
    if (!authStore.isLoggedIn) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text('Welcome Guest'),
        ),
        body: Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
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
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Login to view and register to events!',
                              style: TextStyle(fontSize: 20.0),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RaisedButton(
                              child: Text('Login'),
                              onPressed: () {
                                AuthStoreActions.guestLogin.call(false);
                              },
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    if (_isError) {
      return Center(
        child: Column(
          children: <Widget>[
            Text(_errorModel.message),
            FlatButton(
              child: Text('Retry'),
              onPressed: _fetchDetails,
            )
          ],
        ),
      );
    }
    if (_isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(
              Themex.CustomColors.iconActiveColor),
        ),
      );
    }
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Welcome ${store.userDetailsModel.data.details.name}'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings_power),
            tooltip: 'Log Out',
            onPressed: () {
              AuthStoreActions.changeAuth.call(false);
            },
          )
        ],
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
            Tab(text: 'Your Events'),
            Tab(
              text: 'Your Notifications',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [_buildUserEvents(), _buildUserNotifications()],
        controller: tabController,
      ),
    );
  }

  Widget _buildUserEvents() {
    if (store.eventsRegistered.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
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
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Register yourself to some event! Right Now!\nヾ(｡ꏿ﹏ꏿ)ﾉﾞ',
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return NotificationListener<OverscrollIndicatorNotification>(
      onNotification: (OverscrollIndicatorNotification overscroll) {
        overscroll.disallowGlow();
      },
      child: ListView.builder(
        padding: EdgeInsets.only(bottom: 100.0),
        itemBuilder: (BuildContext context, int index) {
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
                          store.eventsRegistered[index].name,
                          style: TextStyle(fontSize: 25),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text('Rules: '),
                        ),
                        Text(
                          store.eventsRegistered[index].rules,
                          style: TextStyle(color: Colors.black54),
                        ),
                        Row(
                          children: <Widget>[
                            Text('Organizer Details: '),
                            IconButton(
                              icon: Icon(
                                FontAwesomeIcons.whatsapp,
                                size: 18,
                              ),
                              onPressed: () async {
                                String phoneNumber = '91' +
                                    store.eventsRegistered[index].phoneNumber;
                                String url =
                                    "https://api.whatsapp.com/send?phone=$phoneNumber&text=Hey%21+${store.eventsRegistered[index].organizerName}+I+wanted+to+registered+to+your+event";
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
                                String phoneNumber = '91' +
                                    store.eventsRegistered[index].phoneNumber;
                                String url = "tel://$phoneNumber";
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else
                                  Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text('Cannot open dialer')));
                              },
                            )
                          ],
                        ),
                        Row(
                          children: <Widget>[
                            Text(
                              store.eventsRegistered[index].organizerName + ' - ',
                              style: TextStyle(color: Colors.black54),
                            ),
                            Text(
                              store.eventsRegistered[index].phoneNumber.trim().length == 0
                                  ? 'No contact info'
                                  : store.eventsRegistered[index].phoneNumber,
                              style: TextStyle(color: Colors.black54),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
        itemCount: store.eventsRegistered.length,
      ),
    );
  }

//  Widget _buildUserEvents() {
//    return SingleChildScrollView(
//      child: Padding(
//        padding: const EdgeInsets.symmetric(vertical: 10),
//        child: Padding(
//          padding: const EdgeInsets.all(8.0),
//          child: CustomExpansionPanelList(
//            expansionCallback: (int index, bool isExpanded) {
//              print('$index $isExpanded');
//              setState(() {
//                store.eventsRegistered[index].isExpanded = !isExpanded;
//              });
//            },
//            children: store.eventsRegistered.map((EventsRegistered event) {
//              return CustomExpansionPanel(
//                isExpanded: event.isExpanded,
//                headerBuilder: (BuildContext context, bool isExpanded) {
//                  return basicInfo(event, isExpanded);
//                },
//                body: dropDown(event, context),
//              );
//            }).toList(),
//          ),
//        ),
//      ),
//    );
//  }

  Widget _buildUserNotifications() {
    if (store.userNotifications.length == 0) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
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
              borderRadius: BorderRadius.circular(10.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              'Seems awkwardly silent here!\nヾ(｡ꏿ﹏ꏿ)ﾉﾞ',
                              style: TextStyle(fontSize: 20.0),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }
    return Padding(
      padding:
          const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 90),
      child: Container(
        decoration: BoxDecoration(
//          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
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
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        store.userNotifications[index].title,
                        style: Themex.titleStyle,
                      ),
                      Text(store.userNotifications[index].message,
                          style: TextStyle(color: Colors.black54))
                    ],
                  ),
                );
              },
              itemCount: store.userNotifications.length,
            ),
          ),
        ),
      ),
    );
  }

  void _fetchDetails() async {
    setState(() {
      _isLoading = true;
      _isError = false;
    });
    Completer<Map> userDetailsCompleter = Completer<Map>();
    UserStoreActions.fetchUserDetails.call(userDetailsCompleter);
    Map res = await userDetailsCompleter.future;
    setState(() {
      _isLoading = false;
    });
    if (!res['success']) {
      _errorModel = ErrorModel.fromJson(res['error']);
      setState(() {
        _isError = true;
      });
    }
  }
}

