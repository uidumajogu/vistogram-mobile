import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visitor_register/screens/auth/functions.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:visitor_register/main.dart';
import 'package:url_launcher/url_launcher.dart';

FirebaseAuth auth;
String currentUserID;
Firestore db;
Map licenceData;
Map inputParams = {};
Map fields = {};
List visitorBioForm = [];
List visitorAddressForm = [];
List visitorHostForm = [];
List purposeOfVisitOptions = [];
List multiOfficesOptions = [];
List visitorTagForm = [];
List<NetworkImage> adverts = [];
NetworkImage homeBackgroundImage;
NetworkImage logo;
Color colorPrimary;
Color colorSecondary;
var accid;
var setupName;
ThemeData themeSet;
String businessName = '';
String businessBranch = '';
String authorizationCode = '';
bool peep = false;



Future<String> deleteCurrentUser() async {
    String response;
    await FirebaseAuth.instance.currentUser().then((user){
      db.collection('anonymousUsers').document(user.uid).delete().then((data){
        user.delete().then((user){
          response = 'user deleted';
        }).catchError((error){
          response = 'no such user';
        });
      }).catchError((error){
          response = 'no such document';
        });
    }).catchError((error){
          response = 'no such user';
      });

    return response;
  }



class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  resetAuthCodes(d, e, s) {
    Timer(Duration(seconds: 0),
    (){
  if(d){
      db.collection('licenceCodes').document(authCode.join('-'))
          .updateData({ 
            'AID' : '',
            'rAID' : false,
            'status' : 'Inactive',
            'deviceDataPlatform' :'No Device', 
                  'deviceData' : 'No Device',
                  'lastUsedDate': DateFormat('yyyy-MM-dd HH:MM:SS').format(DateTime.now()),
            }).then((data){
                  deleteCurrentUser().then((response){
                      this.setState((){
                        authError = e;
                        authErrorString = s;
                        authText = 'Enter Your Authorization Code';
                        authCodeComplete = false;
                        noAuthCode = true;
                        loading = false;
                        authProcess = '';
                        loadingText = '';
                  });
                  }).catchError((error){
                      this.setState((){
                        authError = e;
                        authErrorString = s;
                        authText = 'Enter Your Authorization Code';
                        authCodeComplete = false;
                        noAuthCode = true;
                        loading = false;
                        authProcess = '';
                        loadingText = '';
                      });
                    });
                  }).catchError((error){
                      this.setState((){
                        authError = e;
                        authErrorString = s;
                        authText = 'Enter Your Authorization Code';
                        authCodeComplete = false;
                        noAuthCode = true;
                        loading = false;
                        authProcess = '';
                        loadingText = '';
                      });
                  });

  } else {
      this.setState((){
        authError = e;
        authErrorString = s;
        authText = 'Enter Your Authorization Code';
        authCodeComplete = false;
        noAuthCode = true;
        loading = false;
        loadingText = '';
        authProcess = '';
      });
  }}
  );
}


