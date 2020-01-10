import 'dart:async';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:signature_pad/signature_pad.dart';
import 'package:signature_pad_flutter/signature_pad_flutter.dart';
import 'package:visitor_register/screens/signin/functions.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:image_picker/image_picker.dart';
import 'package:visitor_register/screens/auth/ui.dart';
import 'package:intl/intl.dart';




File photo;

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}


class _SignInScreenState extends State<SignInScreen> {
  

  Future _getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.camera);

      if(image != null) {
        formMessage = 'Tap the Picture\n to take another Photo';
        pictureErrorMessageColor = colorPrimary;
        takePhotoErrorMessage = '';
        takePhotoError = false;
      } else {
        formMessage = 'Take a Picture';
      }

  setState(() {
      photo = image;
    });
  }


  @override
  void initState() {
    super.initState();
    getInputParameters();
    padController = new SignaturePadController();
    cameraController = new CameraController(cameras.first, ResolutionPreset.medium);
    cameraController.initialize();
    getForms();
    getTagParameter();
    getPhotoParameter();
    getSignatureParameter();
    formMessage = hasVistocode ? 'Confirm your Bio Details' : 'Tell us about yourself';
    // resetInputValues();
  }

  @override
  void dispose() {
    super.dispose();
    refreshSignInVariables();
    photo = null;
  }


    @override
    Widget build(BuildContext context) {

      signInVisitor() {
        var docRef = db.collection('visitors-'+ licenceData['ID']).document();
        String photoDownloadURL = '';
        String siSignatureDownloadURL = '';

        uploadToStore('file', licenceData['ID'], 'visitor-'+docRef.documentID, 'photo', photo, photoEnabled).then((purl){
          photoDownloadURL = purl;
          uploadToStore('data', licenceData['ID'], 'visitor-'+docRef.documentID, 'signInSignature', signatureResult, signatureEnabled).then((siurl){
          siSignatureDownloadURL = siurl;
        }).then((data){
            docRef.setData({ 
              'visitorDetails': visitorDetails, 
              'siSignatureURL': siSignatureDownloadURL,
              'soSignatureURL': '',
              'photoURL' : photoDownloadURL,
              'signedOut' : false,
              'AC' : authorizationCode,
              'ID' : licenceData['ID'],
              'businessName' : businessName,
              'businessBranch' : businessBranch,
              'settings': licenceData['setup'],
              'docID' : docRef.documentID,
              'signedInDate' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
              'signedInTime' : DateFormat('HHmmss').format(DateTime.now()),
              'signedOutDate' : '',
              'signedOutTime' : '',
              'vistocode': vVistocode,
              }).then((data){
                if(vVistocode != ''){
                  print(vVdetails);
                  vVdetails.forEach((data){
                    if (data['vistocode'] == vVistocode){
                      data['active'] = false;
                    }
                  });
                  
                  db.collection('vistocode-' + licenceData['ID'])
                  .document(vVistocode).delete();

                  db.collection('vistocodeUsers')
                  .document(vVID).updateData({
                    'visitorsDetails': vVdetails
                  });


                }
                  db.collection('signedInTags-'+ licenceData['ID']).document(authorizationCode + '-' + visitorDetails['Tag Number'])
                  .setData({ 
                    'name': visitorDetails['First Name'] + ' ' + visitorDetails['Last Name'], 
                    'tagNumber': visitorDetails['Tag Number'],
                    'AC' : authorizationCode,
                    'docID' : docRef.documentID,
                    'signedInDate' : DateFormat('yyyy-MM-dd').format(DateTime.now()),
                    'signedInTime' : DateFormat('HHmmss').format(DateTime.now()),
                    'photoURL' : photoDownloadURL,
                    }).then((data){
                        Navigator.pushReplacementNamed(context, '/HomeScreen');
                    });
              });
        });
        });
      }

      checkTagNumber() {
        db.collection('signedInTags-'+ licenceData['ID'])
        .document(authorizationCode + '-' + visitorDetails['Tag Number']) 
        .get()
        .then((doc) {
          if(doc.exists){
            compileError(rVisitorTagForm);
             setState(() {
               rVisitorTagForm[0]['errorMessage'] = 'This Tag number is still in use. It has not been signed OUT';
                submitingVisitorData = false;
              });
          } else {
            signInVisitor();
          }
    }).catchError((error){
        signInVisitor();
    });
      }


    // _myNode.addListener((){
    //   if (_myNode.hasFocus) {
    //           setState(() {
    //               submitingVisitorData = true;
    //           });
    //   } else {
    //         setState(() {
    //               submitingVisitorData = true;
    //           });
    //   }
    // }
    // );

Widget _getBioFormFields(c) {
  List<Widget> fields = new List<Widget>();

  for(var i = 0; i < rVisitorBioForm.length; i++){
    if (rVisitorBioForm[i]['active']) {
      fields.add(
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              enabled: readOnly[rVisitorBioForm[i]['field']],
              controller: initialValue(visitorDetails[rVisitorBioForm[i]['field']]),
              maxLines: rVisitorBioForm[i]['maxLines'],
              keyboardType: rVisitorBioForm[i]['keyboardType'],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18.0),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  labelText: rVisitorBioForm[i]['field'],
                  hintText: rVisitorBioForm[i]['hintText'],
                  suffixIcon: Icon(rVisitorBioForm[i]['suffixIcon']),
                  errorText: rVisitorBioForm[i]['errorMessage']
              ),
              onTap: ()=> rVisitorBioForm[i]['errorMessage'] = null,
              onChanged: (text) {
                value = text;
                addFieldInput(rVisitorBioForm[i], value);
              },
            ),
          )
      );
    }
    
    }

  return Column(children: fields);
}


