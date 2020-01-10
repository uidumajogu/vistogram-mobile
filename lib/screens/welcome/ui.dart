import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:visitor_register/screens/auth/ui.dart';


class WelcomeScreen extends StatefulWidget {
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {

    goToSignInScreen() {
    Navigator.pushReplacementNamed(context, '/SignInScreen');
  }

@override
  void initState() {
    Timer(Duration(seconds: 2), goToSignInScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
            data: themeSet,
          child: Scaffold(
         body: Container(
           width: mediaWidth(context),
           height: mediaHeight(context),
          //  color: colorSecondary.withOpacity(0.3),
           child: Column(
             mainAxisAlignment: MainAxisAlignment.center,
             children: <Widget>[
              //  Align(
              //    alignment: Alignment.center,
              //    child: Padding(
              //      padding: const EdgeInsets.all(50.0),
              //      child: Image.asset('assets/images/logo.png', scale: 1.5,),
              //    )),
               Padding(
                 padding: const EdgeInsets.all(50.0),
                 child: Column(
                   children: <Widget>[
                     Text('WELCOME', 
                     style:TextStyle(
                       fontSize: 105.0,
                       color: colorPrimary
                     )),
                    Text('to $businessName ' + (businessBranch != '' ? '($businessBranch)': ''), 
                 style:TextStyle(
                   fontSize: 35.0,
                   color: colorSecondary
                 )),
                Padding(
                  padding: const EdgeInsets.all(80.0),
                  child: CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation<Color>(colorSecondary)),
                )
                   ],
                 ),
               ),
             ],
           ),
         ),
      ),
    );
  }
}