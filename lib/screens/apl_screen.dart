import 'dart:ui';
import 'dart:async';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:habba2019/constants.dart';
import 'package:habba2019/stores/apl_store.dart';

class APLScreen extends StatefulWidget {
  @override
  _APLScreenState createState() => _APLScreenState();
}

class _APLScreenState extends State<APLScreen>
    with StoreWatcherMixin<APLScreen> {
  APLStore store;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final ScrollController _scrollController = ScrollController();
  Flushbar _flushbar = FlushbarHelper.createError(message: '');

  @override
  void initState() {
    super.initState();
    store = listenToStore(aplStoreToken);
  }

  @override
  Widget build(BuildContext context) {
    Timer(
        Duration(milliseconds: 100),
        () => _scrollController
            .jumpTo(_scrollController.position.maxScrollExtent));
//    if(_scrollController.hasClients) {
//      _scrollController.animateTo(_scrollController.position.maxScrollExtent , duration: Duration(milliseconds: 100), curve: Curves.easeOut);
//    }
    return Stack(
      children: <Widget>[
        Container(
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage(
                "assets/bg1.jpg",
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        BlurBackDrop(),
        WillPopScope(
          onWillPop: () async {
            if (store.valuePipeline.length == 0) {
              return true;
            }
            APLStoreActions.removeValue.call(context);
            return (false);
          },
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            body: Container(
              color: Colors.transparent,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                controller: _scrollController,
                padding: EdgeInsets.symmetric(vertical: 50.0),
                itemBuilder: (BuildContext context, int i) {
                  int index = i - 1;
                  if (i == 0) return buildBanner(context);

                  if (i > store.renderPipeline.length)
                    return buildRegisterButton(context);

                  if (index == store.valuePipeline.length)
                    return buildWidget(context, index);

                  return buildValueWidget(context, index);
                },
                itemCount: store.valuePipeline.length + 2,
              ),
            ),
            floatingActionButton: FloatingActionButton(
              elevation: 0.0,
              heroTag: 'Lol',
              onPressed: () {
                String val =
                    store.renderPipeline[store.valuePipeline.length].value;
                String title =
                    store.renderPipeline[store.valuePipeline.length].getTitle();
                RegExp regex =
                    store.renderPipeline[store.valuePipeline.length].regex;
                if (store.renderPipeline[store.valuePipeline.length].value !=
                        null &&
                    store.valuePipeline.length < store.renderPipeline.length) {
                  if (regex != null) {
                    if (regex.hasMatch(val)) {
                      store.renderPipeline[store.valuePipeline.length]
                          .setValue(regex.stringMatch(val));
                      APLStoreActions.addValue.call(
                        store.renderPipeline[store.valuePipeline.length]
                            .getValueWidget(),
                      );
                    } else {
                      _flushbar
                        ..message = 'Enter a valid $title'
                        ..dismiss()
                        ..show(context);
                    }
                  } else
                    APLStoreActions.addValue.call(
                      store.renderPipeline[store.valuePipeline.length]
                          .getValueWidget(),
                    );
                } else if (store
                        .renderPipeline[store.valuePipeline.length].value ==
                    null) {
                  _scaffoldKey.currentState
                      .showSnackBar(SnackBar(content: Text('NULL')));
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
                APLStoreActions.removeValue.call(context);
              },
              child: Icon(Icons.arrow_left),
              backgroundColor: Colors.white70.withOpacity(0.7),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildValueWidget(BuildContext context, int index) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(7.0),
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(color: Colors.white70.withOpacity(0.5)),
            child: Column(
              children: <Widget>[
                Text(
                  store.renderPipeline[index].getTitle(),
                  style: TextStyle(fontSize: 18.0, fontFamily: 'ProductSans'),
                  textAlign: TextAlign.start,
                ),
                store.renderPipeline[index].getValueWidget()
              ],
            ),
          ),
        ),
      );

  Widget buildWidget(BuildContext context, int index) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white70.withOpacity(0.5)),
            child: store.renderPipeline[index].getWidget(context),
          ),
        ),
      );

  Widget buildRegisterButton(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white70.withOpacity(0.5)),
            child: GestureDetector(
              onTap: () async {
                await APLStoreActions.makeRequest.call(context);
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
            ),
          ),
        ),
      );

  Widget buildBanner(BuildContext context) => Padding(
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
                    padding:
                        const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
                    child: Image.asset(
//                      store.bannerImageAsset == ''? 'assets/habbalogo.png': store.bannerImageAsset,
                      'assets/apllogo.png',
                      scale: 1.5,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, right: 16.0, left: 16.0),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
//                      (store.bannerImageAsset == ''? 'AFL/APL': store.leagueChoiceFormItem.value) + ' Registration 2019',
                      'APL Registration 2019',
                      style: TextStyle(fontSize: kBannerSubTitleFontSize),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class BlurBackDrop extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        color: Colors.grey.withOpacity(0.3),
      ),
    );
  }
}
