import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:visitor_register/screens/signin/ui.dart';
import 'package:visitor_register/screens/auth/ui.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:signature_pad_flutter/signature_pad_flutter.dart';
import 'package:camera/camera.dart';


var _inputParams = [];
var rVisitorBioForm = [];
var rVisitorAddressForm = [];
var rVisitorHostForm = [];
var rVisitorTagForm = [];
var rPurposeOfVisitOptions = [];
var rmultiOfficesOptions = [];
FocusNode purposeOfVisitFocusNode = new FocusNode();
FocusNode multiOfficesOptionsFocusNode = new FocusNode();
Color pictureErrorMessageColor;
bool fsubmit = false;
bool submitingVisitorData = false;
bool generatingTag = false;

SignaturePadController padController;
CameraController cameraController;

List<CameraDescription> cameras;
var now = DateTime.now();
bool bioForm = true;
bool addressForm = false;
bool hostForm = false;
bool tagForm = false;
bool signaturePad = false;
bool takePicture = false;

var color = Colors.red;
var strokeWidth = 5.0;

int formStepper = 0;
int maxStep = 1;
String value;
String _paramsName;

String welcomeMessage = 'Welcome';
String formMessage = hasVistocode ? 'Confirm your Bio Details' : 'Tell us about yourself';

String signRemark = 'Signature';
Color signRemarkColor = Colors.white;
bool signing = false;
Uint8List signatureResult; 
String signatureResultString;

String takePhotoErrorMessage = '';
bool takePhotoError = false;

getForms(){
  for(var i = 0; i < visitorBioForm.length; i++){
    if (visitorBioForm[i]['active']) {
      rVisitorBioForm.add(visitorBioForm[i]);
    }
  }

  for(var i = 0; i < visitorAddressForm.length; i++){
    if (visitorAddressForm[i]['active']) {
      rVisitorAddressForm.add(visitorAddressForm[i]);
    }
  }

  for(var i = 0; i < visitorHostForm.length; i++){
    if (visitorHostForm[i]['active']) {
      rVisitorHostForm.add(visitorHostForm[i]);
    }
  }

   for(var i = 0; i < visitorTagForm.length; i++){
    if (visitorTagForm[i]['active']) {
      rVisitorTagForm.add(visitorTagForm[i]);
    }
  }

  for(var i = 0; i < purposeOfVisitOptions.length; i++){
    if (purposeOfVisitOptions[i]['active']) {
      rPurposeOfVisitOptions.add(purposeOfVisitOptions[i]);
    }
  }

  for(var i = 0; i < multiOfficesOptions.length; i++){
    if (multiOfficesOptions[i]['active']) {
      rmultiOfficesOptions.add(multiOfficesOptions[i]);
    }
  }
}

getInputParameters() {
  inputParams.forEach((k,v){
    if(k != '6tagForm') {
    if (v) {
      _inputParams.add(k);
    }
    }
  });

  maxStep = _inputParams.length;
  _inputParams.sort();
}

checkInput(c) {

  if (bioForm) {
    return compileError(rVisitorBioForm);
  }

  if (addressForm) {
    return compileError(rVisitorAddressForm);
  }

  if (hostForm) {
    return compileError(rVisitorHostForm);
  }

  if (takePicture) {
    if (photo == null) {
      takePhotoErrorMessage = 'Your Photo is required';
      takePhotoError = true;
      pictureErrorMessageColor = Colors.red;
      return false;
    } else {
      takePhotoErrorMessage = '';
      takePhotoError = false;
      pictureErrorMessageColor = colorPrimary;
      return true;
    }
  }

  if (signaturePad) {
    signing = false;
    if (!padController.hasSignature) {
      signRemark = 'Your Signature is required';
      signRemarkColor = Colors.red;
      return false;
    } else {
      signRemark = 'Clear Signature';
      signRemarkColor = Colors.blueGrey.withOpacity(0.6);
      return true;
    } 
  }
}

checkTagInput(c) {
  if (tagEnabled) {
    return compileError(rVisitorTagForm);
  } else {
    return true;
  }
}



nextForm(i, c) {
    _paramsName = _inputParams[i];
      bioForm = false;
      addressForm = false;
      hostForm = false;
      takePicture = false;
      signaturePad = false;
      tagForm = false;
      advertNum++;

  if (advertNum == adverts.length) {
    advertNum = 0;
  }

  advertImg = adverts[advertNum];
  switch(_paramsName) {
    case '1bioForm': {
      bioForm = true;
      formMessage = hasVistocode ? 'Confirm your Bio Details' : 'Tell us about yourself';
    }
    break;

    case '2addressForm': {
      addressForm = true;
      formMessage = hasVistocode ? 'Confirm your Address' : "What's your address?";
    }
    break;

    case '3hostForm': {
      hostForm = true;
      formMessage = hasVistocode ? 'Confirm who you are visiting' : "Who are you visiting?";
    }
    break;

    case '4takePicture': {
      takePicture = true;
      formMessage = "Take a Picture";
      pictureErrorMessageColor = colorPrimary;
    }
    break;

    case '5signaturePad': {
      signaturePad = true;
      formMessage = "Sign here";
    }
    break;
  }
  
}


refreshSignInVariables() {
_inputParams = [];
rVisitorBioForm = [];
rVisitorAddressForm = [];
rVisitorHostForm = [];
rVisitorTagForm = [];
rPurposeOfVisitOptions = [];
rmultiOfficesOptions = [];
pictureErrorMessageColor = Colors.transparent;
fsubmit = false;
submitingVisitorData = false;
padController.clear();
signatureResult = null;

bioForm = true;
addressForm = false;
hostForm = false;
tagForm = false;
signaturePad = false;
takePicture = false;

color = Colors.red;
strokeWidth = 5.0;

formStepper = 0;
maxStep = 1;
value = '';
_paramsName = '';

welcomeMessage = 'Welcome';
formMessage = 'Tell us about yourself';

signRemark = 'Signature';
signRemarkColor = Colors.white;
signing = false;

takePhotoErrorMessage = '';
takePhotoError = false;
tagEnabled = false;
photoEnabled = false;
signatureEnabled = false;
resetInputValues();
}