Widget _getAddressFormFields(c) {
  List<Widget> fields = new List<Widget>();

  for(var i = 0; i < rVisitorAddressForm.length; i++){
    if (rVisitorAddressForm[i]['active']) {
      fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              enabled: readOnly[rVisitorAddressForm[i]['field']],
              controller: initialValue(visitorDetails[rVisitorAddressForm[i]['field']]),
              maxLines: rVisitorAddressForm[i]['maxLines'],
              keyboardType: rVisitorAddressForm[i]['keyboardType'],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                labelText: rVisitorAddressForm[i]['field'],
                hintText: rVisitorAddressForm[i]['hintText'],
                suffixIcon: Icon(rVisitorAddressForm[i]['suffixIcon']),
                errorText: rVisitorAddressForm[i]['errorMessage']
              ),
              onTap: ()=> rVisitorAddressForm[i]['errorMessage'] = null,
              onChanged: (text) {
                value = text;
                addFieldInput(rVisitorAddressForm[i], value);
              },
            ),
          )
      );
    }
  }

  return Column(children: fields);
}

_purposeOfVisitInput(c, f) {

  List<Widget> _options = new List<Widget>();

  for(var i = 0; i < rPurposeOfVisitOptions.length; i++){
    if (rPurposeOfVisitOptions[i]['active']) {

      _options.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(Icons.check_box_outline_blank, 
                      size: 30.0, 
                      color: colorPrimary,),
                  Padding(padding: EdgeInsets.all(10.0),),
                  Text('${rPurposeOfVisitOptions[i]['option']}', 
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorPrimary
                  ),
                  ),
                ],
              ),
              onPressed: () { 
                addFieldInput(f, rPurposeOfVisitOptions[i]['option']);
                setState(() {
                  Navigator.of(c).pop();
                });
                purposeOfVisitFocusNode.unfocus();
                },
            ),
        ),
      );
    }}

    showDialog(
    context: c,
    builder: (BuildContext c) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text('Select Purpose of Visit', 
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w400
        ),),
        children: _options
      );
    }
  );
}


_multiOfficesInput(c, f) {

  List<Widget> _offices = new List<Widget>();

  for(var i = 0; i < rmultiOfficesOptions.length; i++){
    if (rmultiOfficesOptions[i]['active']) {

      _offices.add(
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: SimpleDialogOption(
              child: Row(
                children: <Widget>[
                  Icon(Icons.check_box_outline_blank, 
                      size: 30.0, 
                      color: colorPrimary,),
                  Padding(padding: EdgeInsets.all(10.0),),
                  Text('${rmultiOfficesOptions[i]['office']}', 
                  style: TextStyle(
                    fontSize: 24.0,
                    color: colorPrimary
                  ),
                  ),
                ],
              ),
              onPressed: () { 
                addFieldInput(f, rmultiOfficesOptions[i]['office']);
                setState(() {
                  Navigator.of(c).pop();
                });
                multiOfficesOptionsFocusNode.unfocus();
                },
            ),
        ),
      );
    }}

    showDialog(
    context: c,
    builder: (BuildContext c) {
      return SimpleDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
        title: const Text('Select the company you are visiting', 
        style: TextStyle(
          fontSize: 25.0,
          color: Colors.blueGrey,
          fontWeight: FontWeight.w400
        ),),
        children: _offices
      );
    }
  );
}

