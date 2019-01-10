import 'dart:io';

//import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:habba2019/stores/apl_store.dart';
import 'package:habba2019/widgets/form_item.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:habba2019/models/list_modal.dart';
import 'package:habba2019/constants.dart';
import 'package:google_sign_in/google_sign_in.dart';

const DESIGNATION = ['STUDENT', 'FACULTY'];
const APL_CATEGORY = ['BATSMAN', 'BOWLER', 'ALL-ROUNDER'];
const AFL_CATEGORY = ['GOALKEEPER', 'DEFENDER', 'MIDFIELDER', 'FORWARD'];

class NameFormItem with FormItem<String> {
  NameFormItem() {
    this.regex = new RegExp(r'^.{5,}$');
  }

  @override
  String getTitle() {
    return 'Name';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdTextInput(
        'Enter Name', this.setValue, () => this.validation(context));
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }
}

class USNFormItem with FormItem<String> {
  USNFormItem() {
    regex = RegExp('[A-Za-z]{3}[0-9]{2}[A-Za-z]{4}[0-9]{3}', caseSensitive: false);
  }

  @override
  String getTitle() {
    return 'AUID';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdTextInput(
        'Enter your AUID', this.setValue, () => this.validation(context), textCapitalization: TextCapitalization.characters);
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }
}

class PhoneNumberFormItem with FormItem<String> {
  PhoneNumberFormItem() {
    regex = RegExp(r'[0-9]{10}');
  }

  @override
  String getTitle() {
    return 'Phone Number';
  }

  @override
  TextInputType textInputType = TextInputType.phone;

  @override
  Widget getWidget(BuildContext context) {
    return stdTextInput('Enter your phone number', this.setValue,
        () => this.validation(context),
        textInputType: TextInputType.phone);
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }
}

class EmailFormItem with FormItem<String> {
  GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
    ],
  );

  @override
  String getTitle() {
    return 'Email';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdPrompt('ACHARYA EMAIL', () async {
      String email = await _handleSignIn(context);
      if (!email.endsWith('acharya.ac.in')) {
        FlushbarHelper.createError(
            message:
                'Select a Acharya Institutes issued email id\nOr contact the habba team at CPRD')
          ..show(context);
        return;
      }
      this.setValue(email);
      this.callAction();
    });
  }

  Future<String> _handleSignIn(BuildContext context) async {
    await _googleSignIn.signOut();
    try {
      await _googleSignIn.signIn();
      return _googleSignIn.currentUser.email;
    } catch (error) {
      print(error);
      FlushbarHelper.createError(message: 'Auth error. Call the dev!');
    }
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }
}

class ImageFormItem with FormItem<File> {
//  FirebaseVisionImage visionImage;
//  final FaceDetector faceDetector = FirebaseVision.instance.faceDetector();
//  List<Face> faces = [];

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }

  @override
  String getTitle() {
    return 'Your image';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdPrompt('TAKE A PICTURE', () async {
      File imageFile = await ImagePicker.pickImage(source: ImageSource.camera);
      if (imageFile != null) {
        File croppedFile = await ImageCropper.cropImage(
          sourcePath: imageFile.path,
          ratioX: 1.0,
          ratioY: 1.0,
          maxWidth: 512,
          maxHeight: 512,
        );
        if (croppedFile == null) croppedFile = imageFile;
        this.value = croppedFile;

        APLStoreActions.addImage.call(croppedFile);
        APLStoreActions.addValue.call(this.getValueWidget());
      } else
        return;
    });
  }

  @override
  Widget getValueWidget() {
    return Container(
      padding: EdgeInsets.all(8),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(5.0),
          child: Image.file(
            this.value,
            scale: 2.0,
          )),
    );
  }
}

class DesignationFormItem with FormItem<String> {
  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }

  @override
  String getTitle() {
    return 'Designation';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdPrompt(
      'CHOOSE YOUR DESIGNATION',
      () {
        Navigator.push(
          context,
          ListModal(
              options: DESIGNATION,
              onClick: (int opt) {
                this.setValue(DESIGNATION[opt]);
                this.callAction();
              },
              heading: 'SELECT YOUR DESIGNATION'),
        );
      },
    );
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }
}

class CategoryFormItem with FormItem<String> {

  String league = 'APL';

  void setLeague(String league) {
    this.league = league;
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }

  @override
  String getTitle() {
    return 'Category/Position';
  }

  @override
  Widget getWidget(BuildContext context) {
    List<String> arr = league == 'APL'? APL_CATEGORY: AFL_CATEGORY;
    return stdPrompt(
      'CHOOSE YOUR CATEGORY/POSITION',
      () {
        Navigator.push(
          context,
          ListModal(
              options: arr,
              onClick: (int opt) {
                this.setValue(arr[opt]);
                this.callAction();
              },
              heading: 'SELECT YOUR CATEGORY/POSITION'),
        );
      },
    );
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }
}

class DOBFormItem with FormItem<DateTime> {
  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }

  @override
  String getTitle() {
    return 'Select Your Year Of Birth';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdPrompt('YEAR OF BIRTH', () async {
      DateTime date = await showDatePicker(
        context: context,
        initialDate: DateTime(1995),
        firstDate: DateTime(1995),
        lastDate: DateTime(2000),
        initialDatePickerMode: DatePickerMode.year,
      );
      if (date != null) {
        this.setValue(date);
        this.callAction();
      }
    });
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value.year.toString());
  }
}

class CollegeFormItem with FormItem<String> {
  DepartmentFormItem d;
  List<String> collegeNames = [];

  CollegeFormItem(this.d) {
    for (College c in College.values)
      this.collegeNames.add(c.toString().split('.').last.replaceAll('_', ' '));
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }

  @override
  String getTitle() {
    return 'College';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdPrompt('SELECT YOUR COLLEGE', () {
      Navigator.push(
          context,
          ListModal(
              heading: 'Select Your College',
              options: this.collegeNames,
              onClick: (int i) {
                this.setValue(collegeNames[i]);
                d.createDepartments(i);
                this.callAction();
              }));
    });
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }
}

class DepartmentFormItem with FormItem<String> {
  List<String> departmentNames;

  void createDepartments(int collegeIndex) {
    departmentNames = DEPARTMENTS[College.values[collegeIndex]];
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
  }

  @override
  String getTitle() {
    return 'Course';
  }

  @override
  Widget getWidget(BuildContext context) {
    return stdPrompt('SELECT YOUR COURSE', () {
      Navigator.push(
          context,
          ListModal(
              heading: 'Select Your Course',
              options: departmentNames,
              onClick: (int i) {
                this.setValue(departmentNames[i]);
                this.callAction();
              }));
    });
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }
}

class LeagueChoiceFormItem with FormItem<String> {

  CategoryFormItem cfi;

  LeagueChoiceFormItem(this.cfi);

  @override
  String getTitle() {
    return 'Registering For';
  }

  @override
  void callAction() {
    APLStoreActions.addValue.call(this.getValueWidget());
    cfi.setLeague(this.value);
  }

  @override
  Widget getWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'AFL OR APL?',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    this.setValue('AFL');
                    APLStoreActions.setImageAsset.call('assets/afllogo.png');
                    this.callAction();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'AFL',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
              VerticalDivider(
                color: Colors.black87,
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    this.setValue('APL');
                    APLStoreActions.setImageAsset.call('assets/apllogo.png');
                    this.callAction();
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'APL',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  Widget getValueWidget() {
    return stdTextBox(this.value);
  }
}
