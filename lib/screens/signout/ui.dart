import 'dart:async';

import 'package:flutter/material.dart';
import 'package:signature_pad/signature_pad.dart';
import 'package:signature_pad_flutter/signature_pad_flutter.dart';
import 'package:visitor_register/screens/signout/functions.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:visitor_register/screens/auth/ui.dart';
import 'package:intl/intl.dart';

var signOutData;

class SignOutScreen extends StatefulWidget {
  _SignOutScreenState createState() => _SignOutScreenState();
}

class _SignOutScreenState extends State<SignOutScreen> {

  getSignaturePNG() async{
    soSignatureResult = await soPadController.toPng();
    Navigator.pushReplacementNamed(context, '/GoodByeScreen');
  }

  @override
  void initState() {
    super.initState();
    signOutData = null;
    soVisitorTagForm = [];
    signOutRemark = 'Sign Here';
    signOutRemarkColor = Colors.blueGrey.withOpacity(0.6);
    signout = false;
    soTagEntered = false;
    submitTag = false;
    getForms();
    getTagParameter();
    getSignatureParameter();
    soPadController = new SignaturePadController();
    
  }

  @override
  void dispose() {
    super.dispose();
    refreshSignOutVariables();
  }

  @override
  Widget build(BuildContext context) {

      signOutVisitor(doc) async {
        soSignatureResult = await soPadController.toPng();  

         Timer(Duration(seconds: 3), (){
          String soSignatureDownloadURL = '';

          uploadToStore('data', licenceData['ID'], 'visitor-'+doc['docID'], 'signOutSignature', soSignatureResult, signatureEnabled).then((sourl){
            soSignatureDownloadURL = sourl;
            db.collection('visitors-'+ licenceData['ID']).document(doc['docID'])
            .updateData({ 
              'signedOut' : true,
              'soSignatureURL': soSignatureDownloadURL,
              'signedOutDate' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'signedOutTime' : DateFormat('HHmmss').format(DateTime.now()), 
              }).then((data){
                  db.collection('signedInTags-'+ licenceData['ID']).document(authorizationCode + '-' + visitorDetails['Tag Number'])
                  .delete().then((data){
                        Navigator.pushReplacementNamed(context, '/GoodByeScreen');
                    });
              });
          });
         });


       }

    invalidTagError() {
      compileError(soVisitorTagForm);
        setState(() {
          soVisitorTagForm[0]['errorMessage'] = 'The Tag number is incorrect';
          signingOut = false;
       });
    }

    checkTagNumber() {
      submitTag = true;
        db.collection('signedInTags-'+ licenceData['ID'])
        .document(authorizationCode + '-' + visitorDetails['Tag Number']) 
        .get()
        .then((doc) {
          if(doc.exists){
            setState(() {
            signout = true;
            signOutData = doc.data;
            submitTag = false;
            });
          } else {
            signout = false;
            invalidTagError();
            submitTag = false;
          }
    }).catchError((error){
        signout = false;
        invalidTagError();
        submitTag = false;
    });
    }


Widget _getTagFormFields(c) {
  List<Widget> fields = new List<Widget>();

  for(var i = 0; i < soVisitorTagForm.length; i++){
    if (soVisitorTagForm[i]['active']) {
      fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              focusNode: signOutTagFocusNode,
              controller: initialValue(visitorDetails[soVisitorTagForm[i]['field']]),
              maxLines: soVisitorTagForm[i]['maxLines'],
              keyboardType: soVisitorTagForm[i]['keyboardType'],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                labelText: soVisitorTagForm[i]['field'],
                hintText: soVisitorTagForm[i]['hintText'],
                suffixIcon: Icon(soVisitorTagForm[i]['suffixIcon']),
                errorText: soVisitorTagForm[i]['errorMessage']
              ),
              onTap: ()=> soVisitorTagForm[i]['errorMessage'] = null,
              onChanged: (text) {
                text != '' ? soTagEntered = true : soTagEntered = false; 
                tagValue = text;
                addFieldInput(soVisitorTagForm[i], tagValue);
              },
            ),
          )
      );
    }
  }

  return Column(children: fields);
}

 Widget soSignatureArea = new SignaturePadWidget(
      soPadController,
      new SignaturePadOptions(
          dotSize: 5.0,
          minWidth: 1.0,
          maxWidth: 4.0,
          penColor: "#010269",
          signatureText: "Signed on " + DateFormat('yyyy-MM-dd HH:MM:SS').format(DateTime.now()).toString()),
    );