getSettingsParams(id, s, q, au) {
            setState(() {
              authProcess = 'Getting Settings ...';
              loadingText = 'Getting Settings ...';
            });
      try {
        db.collection('settings-' + id)
        .document(s) 
        .get()
        .then((doc) {
          if(doc.exists){
            fields = doc.data['fields'];
            inputParams = fields['inputParams'];

            visitorBioForm = fields['bioForm'];
            remapFlutterMaterialForm(visitorBioForm);

            visitorAddressForm = fields['addressForm'];
            remapFlutterMaterialForm(visitorAddressForm);

            visitorHostForm = fields['hostForm'];
            remapFlutterMaterialForm(visitorHostForm);

            visitorTagForm = fields['tagForm'];
            remapFlutterMaterialForm(visitorTagForm);

            purposeOfVisitOptions = doc.data['purposeOfVisitOptions'];

            List nmoo = doc.data['businessMultiOffices'];
            nmoo..sort();
            for (var i = 0; i < nmoo.length; i++) {
              multiOfficesOptions.add({'active': true, 'office': nmoo[i]});
            }

            List advertUrls = doc.data['advertsDownloadUrl'];
            remapFlutterMaterialImage(advertUrls);

            homeBackgroundImage = NetworkImage(doc.data['backgroundImageDownloadUrl']);

            logo = NetworkImage(doc.data['logoImageDownloadUrl']);

            colorPrimary = HexColor(doc.data['primaryColor']);
            colorSecondary = HexColor(doc.data['secondaryColor']);

            themeSet = ThemeData(
                          fontFamily: 'Comfortaa',
                          primaryColor: colorPrimary,
                          accentColor: colorSecondary
                        );
            
            businessName = doc.data['businessName'];
            businessBranch = doc.data['businessBranch'];

            if (q == 'yes') {
              db.collection('licenceCodes').document(authorizationCode)
                .updateData({ 
                  'AID' : au.uid,
                  'rAID' : false,
                  'status' : 'Active',
                  'deviceDataPlatform' :myDevicePlatform, 
                  'deviceData' :myDeviceData,
                  'lastUsedDate': DateFormat('yyyy-MM-dd HH:MM:SS').format(DateTime.now()),
                  }).then((data){
                setState(() {
                  authProcess = 'Almost Done ...';
                  loadingText = 'Almost Done ...';
                });
                db.collection('licenceCodes')
                .document(authorizationCode)
                .get().then((doc) {
                if(doc.exists){
                  licenceData = doc.data;
                db.collection('anonymousUsers').document(au.uid).setData({
                'businessName': doc.data['businessName'],
                'businessBranch': doc.data['businessBranch'],
                'ID':licenceData['ID'],
                'authCodeSetting':licenceData['setup'],
                'AID': au.uid,
                'authCode': authorizationCode,
                'authData':licenceData,
                'createdDate': DateFormat('yyyy-MM-dd HH:MM:SS').format(DateTime.now()),
                'lastLoginDate': DateFormat('yyyy-MM-dd HH:MM:SS').format(DateTime.now()),
              }).then((data){
                          authError = false;
                          authErrorString = '';
                          authText = 'Enter Your Authorization Code';
                          authCodeComplete = false;
                          noAuthCode = true;
                          loading = false;
                          loadingText = '';
                          authProcess = '';
                          Navigator.pushReplacementNamed(context, '/HomeScreen');
                  }).catchError((error){
                      resetAuthCodes(true, true, error);
                  });
                } else {
                  resetAuthCodes(false, true, '* This Authorization Code does not exist');
                }
          }).catchError((error){
              resetAuthCodes(false, true, error);
          });

              }).catchError((error){
                      resetAuthCodes(true, true, error);
                  });
            }

          } else {
            resetAuthCodes(true, true, '* No settings have been configured for this Authorization Code. Please contact your administrator');
          }
    }).catchError((error){
        resetAuthCodes(true, true, error);
    });
    } catch (e) {
      resetAuthCodes(false, true, e);
    }
}



