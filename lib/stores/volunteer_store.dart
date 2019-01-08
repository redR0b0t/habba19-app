import 'package:flutter_flux/flutter_flux.dart';
import 'package:flutter/material.dart';
import 'package:habba2019/constants.dart';
import 'package:habba2019/widgets/form_item.dart';
import 'package:habba2019/widgets/volunteer_form.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:http/http.dart' as http;

class RegStoreActions {
  static Action getNextFormItem = Action();
  static Action<String> addValue = Action<String>();
  static Action<BuildContext> removeValue = Action<BuildContext>();
  static Action<String> selectExperience = Action<String>();
  static Action decreaseIter = Action();
  static Action<BuildContext> makeRequest = Action<BuildContext>();
}

class RegStore extends Store {
  int iter = 0;
  FormItem currentFormItem;
  String selectedExperience;
  List<FormItem> renderPipeline = [];
  List<String> valueList = [];
  DepartmentFormItem department;
  CollegeFormItem college;
  NameFormItem name;
  USNFormItem usn;
  EmailFormItem email;
  PhoneNumberFormItem phoneNumber;
  ExperienceFormItem experience;
  InterestedCategoryFormItem interestedCategory;
  CommSkillFormItem communicationSkill;
  SkillFormItem skill;
  YearFormItem year;
  ConvSkillFormItem convSkill;
  MarketingFormItem marketing;
  SponsorshipFormItem sponsors;
  ContribFormItem contrib;
  OtherActsFormItem otherActs;
  OtherSkillFormItem otherSkills;

  RegStore() {
    department = DepartmentFormItem();
    college = CollegeFormItem(department);
    name = NameFormItem();
    usn = USNFormItem();
    email = EmailFormItem();
    phoneNumber = PhoneNumberFormItem();
    year = YearFormItem();
    experience = ExperienceFormItem();
    interestedCategory = InterestedCategoryFormItem();
    communicationSkill = CommSkillFormItem();
    convSkill = ConvSkillFormItem();
    skill = SkillFormItem();
    marketing = MarketingFormItem();
    sponsors = SponsorshipFormItem();
    contrib = ContribFormItem();
    otherActs = OtherActsFormItem();
    otherSkills = OtherSkillFormItem();
    renderPipeline = [
      name,
      usn,
      email,
      phoneNumber,
      college,
      department,
      year,
      experience,
      contrib,
      otherActs,
      skill,
      otherSkills,
      communicationSkill,
      convSkill,
      marketing,
      sponsors,
      interestedCategory,
    ];
    currentFormItem = renderPipeline[iter];
    triggerOnAction(RegStoreActions.getNextFormItem, (_) {
      iter++;
      currentFormItem = renderPipeline[iter];
    });
    triggerOnAction(RegStoreActions.addValue, (String s) {
      valueList.add(s);
    });
    triggerOnAction(RegStoreActions.removeValue, (BuildContext context) {
      if (valueList.length == 0) {
        Navigator.pop(context);
      }
        valueList.removeLast();
    });
    triggerOnAction(RegStoreActions.selectExperience, (String ex) {
      this.selectedExperience = ex;
    });
    triggerOnAction(RegStoreActions.decreaseIter, (_) {
      print('\t\t calllled it $iter befor ');
      if (iter != 0) this.iter--;
      print('\t\t calllled it $iter aftr');
    });
    triggerOnAction(RegStoreActions.makeRequest, (BuildContext context) async {
      const URL = 'http://acharyahabba.in/habba18/vol_app.php';
      Flushbar loader = FlushbarHelper.createInformation(message: 'Loading. Please wait')..show(context);
      http.Response res = await http.post(URL, body: <String, String>{
        'name': name.value,
        'usn': usn.value,
        'email': email.value,
        'num': phoneNumber.value,
        'dept': department.value,
        'clg': college.value,
        'year': year.value,
        'exp': experience.value,
        'skill': skill.value,
        'comm': communicationSkill.value,
        'otherskill': otherSkills.value,
        'marketing': marketing.value.toString(),
        'contrib': contrib.value,
        'otheractivities': otherActs.value,
        'convincing': convSkill.value,
        'sponsors': sponsors.value.toString(),
        'interest': interestedCategory.value
      });
      loader.dismiss();
      FlushbarHelper.createSuccess(message: res.body).show(context);
    });
  }

  Widget nextWidget(BuildContext context) {
    int t_iter = iter;
    print('\t\t $t_iter');
    iter++;
    if (t_iter == 5 &&
        (this.selectedExperience == Experience.Zero ||
            this.selectedExperience == null)) {
      iter++;
      return renderPipeline[t_iter + 1].getWidget(context);
    }
    return renderPipeline[t_iter].getWidget(context);
  }
}

StoreToken regStoreToken = StoreToken(RegStore());
