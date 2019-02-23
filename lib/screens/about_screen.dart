import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:habba2019/utils/theme.dart' as Themex;

class AboutScreen extends StatefulWidget {
  @override
  _AboutScreenState createState() => _AboutScreenState();
}

class _AboutScreenState extends State<AboutScreen>
    with SingleTickerProviderStateMixin<AboutScreen> {
  TabController tabController;

  static const String aboutHabba =
      "Acharya Institutes has been a proud host of Habba since it's induction, in 2005. Every year is a celebration encapsulating the essence of talent borne by the entire campus. The 3-day mega event has achieved maximum success in all its realms by organising events like Battle of Bands, Fashion show, Acharya Premier League(APL), Acharya Football League(AFL) and music festival with an annual influx of 30,000 students. Habba'19 ensures to take you on yet another rollercoaster ride, let the thrill of the fest unfold in all its glory. ";

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
          padding:
              const EdgeInsets.only(left: 8.0, right: 8.0, top: 8.0, bottom: 90),
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
                  child: Text(aboutHabba, style: TextStyle(fontSize: 20),),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAboutDevs() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.4),
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
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            'Looks like we didn\'t get enough time to credit ourselves!\n(๑◕︵◕๑)ﾞ',
                            style: TextStyle(fontSize: 20.0),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