Widget _getHostFormFields(c) {
  List<Widget> fields = new List<Widget>();

  

  for(var i = 0; i < rVisitorHostForm.length; i++){

      if (rVisitorHostForm[i]['active'] && rVisitorHostForm[i]['key'] == 'selectCompany') {
      fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              
              children: <Widget>[
                TextField(
                  enabled: readOnly[rVisitorHostForm[i]['field']],
                  focusNode: multiOfficesOptionsFocusNode,
                  controller: initialValue(visitorDetails[rVisitorHostForm[i]['field']]),
                  maxLines: rVisitorHostForm[i]['maxLines'],
                  keyboardType: rVisitorHostForm[i]['keyboardType'],
                  decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                labelText: rVisitorHostForm[i]['field'],
                hintText: rVisitorHostForm[i]['hintText'],
                suffixIcon: Icon(rVisitorHostForm[i]['suffixIcon']),
                errorText: rVisitorHostForm[i]['errorMessage']
                  ),
                  onTap: () {
                  rVisitorHostForm[i]['errorMessage'] = null;
                  _multiOfficesInput(c, rVisitorHostForm[i]);
                  multiOfficesOptionsFocusNode.unfocus();
                  },
                  onChanged: (text) {
                value = text;
                addFieldInput(rVisitorHostForm[i], value);
                  },
          ),
        ],
            ),
          )
      );
    }


    if (rVisitorHostForm[i]['active'] && (rVisitorHostForm[i]['key'] != 'purposeOfVisit' && rVisitorHostForm[i]['key'] != 'selectCompany')) {
      fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              enabled: readOnly[rVisitorHostForm[i]['field']],
              controller: initialValue(visitorDetails[rVisitorHostForm[i]['field']]),
              maxLines: rVisitorHostForm[i]['maxLines'],
              keyboardType: rVisitorHostForm[i]['keyboardType'],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                labelText: rVisitorHostForm[i]['field'],
                hintText: rVisitorHostForm[i]['hintText'],
                suffixIcon: Icon(rVisitorHostForm[i]['suffixIcon']),
                errorText: rVisitorHostForm[i]['errorMessage']
              ),
              onTap: ()=> rVisitorHostForm[i]['errorMessage'] = null,
              onChanged: (text) {
                value = text;
                addFieldInput(rVisitorHostForm[i], value);
              },
            ),
          )
      );
    }

  if (rVisitorHostForm[i]['active'] && rVisitorHostForm[i]['key'] == 'purposeOfVisit') {
      fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Stack(
              
              children: <Widget>[
                TextField(
                  enabled: readOnly[rVisitorHostForm[i]['field']],
                  focusNode: purposeOfVisitFocusNode,
                  controller: initialValue(visitorDetails[rVisitorHostForm[i]['field']]),
                  maxLines: rVisitorHostForm[i]['maxLines'],
                  keyboardType: rVisitorHostForm[i]['keyboardType'],
                  decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                labelText: rVisitorHostForm[i]['field'],
                hintText: rVisitorHostForm[i]['hintText'],
                suffixIcon: Icon(rVisitorHostForm[i]['suffixIcon']),
                errorText: rVisitorHostForm[i]['errorMessage']
                  ),
                  onTap: () {
                  rVisitorHostForm[i]['errorMessage'] = null;
                  _purposeOfVisitInput(c, rVisitorHostForm[i]);
                  purposeOfVisitFocusNode.unfocus();
                  },
                  onChanged: (text) {
                value = text;
                addFieldInput(rVisitorHostForm[i], value);
                  },
          ),
        ],
            ),
          )
      );
    }
  
  }

  return Column(children: fields);
}



