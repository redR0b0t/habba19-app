import 'package:flutter/material.dart';
import 'package:habba2019/stores/volunteer_store.dart';

mixin FormItem<Type> {
  Type value;
  RegExp regex;
  bool valid = false;

  void setValue(Type s) {
    if (Type == String && regex != null) {
      valid = regex.hasMatch(value.toString());
    }
    this.value = s;
  }

  Function validation(BuildContext context) {
    return (String val) {
      if (this.regex != null && Type == String) {
        if (regex.hasMatch(val)) {
          this.setValue(regex.stringMatch(val) as Type);
          this.callAction();
        } else
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text('Enter a valid ${this.getTitle()}')));
      } else {
        this.callAction();
      }
    };
  }

  void callAction();

  Widget getWidget(BuildContext context);

  String getTitle();

  Widget getValueWidget() {
    return null;
  }
}

Widget stdTextBox(String val) => FittedBox(
      fit: BoxFit.scaleDown,
      child: Text(
        val,
        style: TextStyle(fontSize: 45.0, fontFamily: 'ProductSans'),
      ),
    );

Widget stdTextInput(String hint, Function setValue, Function validation,
        {TextInputType textInputType = TextInputType.text}) =>
    TextField(
      autofocus: true,
      textInputAction: TextInputAction.next,
      maxLines: 1,
      onSubmitted: validation(),
      textCapitalization: TextCapitalization.words,
      keyboardType: textInputType,
      style: TextStyle(fontSize: 25.0, color: Colors.black87),
      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(12.0),
        hintText: hint,
      ),
      onChanged: setValue,
    );

Widget stdPrompt(String val, Function onTap) => GestureDetector(
  onTap: onTap,
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
                  '$val ➡️',
                  style: TextStyle(fontSize: 20.0),
                ),
              ),
            ),
          ),
        ],
      ),
    );
