import 'dart:async';
import 'dart:convert';
import 'package:habba2019/stores/auth_store.dart';
import 'package:habba2019/stores/user_store.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_flux/flutter_flux.dart';
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:io';

import 'package:habba2019/models/masterfetch_model.dart';

class EventRegistrationModel {
  Completer<Map> completer;
  int eventId;

  EventRegistrationModel({@required this.completer, @required this.eventId});
}

class EventStoreActions {
  static Action<Completer> masterfetch = Action();
  static Action<String> registerDevice = Action<String>();
  static Action<EventRegistrationModel> registerToEvent =
      Action<EventRegistrationModel>();
}

class EventStore extends Store {
  MasterfetchModel masterfetchModel;
  String deviceToken = '';
  List<Event> masterList = <Event>[];
  List<Event> day0Events = <Event>[];
  List<Event> day1Events = <Event>[];
  List<Event> day2Events = <Event>[];
  List<Event> day3Events = <Event>[];

  EventStore() {
    triggerOnAction(EventStoreActions.registerToEvent,
        (EventRegistrationModel eventReg) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = await preferences.getString('token');
      if (token == null) {
        eventReg.completer.complete({'loginRequired': true});
        return;
      }
      const String url = 'https://api.habba19.tk/events/user/register';
      try {
        http.Response response = await http.post(
          url,
          body: {
            'event_id': eventReg.eventId.toString(),
            'device_id': deviceToken
          },
          headers: {'user_id': token},
        );
        Map jsonMap = await jsonDecode(response.body);
        if (!jsonMap['success']) {
          if (jsonMap['error']['code'] == 701) {
            AuthStoreActions.changeAuth.call(false);
          }
        }
        eventReg.completer.complete(jsonMap);
        UserStoreActions.fetchUserDetails.call(Completer<Map>());
      } on SocketException catch (e) {
        eventReg.completer
            .complete({'success': false, 'code': 0, 'message': 'No Network'});
      }
    });

    triggerOnAction(EventStoreActions.registerDevice,
        (String deviceToken) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      this.deviceToken = await preferences.getString('deviceToken');
      if (this.deviceToken == null || this.deviceToken == '') {
        http.Response response = await http.post(
          'https://api.habba19.tk/events/subgen',
          body: {'device_id': deviceToken},
        );
        this.deviceToken = deviceToken;
        if (response.statusCode == 200) {
          print(response.body);
          if (jsonDecode(response.body)['success']) {
            await preferences.setString('deviceToken', deviceToken);
            print('registered device');
          }
        }
      }
    });

    triggerOnAction(EventStoreActions.masterfetch, (Completer completer) async {
      try {
        http.Response response =
            await http.get('https://api.habba19.tk/events/masterfetch');
        Map jsonResponse = await jsonDecode(response.body);
        if (jsonResponse['success']) {
          masterfetchModel = MasterfetchModel.fromJson(jsonResponse['data']);
          print(response.body);
          this.masterList.clear();
          this.masterList = masterfetchModel.masterList;
          this.day0Events = masterfetchModel.day0List;
          this.day1Events = masterfetchModel.day1List;
          this.day2Events = masterfetchModel.day2List;
          this.day3Events = masterfetchModel.day3List;
        }
        completer.complete(jsonResponse['success']);
      } on SocketException catch (e) {
        completer.complete({
          'success': false,
          'error': {'code': 0, 'message': 'No Network'}
        });
      }
    });
  }
}

StoreToken eventStoreToken = StoreToken(EventStore());