Widget _takePictureShot(c) {
      return Align(
              child: Container(
          padding: EdgeInsets.all(5.0),
            height: mediaWidth(c)*0.20,
            width: mediaWidth(c)*0.20,
            decoration: BoxDecoration(
              border: Border.all(
                  color: takePhotoError ? Colors.red : 
                  photo == null ? colorPrimary : colorPrimary,
                  width: 2.0,
                  style: BorderStyle.solid
              ),
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
            ),
            child: photo == null ?
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.camera_alt), 
                  iconSize: 100.0, 
                  color: colorPrimary.withOpacity(0.3),
                  onPressed: ()=> _getImage(),
                  ),
                Text(takePhotoErrorMessage + '\n (tap the camera icon)', 
                style: TextStyle(color: pictureErrorMessageColor
                , fontSize: 14.0),)
            ],)
            : 
            
            InkWell(
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(20.0)),
              child: Image.file(
                photo, fit: BoxFit.cover,)
                ),
            onTap: ()=> _getImage(),
            )
            
        ),
      );
}

    Widget signatureArea() {
      return new SignaturePadWidget(
      padController,
      new SignaturePadOptions(
          dotSize: 5.0,
          minWidth: 1.0,
          maxWidth: 4.0,
          penColor: "#010269",
          signatureText: "Signed on " + DateFormat('yyyy-MM-dd HH:MM:SS').format(DateTime.now()).toString()),
    );
    } 

Widget _getSignaturePad() {
  return new Container(
    height: 150.0,
    decoration: BoxDecoration(color: Color(0xFFF0F0F2)),
    child: signatureResult == null ? signatureArea() : new Image.memory(signatureResult)
  );

}

