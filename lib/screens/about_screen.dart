import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:gradient_widgets/gradient_widgets.dart';
import 'package:habba2019/utils/theme.dart' as Themex;
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin<AboutScreen> {
  TabController tabController;

  static const String aboutHabba =
      "Acharya Habba is the biggest techno-cultural fest in the city. This student run month long " +
          "extravaganza begins with a bam and attracts a crowd of over 25000 from across the state. Over " +
          "60 plus events under various categories brings the faculty and students together engaging " +
          "them in celebratory interactions on the campus.\n\n" +
          "The Jamboree reaches the scales of world class with the involvement of renowned National and " +
          "International artists taking the stage; this is additionally a launch pad for budding talents " +
          "to showcase.\n\nEvents like Acharya Premier League, Pro-Kabaddi, Acharya Football League, Music " +
          "Festival, Ethnic day are a few prominent ones students look forward to participating.\n\n \"Simba\", " +
          "the mascot of Habba grabs the limelight of all the events.\n\n" +
          "This year Habba up-scales to 3 digit figures in number of events adding colour to the already " +
          "magnificent.";

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          color: Colors.white,
        ),
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Image.asset(
            'assets/kaala.png',
            fit: BoxFit.cover,
          ),
        ),
        _buildActual(context)
      ],
    );
  }

  Widget _buildActual(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        title: Text('Acharya Habba'),
        bottom: TabBar(
          isScrollable: true,
          controller: tabController,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: new BubbleTabIndicator(
            indicatorHeight: 30.0,
            indicatorColor: Themex.CustomColors.iconActiveColor,
            tabBarIndicatorSize: TabBarIndicatorSize.tab,
          ),
          tabs: <Widget>[
            Tab(text: 'About Us'),
            Tab(
              text: 'Your Devs',
            ),
          ],
        ),
      ),
      body: TabBarView(
        children: [_buildAboutHabba(), _buildAboutDevs()],
        controller: tabController,
      ),
    );
  }

  Widget _buildAboutHabba() {
    return SingleChildScrollView(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.only(
              left: 8.0, right: 8.0, top: 8.0, bottom: 90),
          child: Container(
            decoration: BoxDecoration(
//          color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Acharya Habba 2019', style: TextStyle(fontSize: 40), textAlign: TextAlign.center,),
                      ),
                      Divider(),
                      Text(
                        aboutHabba,
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutDevs() {
    return GridView.count(
      crossAxisCount: 2,
      children: <Widget>[
        _buildAvatar(ashwin),
        _buildAvatar(nikhil),
        _buildAvatar(bharath),
        _buildAvatar(shubham),
        _buildAvatar(rajan),
        _buildAvatar(varshini),
      ],
    );
  }

  Widget _buildAvatar(Developer dev) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Stack(
        children: <Widget>[
          Container(
            height: 300,
            width: 300,
            decoration: BoxDecoration(
//          color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 10.0, // has the effect of softening the shadow
                  spreadRadius: 0.0, // has the effect of extending the shadow
                  offset: Offset(
                    0.0, // horizontal, move right 10
                    5.0, // vertical, move down 10
                  ),
                )
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: Image.asset(
                dev.image,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: _buildTitle(dev.name),
                  ),
                ],
              ),
            ],
          ),
          Column(
            children: <Widget>[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return SimpleDialog(
                            title: Text(
                              dev.name,
                              textAlign: TextAlign.center,
                            ),
                            children: <Widget>[
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0),
                                  child: Text(
                                    dev.role,
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    IconButton(
                                      icon: Icon(Icons.email),
                                      onPressed: () async {
                                        String url = "mailto:${dev.email}";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text('Cannot open mail'),
                                            ),
                                          );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(FontAwesomeIcons.whatsapp),
                                      onPressed: () async {
                                        String phoneNumber =
                                            '91' + dev.phoneNumber;
                                        String url =
                                            "https://api.whatsapp.com/send?phone=$phoneNumber&text=Hey_dev";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else
                                          Scaffold.of(context).showSnackBar(
                                            SnackBar(
                                              content:
                                                  Text('Cannot open whatsapp'),
                                            ),
                                          );
                                      },
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.phone),
                                      onPressed: () async {
                                        String phoneNumber =
                                            '91' + dev.phoneNumber;
                                        String url = "tel:$phoneNumber";
                                        if (await canLaunch(url)) {
                                          await launch(url);
                                        } else
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      'Cannot open dialer')));
                                      },
                                    ),
                                  ],
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: 'Technologies: ',
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                      text: dev.technologies,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 12),
                                    )
                                  ]),
                                ),
                              ),
                              Divider(),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: RichText(
                                  text: TextSpan(children: <TextSpan>[
                                    TextSpan(
                                        text: 'Insights: ',
                                        style: TextStyle(color: Colors.black)),
                                    TextSpan(
                                      text: dev.about,
                                      style: TextStyle(
                                          color: Colors.black54, fontSize: 12),
                                    )
                                  ]),
                                ),
                              )
                            ],
                          );
                        });
                  },
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget _buildTitle(String s,
      [TextStyle textStyle = const TextStyle(
        color: Colors.white,
        fontSize: 16,
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

class Developer {
  String name, phoneNumber, email, image, about, technologies, role;

  Developer(
      {this.name,
      this.phoneNumber,
      this.email,
      this.image,
      this.about,
      this.technologies,
      this.role});
}

Developer ashwin = Developer(
    name: 'Ashwin Prasad A',
    phoneNumber: '9663574422',
    role: 'App developer, Backend engineer, DevOps',
    email: 'ashwinxprasad@gmail.com',
    image: 'assets/ashwin.jpeg',
    about: 'Hit or Miss. I guess they never miss huh (ISE Yikes!)',
    technologies: 'Flutter, React, NodeJS, ExpressJS, MySQL, MongoDB');
Developer nikhil = Developer(
    name: 'Nikhil.N.Prem',
    role: 'Backend engineer',
    phoneNumber: '9495571026',
    email: 'nikhilprem@rocketmail.com',
    image: 'assets/nikhil.jpeg',
    about: 'Aww that\'s hot. That\'s hot (ISE Yikes!)',
    technologies: 'React, NodeJS, ExpressJS, MySQL, MongoDB, Python');
Developer bharath = Developer(
    name: 'Bharath Karanth',
    role: 'Backend engineer',
    phoneNumber: '9481301702',
    email: 'bharathkaranth07@gmail.com',
    image: 'assets/bharath.jpeg',
    about: 'Programming is thinking. Not memorizing. (ISE Yikes)',
    technologies: 'Nodejs, PHP, Web dev, MongoDB ,ExpressJS, MySQL, React');
Developer shubham = Developer(
    name: 'Shubham Kumar Singh',
    phoneNumber: '7209369082',
    role: 'Web developer, Backend engineer',
    email: 'shubham.beis.16@acharya.ac.in',
    image: 'assets/shubham.jpeg',
    about: 'Spending less and Investing More.',
    technologies: 'Design, React, NodeJS, PHP, Illustrator, Photoshop');
Developer varshini = Developer(
    name: 'Varshini R',
    role: 'Web developer',
    phoneNumber: '8317328816',
    email: 'varshini.beis.16@acharya.ac.in',
    image: 'assets/varshini.jpeg',
    about: 'Any pizza is a personal pizza if you believe in yourself',
    technologies: 'Web dev, Python.');
Developer rajan = Developer(
    name: 'Rajan Raj Das',
    role: 'Web developer',
    phoneNumber: '6361500245',
    email: 'dasrajanraj@gmail.com',
    image: 'assets/rajan.jpeg',
    about: 'It always seems impossible until it’s done.',
    technologies: 'Web Development, Windows Application Development');
