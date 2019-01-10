import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:habba2019/widgets/form_item.dart';
import 'package:habba2019/widgets/apl_form.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:convert';
import 'package:http_parser/http_parser.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flushbar/flushbar.dart';

class APLStoreActions {
  static Action<Widget> addValue = Action<Widget>();
  static Action<BuildContext> removeValue = Action<BuildContext>();
  static Action<File> addImage = Action<File>();
  static Action<BuildContext> makeRequest = Action<BuildContext>();
  static Action<bool> setLoading = Action<bool>();
  static Action<String> setImageAsset = Action<String>();
}

class APLStore extends Store {
  List<FormItem> renderPipeline = [];
  List<int> valuePipeline = [];

  LeagueChoiceFormItem leagueChoiceFormItem ;
  NameFormItem nameFormItem = NameFormItem();
  PhoneNumberFormItem phoneNumberFormItem = PhoneNumberFormItem();
  EmailFormItem emailFormItem = EmailFormItem();
  USNFormItem usnFormItem = USNFormItem();
  ImageFormItem imageFormItem = ImageFormItem();
  DesignationFormItem designationFormItem = DesignationFormItem();
  DOBFormItem dobFormItem = DOBFormItem();
  CategoryFormItem categoryFormItem = CategoryFormItem();
  DepartmentFormItem departmentFormItem = DepartmentFormItem();
  CollegeFormItem collegeFormItem;

  File imageFile;

  String bannerImageAsset = '';


  APLStore() {
    collegeFormItem = CollegeFormItem(departmentFormItem);
    leagueChoiceFormItem =  LeagueChoiceFormItem(categoryFormItem);
    renderPipeline = [
      leagueChoiceFormItem,
      nameFormItem,
      imageFormItem,
      usnFormItem,
      dobFormItem,
      phoneNumberFormItem,
      emailFormItem,
      collegeFormItem,
      departmentFormItem,
      designationFormItem,
      categoryFormItem,
    ];
    triggerOnAction(APLStoreActions.addValue, (Widget valueWidget) {
      valuePipeline.add(1);
    });
    triggerOnAction(APLStoreActions.removeValue, (BuildContext context) {
      if (valuePipeline.length == 0) {
        Navigator.pop(context);
      }
      valuePipeline.removeLast();
    });
    triggerOnAction(APLStoreActions.setImageAsset, (String s) {
      this.bannerImageAsset = s;
    });
    triggerOnAction(APLStoreActions.addImage, (File f) {
      imageFile = f;
    });
    triggerOnAction(APLStoreActions.makeRequest, (BuildContext context) async {
      String URL2;
      if(leagueChoiceFormItem.value == 'APL')
        URL2 = 'http://acharyahabba.in/apl/apl_register.php';
      else URL2 = 'http://acharyahabba.in/apl/afl_register.php';
      var stream =
          http.ByteStream(DelegatingStream.typed(this.imageFile.openRead()));
      var length = await imageFile.length();
      var uri = Uri.parse(URL2);
      var req = http.MultipartRequest('POST', uri);
      var multipartFile = http.MultipartFile('image', stream, length,
          filename: basename(imageFile.path),
          contentType: MediaType('image', 'jpg'));
      req.files.add(multipartFile);
      req.fields.addAll({
        'email': emailFormItem.value,
        'name': nameFormItem.value,
        'dob': dobFormItem.value.year.toString(),
        'desig': designationFormItem.value,
        'cat': categoryFormItem.value,
        'num': phoneNumberFormItem.value,
        'clg': collegeFormItem.value,
        'dept': departmentFormItem.value,
        'usn': usnFormItem.value
      });
      Flushbar loader = FlushbarHelper.createInformation(
          message: 'Please Wait. Uploading image')
        ..isDismissible = false
        ..show(context);
      var res = await req.send();

      print('\t\t\t' + res.statusCode.toString());
      res.stream.transform(utf8.decoder).listen((value) {
        if (value != null) {
          loader.dismiss();
          FlushbarHelper.createInformation(message: value)..show(context);
        }
      });
    });
  }
}

StoreToken aplStoreToken = StoreToken(APLStore());
