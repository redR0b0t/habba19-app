import 'package:flutter/material.dart';
import 'package:habba2019/constants.dart';
import 'package:habba2019/widgets/form_item.dart';
import 'package:habba2019/stores/volunteer_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:habba2019/models/list_modal.dart';

class Experience {
  static const String One = 'One';
  static const String Two = 'Two';
  static const String Three = 'Three';
  static const String Zero = 'Zero';
}

class NameFormItem with FormItem<String> {
  NameFormItem() {
    regex = new RegExp(r'^.{5,}$');
  }

  @override
  Widget getWidget(BuildContext context) => TextField(
        autofocus: true,
        textInputAction: TextInputAction.next,
        maxLines: 1,
        onSubmitted: validation(context),
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 25.0, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          hintText: 'Enter your name',
        ),
        onChanged: this.setValue,
      );

  @override
  String getTitle() {
    return 'Name';
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class USNFormItem with FormItem<String> {
  USNFormItem() {
    regex = RegExp('[a-z1-9]{0,12}', caseSensitive: false);
  }

  @override
  TextInputType textInputType = TextInputType.text;

  @override
  Widget getWidget(BuildContext context) => TextField(
        textInputAction: TextInputAction.next,
        maxLines: 1,
        autofocus: true,
        onSubmitted: validation(context),
        textCapitalization: TextCapitalization.characters,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 25.0, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          hintText: 'Enter your USN',
        ),
        onChanged: this.setValue,
      );

  @override
  String getTitle() {
    return 'USN';
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class EmailFormItem with FormItem<String> {
  EmailFormItem() {
    regex = RegExp(
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  }

  @override
  TextInputType textInputType = TextInputType.emailAddress;

  @override
  Widget getWidget(BuildContext context) => TextField(
        textInputAction: TextInputAction.next,
        autofocus: true,
        onSubmitted: validation(context),
        maxLines: 1,
        keyboardType: textInputType,
        style: TextStyle(fontSize: 25.0, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          hintText: 'Enter your email',
        ),
        onChanged: this.setValue,
      );

  @override
  String getTitle() {
    return 'Email';
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class PhoneNumberFormItem with FormItem<String> {
  PhoneNumberFormItem() {
    regex = RegExp(r'[0-9]{10}');
  }

  @override
  TextInputType textInputType = TextInputType.phone;

  @override
  Widget getWidget(BuildContext context) => TextField(
        textInputAction: TextInputAction.next,
        maxLines: 1,
        keyboardType: textInputType,
        autofocus: true,
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          hintText: 'Phone number',
        ),
        onSubmitted: validation(context),
        onChanged: this.setValue,
      );

  @override
  String getTitle() {
    return 'Phone';
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class ExperienceFormItem with FormItem<String> {
  TextInputType textInputType = TextInputType.text;

  @override
  Widget getWidget(BuildContext context) {
    List<String> data = [
      Experience.Zero,
      Experience.One,
      Experience.Two,
      Experience.Three
    ];
    return GestureDetector(
      onTap: () {
//        Navigator.push(context, PastExperienceModal());
        Navigator.push(
          context,
          ListModal(
              heading: 'Past Habba Volunteer Experience (in years)',
              options: data,
              onClick: (int i) {
                RegStoreActions.selectExperience.call(data[i]);
                RegStoreActions.addValue
                    .call('Volunteered in ${data[i]} year(s) of Habba');
                this.setValue(data[i]);
              }),
        );
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
                  'SELECT PAST EXPERIENCE ➡️',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  String getTitle() {
    return 'Past Experience';
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class ExperienceCategoryFormItem with FormItem<String> {
  @override
  Widget getWidget(BuildContext context) => TextField(
        textInputAction: TextInputAction.done,
        maxLines: 1,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 25.0, color: Colors.black45),
        onChanged: this.setValue,
        decoration: InputDecoration(labelText: 'Category of Experience'),
      );

  @override
  String getTitle() {
    return 'Past Category';
  }

  @override
  void callAction() {}
}

class InterestedCategoryFormItem with FormItem<String> {
  TextInputType textInputType = TextInputType.text;

  @override
  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
//        Navigator.push(context, PastExperienceModal());
        Navigator.push(
          context,
          ListModal(
              heading: 'Interested Categories',
              options: CATEGORIES,
              onClick: (int i) {
                RegStoreActions.addValue.call('Interested in ${CATEGORIES[i]}');
                this.setValue(CATEGORIES[i]);
              }),
        );
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
                  'SELECT INTERESTED CATEGORY ➡️',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  String getTitle() {
    return 'Interested Category';
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class CommSkillFormItem with FormItem<String> {
  @override
  String getTitle() {
    return 'Communication Skills';
  }

  @override
  Widget getWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Communication Skills',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: <Widget>[
              Expanded(child: CommRating(this.setValue, this.value)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class CommRating extends StatefulWidget {
  Function setValue;
  String val;

  CommRating(this.setValue, this.val);

  @override
  _CommRatingState createState() => _CommRatingState();
}

class _CommRatingState extends State<CommRating> {
  double val = 0.0;

  setValue(double d) {
    widget.setValue('Your rating ' + d.toString());
    print('\t\t\t d');
    setState(() {
      val = d;
    });
    setState(() {});
  }

  setVal2(double d) {
    RegStoreActions.addValue.call('Your rating ' + d.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.grey.withOpacity(0.8),
        child: CupertinoSlider(
          onChanged: setValue,
          onChangeEnd: setVal2,
          value: this.val,
          min: 0.0,
          max: 10.0,
          divisions: 10,
          activeColor: Colors.black,
        ),
      ),
    );
  }
}

class CollegeFormItem with FormItem<String> {
  DepartmentFormItem dfi;
  List<String> collegeNames = [];

  CollegeFormItem(DepartmentFormItem dfi) {
    this.dfi = dfi;
    for (College c in College.values)
      this.collegeNames.add(c.toString().split('.').last.replaceAll('_', ' '));
  }

  @override
  String getTitle() {
    return 'College';
  }

  @override
  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          ListModal(
              heading: 'Your College',
              options: collegeNames,
              onClick: (int i) {
                dfi.createDepartments(i);
                RegStoreActions.addValue.call('${collegeNames[i]}');
                this.setValue(collegeNames[i]);
              }),
        );
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
                  'SELECT YOUR COLLEGE ➡️',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class DepartmentFormItem with FormItem<String> {
  List<String> departmentNames = [];

  void createDepartments(int collegeIndex) {
    departmentNames = DEPARTMENTS[College.values[collegeIndex]];
  }

  @override
  String getTitle() {
    return 'Course';
  }

  @override
  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          ListModal(
              heading: 'Select Your Course',
              options: departmentNames,
              onClick: (int i) {
                RegStoreActions.addValue.call('${departmentNames[i]}');
                this.setValue(departmentNames[i]);
              }),
        );
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
                  'SELECT YOUR COURSE ➡️',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class SkillFormItem with FormItem<String> {
  @override
  String getTitle() {
    return 'Skills';
  }

  @override
  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          ListModal(
              heading: 'Your Skills (Select One)',
              options: SKILLS,
              onClick: (int i) {
                RegStoreActions.addValue.call('${SKILLS[i]}');
                this.setValue(SKILLS[i]);
              }),
        );
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
                  'YOUR MAJOR SKILL ➡️',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class YearFormItem with FormItem {
  @override
  String getTitle() {
    return 'Year';
  }

  @override
  Widget getWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          ListModal(
              heading: 'Your Year Of Study',
              options: YEARS,
              onClick: (int i) {
                RegStoreActions.addValue.call('${YEARS[i]}');
                this.setValue(YEARS[i]);
              }),
        );
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
                  'YOUR YEAR OF STUDY ➡️',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class ConvSkillFormItem with FormItem<String> {
  @override
  String getTitle() {
    return 'Convincing Skills';
  }

  @override
  Widget getWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'How well do you convince people',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(child: ConvRating(this.setValue, this.value)),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class ConvRating extends StatefulWidget {
  Function setValue;
  String val;

  ConvRating(this.setValue, this.val);

  @override
  _ConvRatingState createState() => _ConvRatingState();
}

class _ConvRatingState extends State<ConvRating> {
  double val = 0.0;

  setValue(double d) {
    widget.setValue('Your rating ' + d.toString());
    print('\t\t\t $d');
    setState(() {
      val = d;
    });
    setState(() {});
  }

  setVal2(double d) {
    RegStoreActions.addValue.call('Your rating ' + d.toString());
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: Container(
        color: Colors.grey.withOpacity(0.8),
        child: CupertinoSlider(
          onChanged: setValue,
          onChangeEnd: setVal2,
          value: this.val,
          min: 0.0,
          max: 10.0,
          divisions: 10,
          activeColor: Colors.black,
        ),
      ),
    );
  }
}

class MarketingFormItem with FormItem<bool> {
  @override
  String getTitle() {
    return 'Interested in Marketing';
  }

  @override
  void callAction() {
    // No need to implement
  }

  @override
  Widget getWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Interested In Marketing & Sponsorship',
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
                    this.setValue(true);
                    RegStoreActions.addValue('Interested');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'YES',
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
                    this.setValue(false);
                    RegStoreActions.addValue('Not interested');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'NO',
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
}

class SponsorshipFormItem with FormItem<bool> {
  @override
  String getTitle() {
    return 'Sponsorships';
  }

  @override
  void callAction() {}

  @override
  Widget getWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Experience bringing sponsors?',
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
                    this.setValue(true);
                    RegStoreActions.addValue('Yes, brought sponsors');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'YES',
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
                    this.setValue(false);
                    RegStoreActions.addValue('No experience with sponsors');
                  },
                  child: Container(
                    color: Colors.transparent,
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        'NO',
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
}

class ContribFormItem with FormItem<String> {
  ContribFormItem() {
    regex = RegExp(r'(.|\s)*\S(.|\s)*');
  }

  @override
  String getTitle() {
    return 'Contribution Statement';
  }

  @override
  Widget getWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'How would you contribute to Habba19',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        TextField(
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            hintText: 'Enter a paragraph',
          ),
          style: TextStyle(fontSize: 25.0, color: Colors.black87),
          textCapitalization: TextCapitalization.sentences,
          maxLines: 5,
          autofocus: true,
          onChanged: this.setValue,
          onSubmitted: validation(context),
        ),
      ],
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class OtherActsFormItem with FormItem<String> {
  OtherActsFormItem() {
    regex = RegExp(r'(.|\s)*\S(.|\s)*');
  }

  @override
  String getTitle() {
    return 'Other Activities';
  }

  @override
  Widget getWidget(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Other Activities You have Taken Part/Organized',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        TextField(
          textCapitalization: TextCapitalization.sentences,
          decoration: InputDecoration(
            contentPadding: EdgeInsets.all(12.0),
            hintText: 'Enter a paragraph',
          ),
          style: TextStyle(fontSize: 25.0, color: Colors.black87),
          maxLines: 5,
          autofocus: true,
          onChanged: this.setValue,
          onSubmitted: validation(context),
        ),
      ],
    );
  }

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}

class OtherSkillFormItem with FormItem<String> {
  OtherSkillFormItem() {
    regex = RegExp(r'(.|\s)*\S(.|\s)*');
  }

  @override
  String getTitle() {
    return 'Other Skills (If Any)';
  }

  @override
  Widget getWidget(BuildContext context) => TextField(
        textInputAction: TextInputAction.next,
        maxLines: 1,
        autofocus: true,
        onSubmitted: validation(context),
        textCapitalization: TextCapitalization.words,
        keyboardType: TextInputType.text,
        style: TextStyle(fontSize: 25.0, color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.all(12.0),
          hintText: 'Other Skills (None if nothing)',
        ),
        onChanged: this.setValue,
      );

  @override
  void callAction() {
    RegStoreActions.addValue.call(this.value);
  }
}
