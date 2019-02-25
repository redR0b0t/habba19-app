import 'dart:async';

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:habba2019/models/masterfetch_model.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar.dart';
import 'package:habba2019/stores/auth_store.dart';
import 'package:habba2019/stores/event_store.dart';
import 'package:habba2019/widgets/custom_expansion.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'package:habba2019/stores/event_store.dart';
import 'package:flutter_flux/flutter_flux.dart';

class SearchScreen extends StatefulWidget {
  SearchScreen();

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen>
    with StoreWatcherMixin<SearchScreen> {
  EventStore store;

  void initState() {
    super.initState();
    store = listenToStore(eventStoreToken);
  }

  List<Event> eventList = [];
  TextStyle _titleStyle = TextStyle(color: Colors.black, fontSize: 30);
  TextStyle _textStyle =
      TextStyle(color: Colors.black54, fontWeight: FontWeight.w100);
  bool isRegistering = false;
  String searchTerm = '';
  Flushbar _flushbar =
      FlushbarHelper.createInformation(message: 'Registrations will open soon');

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Scaffold(
        appBar: PreferredSize(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Hero(
                  tag: 'SEARCH',
                  child: Material(
                    color: Colors.transparent,
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: TextField(
                            autofocus: true,
                            decoration: InputDecoration(
                                hintText: 'Search for events!',
                                border: InputBorder.none),
                            onChanged: (String s) {
                              setState(() {
                                this.searchTerm = s;
                              });
                            },
                            onEditingComplete: () {
                              setState(() {
                                this.eventList =
                                    store.masterList.where((Event e) {
                                  return e.name
                                      .toLowerCase()
                                      .contains(searchTerm.toLowerCase());
                                }).toList();
                                FocusScope.of(context).requestFocus(new FocusNode());
                              });
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            tapSearch();
                          },
                          icon: Icon(Icons.search),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
            preferredSize: Size(150, 40)),
        backgroundColor: Colors.transparent,
        key: scaffoldKey,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: CustomExpansionPanelList(
                expansionCallback: (int index, bool isExpanded) {
                  print('$index $isExpanded');
                  setState(() {
                    eventList[index].isExpanded = !isExpanded;
                  });
                },
                children: eventList.map((Event event) {
                  return CustomExpansionPanel(
                      isExpanded: event.isExpanded,
                      headerBuilder: (BuildContext context, bool isExpanded) {
                        return basicInfo(event, isExpanded);
                      },
                      body: dropDown(event, context));
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget basicInfo(event, isExpanded) => Container(
        height: MediaQuery.of(context).size.height / 4,
        child: Container(
          child: Stack(
            children: <Widget>[
              Container(
                color: Colors.black,
              ),
              Row(
                children: <Widget>[
                  Expanded(
                      child: CachedNetworkImage(
                    imageUrl: event.imgUrl,
                    fit: BoxFit.cover,
                  )),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      !isExpanded ? Colors.black : Colors.transparent,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              Center(
                child: !isExpanded
                    ? renderTitle(event.name)
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Flexible(
                            flex: 1,
                            child: Container(),
                          ),
                          Flexible(flex: 1, child: renderTitle(event.name)),
                          Flexible(
                            flex: 1,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Container(
                                        padding: EdgeInsets.all(8),
                                        color: Colors.black.withOpacity(0.5),
                                        child: Text(
                                          event.fee.trim() == ''
                                              ? 'Free Event'
                                              : 'Fee: ₹${event.fee}',
                                          style: TextStyle(color: Colors.white),
                                        )),
                                    Container(
                                        color: Colors.black.withOpacity(0.5),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            event.fee.trim() == ''
                                                ? 'You get Bragging Rights'
                                                : 'Winner gets: ₹${event.prize}',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ],
          ),
        ),
      );

  Widget renderTitle(String name) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        name,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget dropDown(Event event, BuildContext context) => Container(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Description',
                        textAlign: TextAlign.start,
                        style: _titleStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        event.description ?? 'No description avaliable',
                        textAlign: TextAlign.start,
                        style: _textStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        'Rules And Regulations',
                        textAlign: TextAlign.start,
                        style: _titleStyle,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        event.rules == null || event.rules.trim() == ''
                            ? 'No rules avaliable'
                            : event.rules.replaceAll('\n', '\n\n'),
                        textAlign: TextAlign.start,
                        style: _textStyle,
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
//                  FlatButton(
//                    onPressed: _handleExpansion,
//                    child: Text('Close'),
//                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8),
                    child: FlatButton(
                      textColor: Themex.CustomColors.iconInactiveColor,
                      child: Text('REGISTER'),
                      onPressed: isRegistering
                          ? null
                          : () async {
                              setState(() {
                                this.isRegistering = true;
                              });
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        'Registering',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                      CircularProgressIndicator(
                                        valueColor:
                                            new AlwaysStoppedAnimation<Color>(
                                                Themex.CustomColors
                                                    .iconActiveColor),
                                      )
                                    ],
                                  ),
                                ),
                              );
                              Completer<Map> eventRegCompleter =
                                  Completer<Map>();

                              EventStoreActions.registerToEvent.call(
                                EventRegistrationModel(
                                  completer: eventRegCompleter,
                                  eventId: event.eventId,
                                ),
                              );
                              Map res = await eventRegCompleter.future;
                              setState(() {
                                isRegistering = false;
                              });
                              scaffoldKey.currentState.hideCurrentSnackBar();
                              if (res['loginRequired'] ?? false) {
                                scaffoldKey.currentState.showSnackBar(
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
                                      textColor:
                                          Themex.CustomColors.iconActiveColor,
                                    ),
                                  ),
                                );
                                return;
                              }
                              if (!res['success']) {
                                scaffoldKey.currentState.showSnackBar(
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
                              scaffoldKey.currentState.showSnackBar(
                                SnackBar(
                                  backgroundColor: Colors.white,
                                  content: Text(
                                    'Registered successfully!',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              );
                            },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );

  void tapSearch() {
    setState(() {
      this.eventList = store.masterList.where((Event e) {
        return e.name.toLowerCase().contains(searchTerm.toLowerCase());
      }).toList();
      FocusScope.of(context).requestFocus(new FocusNode());
    });
  }
}
