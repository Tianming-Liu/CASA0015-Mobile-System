import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:geotracker/screens/tag_page.dart';
import 'package:geotracker/screens/history.dart';
import 'package:geotracker/widgets/tag_appbar.dart';
import 'package:geotracker/widgets/history_appbar.dart';
import 'package:geotracker/widgets/side_drawer.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geotracker/style/map_style.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  static final List<Widget> _bodyOptions = <Widget>[
    const TagPage(),
    const HistoryPage(),
  ];

  static final List<AppBar> _appBarOptions = <AppBar>[
    tagAppBar,
    historyAppBar,
  ];

  String mapStyle = MapStyle().silver;

  void changeMapStyle(String style) {
    switch (style) {
      case 'light-grey':
        setState(() {
          mapStyle = MapStyle().silver;
        });
        break;
      case 'light-green':
        setState(() {
          mapStyle = MapStyle().lightGreen;
        });
        break;
      case 'dark-blue':
        setState(() {
          mapStyle = MapStyle().darkDefault;
        });
        break;
    }
  }

  // Get User Information for future use

  User? user;
  NetworkImage? userProfileImage;
  String? userName;

  @override
  void initState() {
    super.initState();
    user = FirebaseAuth.instance.currentUser!;
    if (user != null) {
      FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          setState(() {
            final userProfileImageUrl =
                documentSnapshot.get('image_url').toString();
            userProfileImage = NetworkImage(userProfileImageUrl);
            userName = documentSnapshot.get('username').toString();
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBarOptions.elementAt(_selectedIndex),
      endDrawer: Drawer(
        width: 200,
        backgroundColor: Colors.white,
        child: SideDrawer(
            userName: userName,
            userProfileImage: userProfileImage,
            onChangeStyle: changeMapStyle),
      ),
      body: Center(
        child: _bodyOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
        ]),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
            child: GNav(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                gap: 8,
                activeColor: Colors.white,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 40, vertical: 5),
                duration: const Duration(milliseconds: 500),
                tabBackgroundColor: const Color.fromARGB(255, 109, 109, 109),
                tabs: const [
                  GButton(
                    icon: LineIcons.mapPin,
                    text: 'Track',
                    iconSize: 25,
                  ),
                  GButton(
                    icon: LineIcons.heart,
                    text: 'Records',
                    iconSize: 18,
                  ),
                ],
                selectedIndex: _selectedIndex,
                onTabChange: (index) {
                  setState(() {
                    _selectedIndex = index;
                  });
                }),
          ),
        ),
      ),
    );
  }
}