Widget _getsoSignaturePad() {
  return new Container(
    height: 150.0,
    decoration: BoxDecoration(color: Color(0xFFF0F0F2)),
    child: soSignatureResult == null ? soSignatureArea : new Image.memory(soSignatureResult)
  );

}

  Widget _padding(x){
      return Padding(padding: EdgeInsets.all(x),);
    }

    return WillPopScope(
          onWillPop: () async => false,
          child: Theme(
            data: themeSet,
            child: Scaffold(
          body: Container(
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                    color: colorPrimary,
                    image: DecorationImage(
                          image: advertImg,
                        fit: BoxFit.cover,
                        // colorFilter: ColorFilter.mode(Theme.of(context).primaryColor.withOpacity(0.1), BlendMode.dstATop)
                    ),

              ),
                          width: mediaWidth(context)*0.42,
                            child: Center(child: Column(
                              children: <Widget>[
                              ],
                            ))
                        ),

                  Flexible(
                    child: ListView(
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            // IconButton(icon: Icon(Icons.home, size: 50.0,),
                            // color: colorPrimary,
                            // onPressed: ()=>Navigator.pushReplacementNamed(context, '/HomeScreen'),
                            // ),
                            Align(
                              alignment: Alignment.topRight,
                                child: Padding(
                                padding: const EdgeInsets.only(top: 10.0, bottom: 20.0, right: 30.0),
                                child: Image(image: logo,
                                       height: 70.0,
                                      //  width: 70.0,
                                       ),
                              ),
                            ),
                          ],
                        ),

                        !signout || peep  ? Padding(
                          padding: const EdgeInsets.only(left: 100.0, right: 100.0, top: 80.0),
                          child: Text('Enter your Tag Number to Sign Out',
                            style: TextStyle(
                                    color: colorSecondary,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w300),
                          ),
                        ): Padding(padding: EdgeInsets.all(0.0),),
                            ! signout || peep  ? _padding(20.0) : Padding(padding: EdgeInsets.all(0.0),),
                            
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 100.0),
                              child: (!signout && tagEnabled) || peep ? _getTagFormFields(context) : Padding(padding: EdgeInsets.all(0.0),),
                            ),

                            !signout ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 100.0),
                              child: !submitTag ? FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.07),
                                  splashColor: colorSecondary,
                                  color: colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0)),
                                  child: Text( 'Submit',
                                    style: TextStyle(fontSize: 30.0, color: Colors.white),),
                                  onPressed: () {
                                    setState(() {
                                      if(checkSOTagInput(context)) {
                                        if(peep){
                                          signout = true;
                                        } else {
                                          checkTagNumber();
                                        }
                                        
                                      }
                                      });
                                  } 
                                  ) :
                                  
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                  Text('Checking Tag....', 
                                  style: TextStyle(
                                  fontSize: 24.00, 
                                  color: colorPrimary
                                  ),),
                                  _padding(5.0),
                                  CircularProgressIndicator(
                                  strokeWidth: 4.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
                            ],),
                            ) :Padding(padding: EdgeInsets.all(0.0),),

                            !signout || peep  ? _padding(10.0) : Padding(padding: EdgeInsets.all(0.0),),

                                signout && !peep ? Column(
                                      children: <Widget>[
                                     Padding(
                                    padding: const EdgeInsets.only(bottom: 10.0),
                                    child: Container(
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.rectangle,
                                        border: Border.all(
                                          color: colorSecondary,
                                          width: 2.0
                                          )
                                        ),
                                            height: 120.0,
                                            width: 120.0,
                                            child: ClipRect(
                                              child: Image.network(signOutData['photoURL'], fit: BoxFit.cover,))
                                      ),
                                  ),
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: <Widget>[
                                            Text(signOutData['name'].toUpperCase(), 
                                                style: TextStyle(
                                                      color: colorPrimary,
                                                      fontSize: 28.0,
                                                      fontWeight: FontWeight.bold),
                                                ),
                                                _padding(1.0),
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: <Widget>[
                                                Text('Tag Number: ', 
                                                    style: TextStyle(
                                                          color: Colors.blueGrey.withOpacity(0.8),
                                                          fontSize: 18.0,
                                                          // fontWeight: FontWeight.bold
                                                          ),
                                                    ),
                                                Text(signOutData['tagNumber'].toUpperCase(), 
                                                    style: TextStyle(
                                                          color: Colors.blueGrey.withOpacity(0.8),
                                                          fontSize: 18.0,
                                                          // fontWeight: FontWeight.bold
                                                          ),
                                                    ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ],
                                    ) : Padding(padding: EdgeInsets.all(0.0),),

                            _padding(20.0),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 100.0),
                                        child: signout && signatureEnabled ?
                                            Column(
                                              crossAxisAlignment: CrossAxisAlignment.stretch,
                                              children: <Widget>[
                                              GestureDetector(
                                                child: _getsoSignaturePad(),
                                                onPanDown: (DragDownDetails details) {
                                                  signOutTagFocusNode.unfocus();
                                              setState(() {
                                                  signed = true;
                                                  signOutRemark = 'Clear Signature';
                                                  signOutRemarkColor = Colors.blueGrey.withOpacity(0.6);
                                                });
                                                },
                                              ),
                                              Padding(padding: EdgeInsets.all(1.0),),
                                        FlatButton(
                                            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.04),
                                            splashColor: colorPrimary,
                                            color: signOutRemarkColor,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(0.0)),
                                            child: Text(signOutRemark,
                                              style: TextStyle(fontSize: 18.0, color: Colors.white),),
                                            onPressed: () {
                                              if (signOutRemark == 'Clear Signature') {
                                                setState(() {
                                                  soPadController.clear();
                                                  soSignatureResult = null;
                                                  signOutRemarkColor = Colors.blueGrey.withOpacity(0.6);
                                                  signOutRemark = 'Sign Here';
                                                  signed = false;
                                                });
                                              }
                                            }),
                                              ],): Padding(padding: EdgeInsets.all(0.0),),
                                      ),

                                        _padding(10.0),

                                        (signout && !signed) && !peep ? InkWell(
                                          child: Padding(padding: EdgeInsets.symmetric(horizontal: mediaWidth(context)*0.15),
                                              child: Text('Not You? Please inform the front desk officer. For your safety, please do NOT sign if the picture is not you.', 
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    fontSize: 18.00, 
                                                    color: Color(0xFFE57373)
                                                ),
                                                ),
                                          ),
                                          
                                          onTap: (){
                                            // setState(() {
                                            //   signout = false;
                                            //   submitTag = false;
                                            // });
                                          },
                                          ) : Padding(padding: EdgeInsets.all(0.0)),
                            

                            !signingOut ? (signout && signed ? Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 100.0),
                              child: FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.07),
                                  splashColor: colorSecondary,
                                  color: colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0)),
                                  child: Text( 'Sign OUT',
                                    style: TextStyle(fontSize: 30.0, color: Colors.white),),
                                  onPressed: () {
                                    setState(() {
                                      if(checkSOInput(context)) {
                                        signingOut = true;
                                        if(peep){
                                          Navigator.pushReplacementNamed(context, '/GoodByeScreen');
                                        } else {
                                          signOutVisitor(signOutData);
                                        }
                                        
                                      }
                                      });
                                  } 
                                  ),
                            ) :Padding(padding: EdgeInsets.all(0.0),)) :
                              Column(
                                  children: <Widget>[
                                  Text('Signing OUT ....', 
                                  style: TextStyle(
                                  fontSize: 24.00, 
                                  color: colorPrimary
                                  ),),
                                  _padding(5.0),
                                  CircularProgressIndicator(
                                  strokeWidth: 4.0,
                                  valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
                            ],)

                      ],
                    ),
                  ),
                ],
              ),
            ),
          floatingActionButton: mediaBottom(context) != 0 ? null : new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.close, color: Colors.white,),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){
              soVisitorTagForm[0]['errorMessage'] = null;
              Navigator.pushReplacementNamed(context, '/HomeScreen');
              }
        )   
        ),
      ),
    );
  }
}