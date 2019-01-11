import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:habba2019/constants.dart';
import 'package:habba2019/stores/volunteer_store.dart';
import 'dart:ui';
import 'dart:async';

class VolunteerScreen extends StatefulWidget {
  // This widget is the root of your application.
  @override
  VolunteerScreenState createState() {
    return new VolunteerScreenState();
  }
}

class VolunteerScreenState extends State<VolunteerScreen>
    with StoreWatcherMixin<VolunteerScreen> {
  RegStore store;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  Flushbar _flushbar = FlushbarHelper.createError(message: '');

  @override
  void initState() {
    super.initState();
    store = listenToStore(regStoreToken);
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 100),
            () =>
            _scrollController
                .jumpTo(_scrollController.position.maxScrollExtent));

    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
                image: new AssetImage(
                  "assets/bg1.jpg",
                ),
                fit: BoxFit.cover,
                colorFilter:
                ColorFilter.mode(Colors.white, BlendMode.modulate)),
          ),
        ),
        BlurBackDrop(),
        WillPopScope(
          onWillPop: () async {
            if (store.valueList.length == 0) {
              return true;
            }
            RegStoreActions.removeValue.call(context);
            return (false);
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Container(
              color: Colors.transparent,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(vertical: 50.0),
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                itemBuilder: (BuildContext context, int i) {
                  int index = i - 1;
                  if (i == 0) return _buildBanner(context);
                  if (i > store.renderPipeline.length)
                    return _buildReturnButton(context);
                  if (index == store.valueList.length)
                    return _buildWidget(context, index);
                  return _buildValueWidget(context, index);
                },
                itemCount: store.valueList.length + 2,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              heroTag: 'Lol',
              onPressed: () {
                String val = store.renderPipeline[store.valueList.length].value;
                String title =
                store.renderPipeline[store.valueList.length].getTitle();
                RegExp regex =
                    store.renderPipeline[store.valueList.length].regex;
                if (store.renderPipeline[store.valueList.length].value !=
                    null &&
                    store.valueList.length < store.renderPipeline.length) {
                  if (regex != null) {
                    if (regex.hasMatch(val)) {
                      RegStoreActions.addValue.call(regex.stringMatch(val));
                    } else {
                      _flushbar
                        ..message = 'Enter a valid $title'
                        ..dismiss()
                        ..show(context);
                    }
                  } else
                    RegStoreActions.addValue.call(val);
                }
              },
              child: Icon(Icons.arrow_right),
              backgroundColor: Colors.white70.withOpacity(0.7),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomLeft,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: FloatingActionButton(
              elevation: 0.0,
              onPressed: () {
                RegStoreActions.removeValue.call(context);
              },
              child: Icon(Icons.arrow_left),
              backgroundColor: Colors.white70.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildValueWidget(BuildContext context, int index) =>
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
                color: Colors.white70.withOpacity(0.5)),
            child: Column(
              children: <Widget>[
                Text(
                  store.renderPipeline[index].getTitle(),
                  style: TextStyle(
                      fontSize: 18.0, fontFamily: 'ProductSans'),
                  textAlign: TextAlign.start,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    store.valueList[index],
                    style: TextStyle(
                        fontSize: kValueWidgetFontSize,
                        fontFamily: 'ProductSans'),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildWidget(BuildContext context, int index) =>
      Padding(
        padding:
        EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white70.withOpacity(0.5)),
            child: store.renderPipeline[index].getWidget(context),
          ),
        ),
      );

  Widget _buildBanner(BuildContext context) =>
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            color: Colors.white70.withOpacity(0.5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Padding(
                  padding:
                  const EdgeInsets.only(top: 8.0, right: 16.0, left: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Acharya Habba',
                      style: TextStyle(fontSize: kBannerTitleFontSize),
                    ),
                  ),
                ),
                ClipRRect(
                  borderRadius: BorderRadius.circular(10.0),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Image.asset(
                      'assets/habbalogo.png',
                      scale: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.only(bottom: 8.0, right: 16.0, left: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Volunteer Registration 2019',
                      style: TextStyle(fontSize: kBannerSubTitleFontSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _buildReturnButton(BuildContext context) =>
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
              decoration: BoxDecoration(color: Colors.white70.withOpacity(0.5)),
              child: GestureDetector(
                onTap: () {
                  RegStoreActions.makeRequest.call(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        padding: EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            'REGISTER️',
                            style: TextStyle(fontSize: 20.0),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )),
        ),
      );


}

class BlurBackDrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        width: MediaQuery
            .of(context)
            .size
            .width,
        height: MediaQuery
            .of(context)
            .size
            .height,
        color: Colors.grey.withOpacity(0.5),
      ),
    );
  }
}
