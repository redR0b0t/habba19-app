import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'package:habba2019/utils/custom_painter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:flutter_flux/flutter_flux.dart';
import 'package:habba2019/stores/auth_store.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key}) : super(key: key);

  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin, StoreWatcherMixin<LoginScreen> {
  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);
  AuthStore store;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();
  final FocusNode myFocusNodeCollegeName = FocusNode();
  final FocusNode myFocusNodePhoneNumber = FocusNode();

  TextEditingController loginEmailController = new TextEditingController();
  TextEditingController loginPasswordController = new TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = new TextEditingController();
  TextEditingController signupPhoneNumberController =
      new TextEditingController();
  TextEditingController signupNameController = new TextEditingController();
  TextEditingController signupPasswordController = new TextEditingController();
  TextEditingController signupConfirmPasswordController =
      new TextEditingController();
  TextEditingController signupCollegeNameController = TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;

  bool studentOfAIT = false;
  String _collegeName = 'Acharya Institutes';
  String _aitStudent = 'Acharya Institutes';
  String _otherStudent = 'Other';

  bool isEmailEditingEnabled = true;

  bool isLoading = false;

  bool _nameValidate = false,
      _emailValidate = false,
      _collegeNameValidate = false,
      _phoneNumberValidate = false,
      _passwordMinValidate = false,
      _passwordMatchesValidate = false,
      _loginEmailValidate = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Image.asset(
              'assets/nopaw.png',
              fit: BoxFit.cover,
            )),
        new Scaffold(
          backgroundColor: Colors.transparent,
          key: _scaffoldKey,
          body: NotificationListener<OverscrollIndicatorNotification>(
            onNotification: (overscroll) {
              overscroll.disallowGlow();
            },
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                height: 1500,
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(top: 75.0),
                      child: new Image(
                        width: 90.0,
                        height: 90.0,
                        fit: BoxFit.fill,
                        image: new AssetImage(
                          'assets/onlypaw.png',
                        ),
                      ),
                    ),
                    Center(
                      child: FittedBox(
                          fit: BoxFit.scaleDown,
                          child: Column(
                            children: <Widget>[
                              _buildTitle('Acharya Habba'),
                              _buildTitle('2019')
                            ],
                          )),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20.0),
                      child: _buildMenuBar(context),
                    ),
                    Expanded(
                      flex: 2,
                      child: PageView(
                        controller: _pageController,
                        onPageChanged: (i) {
                          if (i == 0) {
                            setState(() {
                              right = Colors.white;
                              left = Colors.black;
                            });
                          } else if (i == 1) {
                            setState(() {
                              right = Colors.black;
                              left = Colors.white;
                            });
                          }
                        },
                        children: <Widget>[
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignIn(context),
                          ),
                          new ConstrainedBox(
                            constraints: const BoxConstraints.expand(),
                            child: _buildSignUp(context),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    store = listenToStore(authStoreToken);
    _pageController = PageController();
  }

  void showInSnackBar(String value) {
    FocusScope.of(context).requestFocus(new FocusNode());
    _scaffoldKey.currentState?.removeCurrentSnackBar();
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(
        value,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 16.0,
        ),
      ),
      backgroundColor: Colors.blue,
      duration: Duration(seconds: 3),
    ));
  }

  Widget _buildMenuBar(BuildContext context) {
    return Container(
      width: 300.0,
      height: 50.0,
      decoration: BoxDecoration(
        color: Color(0x552B2B2B),
        borderRadius: BorderRadius.all(Radius.circular(25.0)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: isLoading ? null : _onSignInButtonPress,
                child: Text(
                  "Login",
                  style: TextStyle(
                    color: left,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
            //Container(height: 33.0, width: 1.0, color: Colors.white),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  "Signup",
                  style: TextStyle(
                    color: right,
                    fontSize: 16.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSignIn(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.topCenter,
              overflow: Overflow.visible,
              children: <Widget>[
                Card(
                  elevation: 2.0,
                  color: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: Container(
                    width: 300.0,
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodeEmailLogin,
                            controller: loginEmailController,
                            keyboardType: TextInputType.emailAddress,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.envelope,
                                color: Colors.black,
                                size: 22.0,
                              ),
                              hintText: "Email Address",
                              errorText: _loginEmailValidate
                                  ? 'Enter a valid email address'
                                  : null,
                              hintStyle: TextStyle(fontSize: 17.0),
                            ),
                          ),
                        ),
                        Container(
                          width: 250.0,
                          height: 1.0,
                          color: Colors.grey[400],
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: 20.0, bottom: 20.0, left: 25.0, right: 25.0),
                          child: TextField(
                            focusNode: myFocusNodePasswordLogin,
                            controller: loginPasswordController,
                            obscureText: _obscureTextLogin,
                            style:
                                TextStyle(fontSize: 16.0, color: Colors.black),
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              icon: Icon(
                                FontAwesomeIcons.lock,
                                size: 22.0,
                                color: Colors.black,
                              ),
                              hintText: "Password",
                              hintStyle: TextStyle(fontSize: 17.0),
                              suffixIcon: GestureDetector(
                                onTap: _toggleLogin,
                                child: Icon(
                                  FontAwesomeIcons.eye,
                                  size: 15.0,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 170.0),
                  decoration: new BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5.0)),
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: Themex.CustomColors.iconInactiveColor,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                      BoxShadow(
                        color: Themex.CustomColors.iconInactiveColor,
                        offset: Offset(1.0, 6.0),
                        blurRadius: 20.0,
                      ),
                    ],
                    color: Themex.CustomColors.iconInactiveColor,
                  ),
                  child: MaterialButton(
                    color: Themex.CustomColors.iconInactiveColor,
                    highlightColor: Colors.transparent,
                    splashColor: Themex.CustomColors.iconActiveColor,
                    //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 42.0),
                      child: Text(
                        "Login",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 25.0,
                        ),
                      ),
                    ),
                    onPressed: _handleLogin,
                  ),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.white10,
                            Colors.white,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: new LinearGradient(
                          colors: [
                            Colors.white,
                            Colors.white10,
                          ],
                          begin: const FractionalOffset(0.0, 0.0),
                          end: const FractionalOffset(1.0, 1.0),
                          stops: [0.0, 1.0],
                          tileMode: TileMode.clamp),
                    ),
                    width: 100.0,
                    height: 1.0,
                  ),
                ],
              ),
            ),
            FlatButton(
              onPressed: () {
                AuthStoreActions.guestLogin.call(true);
              },
              child: _buildTitle('Explore without loggin in',  TextStyle(
                    fontSize: 17.0,
                    color: Colors.white,
                    decoration: TextDecoration.underline),),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                IconButton(
                  icon: Icon(
                    FontAwesomeIcons.instagram,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await launch('https://www.instagram.com/habba2019/');
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.snapchat, color: Colors.white),
                  onPressed: () async {
                    await launch('https://www.snapchat.com/add/acharya_habba');
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.facebook, color: Colors.white),
                  onPressed: () async {
                    await launch('https://www.facebook.com/acharya.ac.in/');
                  },
                ),
                IconButton(
                  icon: Icon(FontAwesomeIcons.twitter, color: Colors.white),
                  onPressed: () async {
                    await launch('https://twitter.com/acharyahabba');
                  },
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSignUp(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 23.0),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(bottom: 300.0),
          child: Column(
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                overflow: Overflow.visible,
                children: <Widget>[
                  Card(
                    elevation: 2.0,
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Container(
                      width: 300.0,
//                  height: 360.0,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextField(
                              focusNode: myFocusNodeName,
                              controller: signupNameController,
                              keyboardType: TextInputType.text,
                              textCapitalization: TextCapitalization.words,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.user,
                                  color: Colors.black,
                                ),
                                hintText: "Name",
                                hintStyle: TextStyle(fontSize: 16.0),
                                errorText: _nameValidate
                                    ? 'Name can\'t be empty'
                                    : null,
                              ),
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0, left: 25),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Student Of',
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            ),
                          ),
                          _buildCollegeRadios(context),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: _collegeName == _aitStudent
                                ? TextField(
                                    onTap: _onEmailPress,
                                    focusNode: myFocusNodeEmail,
                                    controller: signupEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    enabled: true,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      errorText: _emailValidate
                                          ? 'Invalid email!'
                                          : null,
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.black,
                                      ),
                                      hintText: "Acharya Email Address",
                                      hintStyle: TextStyle(fontSize: 16.0),
                                    ),
                                  )
                                : TextField(
                                    focusNode: myFocusNodeEmail,
                                    controller: signupEmailController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      errorText: _emailValidate
                                          ? 'Invalid email!'
                                          : null,
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.envelope,
                                        color: Colors.black,
                                      ),
                                      hintText: "Email Address",
                                      hintStyle: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: _collegeName == _aitStudent
                                ? Container(
                                    child: Text(
                                      'Your college will be determined based on your email',
                                      textAlign: TextAlign.center,
                                    ),
                                  )
                                : TextField(
                                    focusNode: myFocusNodeCollegeName,
                                    controller: signupCollegeNameController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: TextStyle(
                                        fontSize: 16.0, color: Colors.black),
                                    decoration: InputDecoration(
                                      errorText: _collegeNameValidate
                                          ? 'College name can\'t be empty!'
                                          : null,
                                      border: InputBorder.none,
                                      icon: Icon(
                                        FontAwesomeIcons.university,
                                        color: Colors.black,
                                      ),
                                      hintText: "College Name",
                                      hintStyle: TextStyle(fontSize: 16.0),
                                    ),
                                  ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextField(
                              focusNode: myFocusNodePhoneNumber,
                              controller: signupPhoneNumberController,
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              decoration: InputDecoration(
                                errorText: _phoneNumberValidate
                                    ? 'Invalid Phonenumber!'
                                    : null,
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.phone,
                                  color: Colors.black,
                                ),
                                hintText: "Phone Number",
                                hintStyle: TextStyle(fontSize: 16.0),
                              ),
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextField(
                              focusNode: myFocusNodePassword,
                              controller: signupPasswordController,
                              obscureText: _obscureTextSignup,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.lock,
                                  color: Colors.black,
                                ),
                                hintText: "Password",
                                errorText: _passwordMinValidate
                                    ? 'Enter atleast 5 characters!'
                                    : null,
                                hintStyle: TextStyle(fontSize: 16.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignup,
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            width: 250.0,
                            height: 1.0,
                            color: Colors.grey[400],
                          ),
                          Padding(
                            padding: EdgeInsets.only(
                                top: 20.0,
                                bottom: 20.0,
                                left: 25.0,
                                right: 25.0),
                            child: TextField(
                              controller: signupConfirmPasswordController,
                              obscureText: _obscureTextSignupConfirm,
                              style: TextStyle(
                                  fontSize: 16.0, color: Colors.black),
                              decoration: InputDecoration(
                                border: InputBorder.none,
                                icon: Icon(
                                  FontAwesomeIcons.lock,
                                  color: Colors.black,
                                ),
                                hintText: "Confirmation",
                                errorText: _passwordMatchesValidate
                                    ? 'Passwords do not match!'
                                    : null,
                                hintStyle: TextStyle(fontSize: 16.0),
                                suffixIcon: GestureDetector(
                                  onTap: _toggleSignupConfirm,
                                  child: Icon(
                                    FontAwesomeIcons.eye,
                                    size: 15.0,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -20,
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5.0)),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: Themex.CustomColors.iconInactiveColor,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                          BoxShadow(
                            color: Themex.CustomColors.iconInactiveColor,
                            offset: Offset(1.0, 6.0),
                            blurRadius: 20.0,
                          ),
                        ],
                        color: Themex.CustomColors.iconInactiveColor,
                      ),
                      child: MaterialButton(
                        highlightColor: Colors.transparent,
                        splashColor: Themex.CustomColors.iconInactiveColor,
                        //shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(5.0))),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 42.0),
                          child: Text(
                            "Sign Up",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25.0,
                            ),
                          ),
                        ),
                        onPressed: _handleSignup,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1,
        duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  Widget _buildCollegeRadios(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: Row(
        children: <Widget>[
          Radio(
            activeColor: Theme.of(context).primaryColor,
            value: _aitStudent,
            groupValue: _collegeName,
            onChanged: (String val) {
              setState(() {
                _collegeName = val;
                signupEmailController.clear();
              });
              signupCollegeNameController.value =
                  TextEditingValue(text: 'Prefilled Value');
            },
          ),
          Text('Acharya Institutes'),
          Radio(
            activeColor: Theme.of(context).primaryColor,
            value: _otherStudent,
            groupValue: _collegeName,
            onChanged: (String val) {
              setState(() {
                _collegeName = val;
                signupEmailController.clear();
              });
              signupCollegeNameController.clear();
            },
          ),
          Text('Other'),
        ],
      ),
    );
  }

  void _handleLogin() async {
    setState(() {
      _loginEmailValidate = false;
    });
    if (!RegExp(
            r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$')
        .hasMatch(loginEmailController.text)) {
      setState(() {
        _loginEmailValidate = true;
      });
    }
    if (_loginEmailValidate != true) {
      Completer<Map> loginCompleter = Completer<Map>();
      AuthStoreActions.login.call(UserLoginModel(
          email: loginEmailController.text,
          password: loginPasswordController.text,
          completer: loginCompleter));
      showInSnackBar('Loggin you in!');
      setState(() {
        isLoading = true;
      });
      Map res = await loginCompleter.future;
      setState(() {
        isLoading = false;
      });
      if (res['success']) {
        AuthStoreActions.changeAuth.call(true);
      } else {
        print(res);
        showInSnackBar(
            '[${res['error']['code']}]: ${res['error']['message']} ');
      }
    }
  }

  void _handleSignup() async {
    setState(() {
      _passwordMatchesValidate = false;
      _emailValidate = false;
      _passwordMinValidate = false;
      _nameValidate = false;
      _collegeNameValidate = false;
      _phoneNumberValidate = false;
    });
    Completer<Map> signupCompleter = Completer<Map>();
    String email = signupEmailController.text;
    String password = signupPasswordController.text;
    String confirmPassword = signupConfirmPasswordController.text;
    String name = signupNameController.text;
    String collegeName = signupCollegeNameController.text;
    String phoneNumber = signupPhoneNumberController.text;

    bool flag = false;

    if (name.trim() == '') {
      setState(() {
        _nameValidate = true;
      });
      flag = true;
    }
    if (!RegExp(
            r'^(([^<>()\[\]\.,;:\s@\"]+(\.[^<>()\[\]\.,;:\s@\"]+)*)|(\".+\"))@(([^<>()[\]\.,;:\s@\"]+\.)+[^<>()[\]\.,;:\s@\"]{2,})$')
        .hasMatch(email)) {
      setState(() {
        _emailValidate = true;
      });
      flag = true;
    }
    if (_collegeName != _aitStudent && collegeName.trim() == '') {
      setState(() {
        _collegeNameValidate = true;
      });
      flag = true;
    }
    if (phoneNumber.trim().length != 10) {
      setState(() {
        _phoneNumberValidate = true;
      });
    }
    if (password.trim().length < 5) {
      setState(() {
        _passwordMinValidate = true;
      });
      flag = true;
    }
    if (password != confirmPassword) {
      setState(() {
        _passwordMatchesValidate = true;
      });
      flag = true;
    }

    if (flag == false) {
      AuthStoreActions.signup.call(UserSignpModel(
          completer: signupCompleter,
          email: email,
          password: password,
          name: name,
          collegeName: _collegeName == _aitStudent ? 'ay_cert' : collegeName,
          phoneNumber: phoneNumber));
      showInSnackBar('Signing you up!');
      setState(() {
        isLoading = true;
      });
      Map res = await signupCompleter.future;
      setState(() {
        isLoading = false;
      });
      if (res['success']) {
        AuthStoreActions.changeAuth.call(true);
      } else {
        showInSnackBar('[${res['error']['code']}]: ${res['error']['message']}');
      }
    }
  }

  void _onEmailPress() async {
    try {
      await _googleSignIn.signOut();
      GoogleSignInAccount account = await _googleSignIn.signIn();
      if (!account.email.endsWith('acharya.ac.in')) {
        setState(() {
          _emailValidate = true;
        });
      } else {
        signupEmailController.text = account.email;
      }
    } catch (error) {
      print(error);
    }
  }

  Widget _buildTitle(String s, [TextStyle textStyle = const TextStyle(
              color: Colors.white,
              fontSize: 54,
              fontFamily: 'ProductSans',
              fontWeight: FontWeight.w100,
            )]) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          color: Themex.CustomColors.iconInactiveColor,
          child: GradientText(
            s,
            gradient: Gradients.haze,
            shaderRect: Rect.fromLTWH(100, 0, 100, 100),
            style: textStyle,
          ),
        ),
      ),
    );
  }
}
