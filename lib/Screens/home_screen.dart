import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_class/Screens/splash_screen.dart';
import 'package:easy_class/functions/database_function.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:google_sign_in/google_sign_in.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    Key? key,
    required this.userInfo,
  }) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
  final GoogleSignInAccount userInfo;
}

class _HomeScreenState extends State<HomeScreen> {
  //variable
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  var userData;
  String photoUrl = "";

  //functions

  void signOutGoogle() async {
    await _googleSignIn.signOut();

    print("User Sign Out");
  }

  @override
  initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  getData() async {
    userData = await Database().getUserData(widget.userInfo.id);
    print("............................${userData['photo']}");
    setState(() {
      photoUrl = userData['photo'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Padding(
            padding: const EdgeInsets.all(48.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Text(
                    'Welcome ${widget.userInfo.displayName!}',
                    style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black54),
                  ),
                ),
                SizedBox(height: 40),
                CachedNetworkImage(
                  imageUrl: photoUrl,
                  placeholder: (context, url) => CircularProgressIndicator(),
                  errorWidget: (context, url, error) => Icon(Icons.error),
                ),
                SizedBox(height: 40),
                RaisedButton(
                  onPressed: () {
                    signOutGoogle();
                    Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) {
                      return SplasScreen();
                    }), ModalRoute.withName('/'));
                  },
                  color: Colors.black,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      'Sign Out',
                      style: TextStyle(fontSize: 25, color: Colors.white),
                    ),
                  ),
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40)),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