getPeepSettingsParams() {
            setState(() {
              authProcess = 'Getting Default Settings ...';
              loadingText = 'Getting Default Settings ...';
              noAuthCode = false;
              authText = 'Authorization Code';
              authCodeComplete = true;
            });

            fields = dPeepSetting['fields'];
            inputParams = fields['inputParams'];

            visitorBioForm = fields['bioForm'];
            remapFlutterMaterialForm(visitorBioForm);

            visitorAddressForm = fields['addressForm'];
            remapFlutterMaterialForm(visitorAddressForm);

            visitorHostForm = fields['hostForm'];
            remapFlutterMaterialForm(visitorHostForm);

            visitorTagForm = fields['tagForm'];
            remapFlutterMaterialForm(visitorTagForm);

            purposeOfVisitOptions = dPeepSetting['purposeOfVisitOptions'];

            List nmoo = dPeepSetting['businessMultiOffices'];
            nmoo.sort();
            for (var i = 0; i < nmoo.length; i++) {
              multiOfficesOptions.add({'active': true, 'office': nmoo[i]});
            }

            List advertUrls = dPeepSetting['advertsDownloadUrl'];
            remapFlutterMaterialImage(advertUrls);

            homeBackgroundImage = NetworkImage(dPeepSetting['backgroundImageDownloadUrl']);

            logo = NetworkImage(dPeepSetting['logoImageDownloadUrl']);

            colorPrimary = HexColor(dPeepSetting['primaryColor']);
            colorSecondary = HexColor(dPeepSetting['secondaryColor']);

            themeSet = ThemeData(
                          fontFamily: 'Comfortaa',
                          primaryColor: colorPrimary,
                          accentColor: colorSecondary
                        );
            
            businessName = dPeepSetting['businessName'];
            businessBranch = dPeepSetting['businessBranch'];

            setState(() {
              authProcess = '';
              loadingText = '';
              noAuthCode = true;
              authText = 'Authorization Code';
              authCodeComplete = false;
              loading = false;
              authError = false;
            });
            Navigator.pushReplacementNamed(context, '/HomeScreen');
}


  @override
  void initState() {
    super.initState();
          peep = false;
          auth = FirebaseAuth.instance;
          db = Firestore.instance;
          value = '';
          authText = 'Enter Your Authorization Code';
          authCodeComplete = false;
          noAuthCode = true;
          authError = false;
          authErrorString = '';
          focusNodes = new List();
          authFieldCount = 6;
          authCode = [];
          getAuthFieldParameters();
          loading = true;
          loadingText = 'Loading ...';
    FirebaseAuth.instance.currentUser().then((userId) {
        if(userId != null) {
          currentUserID = userId.uid;
          db.collection('anonymousUsers')
            .document(userId.uid) 
            .get()
            .then((doc) {
              setState(() {
                loadingText = 'Initializing ...';
              });
                if(doc.exists){
                  licenceData = doc.data['authData'];
                  authorizationCode = doc.data['authCode'];
                  getSettingsParams(doc.data['ID'], doc.data['authCodeSetting'], 'yes', userId);
                } else {
                  resetAuthCodes(false, true, '');
                }
          }).catchError((error){
              resetAuthCodes(false, true, error);
          });

        } else {
          resetAuthCodes(false, true, '');
        }
  }).catchError((error){
          resetAuthCodes(false, true, error);
    });
  }

  

  @override
  Widget build(BuildContext context) {

  void submitAuthCode() async {
  noAuthCode = false;
  authText = 'Authorization Code';
  authCodeComplete = true;


  Future<FirebaseUser> anonymousUser;

  checkNetworkConnectivity().then((intenet) {
      if (intenet != null && intenet) {
    try{
          db.collection('licenceCodes')
              .document(authCode.join('-')) 
              .get()
              .then((doc) {
                if(doc.exists){
                  try {
                      anonymousUser = auth.signInAnonymously();
                    } catch (e) {
                      resetAuthCodes(false, true, e);
                    } finally {
                      anonymousUser.then((user) {
                  licenceData = doc.data;
                  authorizationCode = authCode.join('-');
                  if(doc.data['status'] == 'Inactive') {
                    getSettingsParams(doc.data['ID'], doc.data['setup'], 'yes', user);
                  } else {
                    if (doc.data['status'] == 'Expired') {
                      resetAuthCodes(true, true, '* This Authorization Code has expired');
                    }

                    if (doc.data['status'] == 'Active' && myDeviceData['id'] == doc.data['deviceData']['id']) {
                            db.collection('licenceCodes').document(authorizationCode)
                              .updateData({ 
                                'rAID' : user.uid == licenceData['AID'] ? false : true,
                                }).then((data){
                                  getSettingsParams(doc.data['ID'], doc.data['setup'], 'yes', user);
                                }).catchError((error){
                                      resetAuthCodes(true, true, error);
                                  });
                    } else {
                      if (doc.data['status'] == 'Active') {
                        resetAuthCodes(true, true, '* This Authorization Code is active on another device');
                      }
                    }
                  }
                  })
                    .catchError((error){
                        resetAuthCodes(true, true, error);
                    });
                  }
                } else {
                  resetAuthCodes(false, true, '* This Authorization Code does not exist');
                }
          }).catchError((error){
              resetAuthCodes(false, true, error);
          });
    } on PlatformException catch (e) {
      resetAuthCodes(false, true, e);
    }
  } else {
      resetAuthCodes(false, true, '* No internet connection, please check and try again');
  }
    });
  
  }


    Widget _getAuthCodeFields() {
      List<Widget> _fields = new List<Widget>();
      for(var i = 0; i < authFieldCount; i++){
      _fields.add(
            Flexible(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                          inputFormatters:[LengthLimitingTextInputFormatter(4),],
                        enabled: !authCodeComplete,
                        focusNode: focusNodes[i],
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        textAlign: TextAlign.center,
                        autocorrect: false,
                        decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10.0),
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15.0),
                          borderSide: BorderSide(color: sColor)
                      ),
                        ),
                        onTap: () {
                    checkAuthCodeInputs(i, context);
                    },
                        onChanged: (text) {
                    this.setState((){
                        authError = false;
                    });
                    
                    value = text.toUpperCase();
                    addAuthCodeInput(i, value);
                    if(value.length == 4) {
                      if(i==authFieldCount-1){
                        authCodeComplete = true;
                        peep = false;
                        submitAuthCode();
                      } else {
                        nextFocus(focusNodes[i+1], context);
                      }                          
                    }

                    if(value.length == 0) {
                      if(i==0){
                        focusNodes[0].unfocus();
                      } else {
                        nextFocus(focusNodes[i-1], context);
                      }                        
                    }
                        },
                      ),
                  ),
            )
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: _fields,
    );
  }

  _launchURL(url) async {
      if (await canLaunch(url)) {
        await launch(url);
      } else {
        throw 'Could not open $url';
      }
    }



    return loading ? 

      Material(
        child: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.1, 1],
            colors: [
              Color(0xFFFFFFFF),
              Color(0xFFFFFFFF),

            ],
          ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset('assets/images/Vistogram_Logo.png', scale: 16.0,),
          
          CircularProgressIndicator(
              strokeWidth: 4.0,
              valueColor: AlwaysStoppedAnimation<Color>(mColor)),
          
          Text(loadingText),
        ],
      ),
    ),
      )

      : Scaffold(
      resizeToAvoidBottomInset: false,
      body:  Container(
          padding: EdgeInsets.symmetric(horizontal: mediaWidth(context)*0.1),
          alignment: Alignment.center,
          child: Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Column(
              children: <Widget>[
      Padding(
        padding: EdgeInsets.only(top:mediaHeight(context)*0.12, bottom: mediaHeight(context)*0.06),
        child: Image.asset('assets/images/Vistogram_NameLogo.png', scale: 20.0,),
      ),
      peep ? Padding(padding: EdgeInsets.all(0.0),) 
      :
      Column(
        children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Text(authText, 
              style: TextStyle(
                color: tColor,
                fontSize: 20.0
                ),),
            ),
            _getAuthCodeFields(),
            authError ? Text(authErrorString,
                    style: TextStyle(
                      color: Colors.red
                    ), ) : Padding(padding: EdgeInsets.all(0.0)),
            
            authCode.join() != '' && authCode.join().length != authFieldCount * 4 ? Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text('By entering your authorization code, you agree our ', 
                  style: TextStyle(
                      fontSize: 14.0, 
                      color: tColor),),

                  Padding(
                    padding: const EdgeInsets.only(top: 3.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        InkWell(
                          child: Text('Terms and Conditions', 
                            style: TextStyle(
                              color: mColor,
                              fontSize: 16.0),),
                          onTap: ()=>_launchURL('http://vistogram.com/terms-and-conditions'),
                          ),
                        Text(' and ', 
                        style: TextStyle(
                            fontSize: 14.0, 
                            color: tColor),),
                        InkWell(
                          child: Text('Privacy Policy', 
                            style: TextStyle(
                              color: mColor,
                              fontSize: 16.0),),
                          onTap: ()=>_launchURL('http://vistogram.com/privacy-policy'),
                          ),

                      ],
                    ),
                  ),
                ],
              ) ,
            ):Padding(padding: EdgeInsets.all(0.0),),

            authCode.join() == '' ? Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('No Authorization Code? Contact your admin or ',
                  style: TextStyle(
                      fontSize: 14.0, 
                      color: tColor),),
                  InkWell(
                    child: Text('Register', 
                      style: TextStyle(
                        color: mColor,
                        fontSize: 16.0),),
                    onTap: ()=>_launchURL('http://vistogram.com/authentication'),
                    )
                ],
              ) ,
            ):Padding(padding: EdgeInsets.all(0.0),)

        ],),
              ],
            ),
          ),
        ),

      bottomSheet: Container(
          height: 200.0,
          padding: EdgeInsets.all(20.0),
          child: noAuthCode ? InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
      Text('See Demo', 
      style: TextStyle(
        color: tColor,
        fontSize: 25.0),),
        Icon(Icons.chevron_right, 
        size: 40.0, 
        color: tColor,)
            ],
          ),
          onTap: (){
            setState(() {
              peep = true;
            });
            getPeepSettingsParams();
          },
        ) :
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: authCodeComplete ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(authProcess, 
                style: TextStyle(
                  color: tColor,
                  fontSize: 22.0,
                ),),
              ),
              CircularProgressIndicator(
                  strokeWidth: 4.0,
                  valueColor: AlwaysStoppedAnimation<Color>(mColor))
            ],) :Padding(padding: EdgeInsets.all(0.0),),
        ),
      )

    );
  }
}
