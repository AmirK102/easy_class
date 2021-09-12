import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:easy_class/wigets/search_CR.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

import 'MessagesPage.dart';
import 'Schedules.dart';

class ClassScreen extends StatelessWidget {
  final className, classId;
  final color;
  final GoogleSignInAccount userInfo;

  const ClassScreen(
      {Key? key,
      @required this.className,
      this.color,
      this.classId,
      required this.userInfo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var studentData;
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    PersistentTabController _controller;

    _controller = PersistentTabController(initialIndex: 0);


    Future<bool> isStudentExist(id) async {
     return await  _firestore.collection('class').doc(classId).collection('students').doc(id).get().then((value) {
        return value.exists;
      });

    }


    List<Widget> _buildScreens() {
      return [
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: () async {
              studentData = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SelectCR((value) {
                        return value;
                      })));
              print(studentData);
              if(await isStudentExist(studentData.id)){
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text("${studentData.name} Already Added"),
                    ));
              }
              else{
                Database().uploadStudentInAClass(classId, studentData.id);
                Database().uploadClassIdToStudents(classId, studentData.id);
                showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      content: Text("${studentData.name} Added"),
                    ));
              }

            },
            icon: Icon(Icons.add),
            iconSize: 50,
          ),
          SizedBox(
            height: 10,
          ),
          Center(
              child: Text(
                "Add Student",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              )),
        ],
      ),

        MessagesPage(classId: classId, userInfo: userInfo),
        Schedules(classId: classId, userInfo: userInfo)
      ];
    }

    List<PersistentBottomNavBarItem> _navBarsItems() {
      return [
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.add_circled),
          title: ("Add Members"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.chat_bubble_text),
          title: ("Messages"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
        PersistentBottomNavBarItem(
          icon: Icon(CupertinoIcons.time),
          title: ("Schedules"),
          activeColorPrimary: CupertinoColors.activeBlue,
          inactiveColorPrimary: CupertinoColors.systemGrey,
        ),
      ];
    }


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(color),
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(className),
      ),
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Colors.white, // Default is Colors.white.
        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset: true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows: true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.circular(10.0),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties( // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 200),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation( // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle: NavBarStyle.style14, // Choose the nav bar style with this property.
      ));
  }
}

