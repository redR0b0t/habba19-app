import 'dart:async';
import 'dart:convert';

import 'package:flutter_flux/flutter_flux.dart';
import 'package:habba2019/stores/auth_store.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:habba2019/models/user_details_model.dart';

class UserStoreActions {
  static Action<Completer> fetchUserDetails = Action<Completer>();
}

class UserStore extends Store {
  List<EventsRegistered> eventsRegistered = [];
  List<Notifications> userNotifications = [];
  UserDetailsModel userDetailsModel;
  UserStore() {
    triggerOnAction(UserStoreActions.fetchUserDetails, (Completer completer) async {
      SharedPreferences preferences = await SharedPreferences.getInstance();
      String token = await preferences.getString('token');
      const String url = 'https://api.habba19.tk/events/user/details';
      if(token != null) {
        http.Response response = await http.get(url, headers: {
          'user_id': token
        });
        Map jsonMap = await jsonDecode(response.body);
        if(!jsonMap['success'] && jsonMap['error']['code'] == 701)
          AuthStoreActions.changeAuth.call(false);
        if(jsonMap['success']) {
          eventsRegistered.clear();
          userNotifications.clear();
          userDetailsModel = UserDetailsModel.fromJson(jsonMap);
          eventsRegistered.addAll(userDetailsModel.data.eventsRegistered);
          userNotifications.addAll(userDetailsModel.data.notifications);
        }
        completer.complete(jsonMap);
      }
    });
  }
}

StoreToken userStoreToken = StoreToken(UserStore());