Widget _getTagFormFields(c) {
  List<Widget> fields = new List<Widget>();

  for(var i = 0; i < rVisitorTagForm.length; i++){
    if (rVisitorTagForm[i]['active']) {
      fields.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: TextField(
              controller: initialValue(visitorDetails[rVisitorTagForm[i]['field']]),
              maxLines: rVisitorTagForm[i]['maxLines'],
              keyboardType: rVisitorTagForm[i]['keyboardType'],
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(18.0),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15.0)
                ),
                labelText: rVisitorTagForm[i]['field'],
                hintText: rVisitorTagForm[i]['hintText'],
                suffixIcon: Icon(rVisitorTagForm[i]['suffixIcon']),
                errorText: rVisitorTagForm[i]['errorMessage']
              ),
              onTap: ()=> rVisitorTagForm[i]['errorMessage'] = null,
              onChanged: (text) {
                value = text;
                addFieldInput(rVisitorTagForm[i], value);
              },
            ),
          )
      );
    }
  }

  return Column(children: fields);
}

    Widget _padding(x){
      return Padding(padding: EdgeInsets.all(x),);
    }

    TextStyle _normalTextStyle = TextStyle(
          fontSize: 14.0, 
          color: colorSecondary
          );

    TextStyle _normalTextStyleBold = TextStyle(
          fontSize: 16.0, 
          color: colorSecondary,
          fontWeight: FontWeight.bold,
          );

    TextStyle _headerTextStyle = TextStyle(
          fontSize: 35.0, 
          fontWeight: FontWeight.w400,
          color: colorPrimary,
          );


      return WillPopScope(
              onWillPop: () async => false,
              child: Theme(
                  data: themeSet,
                child: Scaffold(
            body: !fsubmit ? Container(
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
                            // Padding(
                            //   padding: const EdgeInsets.only(top: 10.0, left: 30.0),
                            //   child: InkWell(
                            //     child: Container(
                            //         height: 50.0,
                            //         width: 50.0,
                            //         decoration: BoxDecoration(
                            //               borderRadius: BorderRadius.all(Radius.circular(100.0)),
                            //               color: Color(0xFFE57373),
                            //         ),
                            //         child: Icon(Icons.close, size: 30.0, color: Colors.white,)),
                            //       onTap: ()=>Navigator.pushReplacementNamed(context, '/HomeScreen'),
                            //   ),
                            // ),

                            Padding(
                              padding: const EdgeInsets.only(top: 10.0, right: 30.0),
                              child: Align(
                                alignment: Alignment.topRight,
                                      child: Image(image: logo,
                                       height: 80.0,
                                      //  width: 70.0,
                                       ),
                              )
                            ),
                          ],
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left: 100.0, right:100.0, top: 80.0, bottom: 10.0),
                          child: Text(formMessage,
                            style: TextStyle(
                              color: colorSecondary,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w300),),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 30.0, horizontal:100.0),
                          child:  bioForm ? _getBioFormFields(context) :
                                  addressForm ? _getAddressFormFields(context):
                                  hostForm ? _getHostFormFields(context):
                                  takePicture ? _takePictureShot(context) :
                                  signaturePad ?
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.stretch,
                                    children: <Widget>[
                                    GestureDetector(
                                      child: _getSignaturePad(),
                                      onPanDown: (DragDownDetails details) {
                                    setState(() {
                                        signing = true;
                                        signRemark = 'Signature';
                                        signRemarkColor = Colors.blueGrey.withOpacity(0.6);
                                      });
                                      },
                                    ),
                                    Padding(padding: EdgeInsets.all(1.0),),
                                FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.04),
                                  splashColor: colorPrimary,
                                  color: signRemarkColor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(0.0)),
                                  child: Text(signing || signatureResult != null ? 'Clear Signature' : signRemark,
                                    style: TextStyle(fontSize: 18.0, color: Colors.white),),
                                  onPressed: () {
                                    if (signing || signatureResult != null) {
                                      setState(() {
                                        padController.clear();
                                        signatureResult = null;
                                        signRemarkColor = Colors.white;
                                        signing = false;
                                      });
                                    }
                                  }),
                                    ],): null,
                        ),

                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 20.0),
                          child: !generatingTag ? Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              formStepper != 0 ? FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.04),
                                  splashColor: colorPrimary,
                                  // color: Theme.of(context).accentColor.withOpacity(0.2),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0)),
                                  child: Text('BACK',
                                    style: TextStyle(fontSize: 24.0, color: colorSecondary.withOpacity(0.6)),),
                                  onPressed: () {
                                    formStepper--;
                                    setState(() {
                                      nextForm(formStepper, context);
                                    });

                                  } ) : Padding(padding: EdgeInsets.symmetric(horizontal: 50.0)),
                              FlatButton(
                                  padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.07),
                                  splashColor: colorSecondary,
                                  color: colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15.0)),
                                  child: Text( 
                                    formStepper ==  maxStep - 1 ? 'FINISH' : 'NEXT',
                                    style: TextStyle(fontSize: 24.0, color: Colors.white),),
                                  onPressed: () async {
                                  
                                      if (checkInput(context)) {
                                        formStepper++;
                                        if(formStepper == maxStep){
                                              formStepper--;
                                              setState(() {
                                                generatingTag = true;
                                              });

                                                signatureResult = await padController.toPng();
                                                  Timer(Duration(seconds: 3), (){
                                                    setState(() {
                                                      fsubmit = true;
                                                      generatingTag = false;
                                                    });
                                                    });

                                              

                                        } else {
                                          setState(() {
                                            nextForm(formStepper, context);
                                          });
                                              
                                        }                              
                                      } else {
                                        setState(() {
                                          
                                        });
                                      }
                                      
                                  } 
                                  )
                            ],
                          ):
                          Column(
                            children: <Widget>[
                              Text('Please wait ....', 
                              style: TextStyle(
                                fontSize: 24.00, 
                                color: colorPrimary
                                ),),
                                _padding(5.0),
                              CircularProgressIndicator(
                                        strokeWidth: 4.0,
                                        valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
                            ],)
                          ,
                        ),

                        // Align(
                        // alignment: Alignment.bottomCenter,
                        // child: Text('Visitor Register',
                        //   style: TextStyle(color: colorSecondary.withOpacity(0.5), fontSize: 24.0,),),
                        //   ),
                      ],
                    ),
                  ),
                ],
              ),
            ) :


            ListView(
            padding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 40.0),
          shrinkWrap: true,
          children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 50.0),
                        width: 500.0,
                        height: mediaHeight(context)*0.90,
                        child: Card(
                          shape: Border.all(
                            color: colorPrimary,
                            width: 1.0
                          ),
                          margin: EdgeInsets.symmetric(vertical: 10.0),
                          elevation: 10.0,
                          child: Container(
                            padding: EdgeInsets.all(20.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[

                                  Row(
                                    children: <Widget>[
                                      Image(image: logo,
                                      alignment: Alignment.topLeft,
                                      height: 50.0,
                                      ),
                                    ],
                                  ),


                                  Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: Column(
                                      children: <Widget>[
                                        Text('VISITOR', 
                                            style: TextStyle(
                                                color: colorPrimary,
                                                fontSize: 80.0,
                                                fontWeight: FontWeight.w400
                                            ),
                                          ),
                                        Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Container(
                                            padding: EdgeInsets.all(2.0),
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              border: Border.all(
                                                color: colorSecondary,
                                                width: 2.0
                                                )
                                              ),
                                                  height: 250.0,
                                                  width: 250.0,
                                                  child: ClipOval(
                                                    child: Image.file(photo, fit: BoxFit.cover,))
                                            ),
                                        ),

                                          Text(visitorDetails['First Name'].toUpperCase() + ' ' + visitorDetails['Last Name'].toUpperCase(), 
                                              style: _headerTextStyle,
                                              ),
                                      ],
                                    ),
                                  ),

                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                          children: <Widget>[
                                              Text('Here To See:', 
                                                  style: _normalTextStyle),
                                                  _padding(2.0),
                                                  Text(visitorDetails['Whom to See'],
                                                  style: _normalTextStyleBold
                                                  ),

                                                    _padding(3.0),

                                                  Text(visitorDetails['Department or Unit'] != '' ? '(${visitorDetails['Department or Unit']})' : '',
                                                  style: _normalTextStyle
                                                              ),
                                                          ],
                                                  ),
                              ],),
                          ),
                        ),
                      ),

                      Flexible(
                      
                        child: Column(
                          children: <Widget>[
                            Text('Enter Tag Number',
                                style: TextStyle(
                                        color: colorSecondary,
                                        fontSize: 24.0,
                                        fontWeight: FontWeight.w300),
                            ),
                                  _padding(20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 100.0),
            child: tagEnabled ? _getTagFormFields(context) : Padding(padding: EdgeInsets.all(0.0),),
          ),

_padding(20.0),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 18.0),
            child: !submitingVisitorData ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                                                FlatButton(
                                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.03),
                                                      splashColor: colorSecondary,
                                                      // color: Theme.of(context).accentColor,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0)),
                                                      child: Text( 
                                                        'BACK',
                                                        style: TextStyle(fontSize: 24.0, color: colorSecondary.withOpacity(0.6)),),
                                                      onPressed: () {
                                                        setState(() {
                                                          fsubmit = false;
                                                        });

                                                      }

                                                      
                                                      ),
                                                      FlatButton(
                                                      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: mediaWidth(context)*0.05),
                                                      splashColor: colorSecondary,
                                                      color: colorPrimary,
                                                      shape: RoundedRectangleBorder(
                                                          borderRadius: BorderRadius.circular(15.0)),
                                                      child: Text( 
                                                        'SUBMIT',
                                                        style: TextStyle(fontSize: 24.0, color: Colors.white),),
                                                      onPressed: (){
                                                  setState(() {
                                                    if (checkTagInput(context)) {
                                                      submitingVisitorData = true;
                                                      if(peep) {
                                                        Navigator.pushReplacementNamed(context, '/HomeScreen');
                                                      }else {
                                                        checkTagNumber();
                                                      }
                                                    }
                                                    });
                                                      }
                                                    ) 
                                                  ],
                                                ): 
                                                    Column(
                                                      children: <Widget>[
                                                        Text('Signing IN....', 
                                                        style: TextStyle(
                                                          fontSize: 24.00, 
                                                          color: colorPrimary
                                                          ),),
                                                          _padding(5.0),
                                                        CircularProgressIndicator(
                                                                  strokeWidth: 4.0,
                                                                  valueColor: AlwaysStoppedAnimation<Color>(colorPrimary)),
                                                      ],),
                                              )
                          ],),
                      )
                    ],
                  ),


          ],
    ),

    floatingActionButton: mediaBottom(context) != 0 ? null : new FloatingActionButton(
      elevation: 0.0,
      child: new Icon(Icons.close, color: Colors.white,),
      backgroundColor: new Color(0xFFE57373),
      onPressed: ()=>Navigator.pushReplacementNamed(context, '/HomeScreen')
    )
          ),
        ),
      );
    }

}


