import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:visitor_register/screens/auth/ui.dart';
import 'package:visitor_register/screens/signout/ui.dart';


class GoodByeScreen extends StatefulWidget {
  _GoodByeScreenState createState() => _GoodByeScreenState();
}

class _GoodByeScreenState extends State<GoodByeScreen> {

    goToHomeScreen() {
    Navigator.pushReplacementNamed(context, '/HomeScreen');
  }

@override
  void initState() {
    Timer(Duration(seconds: 4), goToHomeScreen);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                   Text('GOODBYE ', 
                   style:TextStyle(
                     fontSize: 105.0,
                     color: colorPrimary
                   )),
                   peep ? Padding(padding: EdgeInsets.all(0.0),)
                   :Padding(
                     padding: const EdgeInsets.all(8.0),
                     child: Text(signOutData['name'],                   style:TextStyle(
                       fontSize: 35.0,
                       color: colorPrimary
                     )),
                   ),
                  Text(' & thank you for visiting', 
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
    );
  }
}