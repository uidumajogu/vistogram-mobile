import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:signature_pad_flutter/signature_pad_flutter.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:visitor_register/screens/auth/ui.dart';


var soVisitorTagForm = []; 
SignaturePadController soPadController;
Uint8List soSignatureResult;
String signOutRemark;
Color signOutRemarkColor;
bool signout = false;
bool signed = false;
bool signingOut = false;
bool soTagEntered = false;
bool submitTag = false;
FocusNode signOutTagFocusNode = new FocusNode();


String tagValue;

getForms(){
   for(var i = 0; i < visitorTagForm.length; i++){
    if (visitorTagForm[i]['active']) {
      soVisitorTagForm.add(visitorTagForm[i]);
    }
  }
}


checkSOInput(c) {
    return checkSOTagInput(c) && checksoSignatureInput(c);
}

checksoSignatureInput(c) {
    if (signatureEnabled) {
    if (!soPadController.hasSignature) {
      signOutRemark = 'Your Signature is required';
      signOutRemarkColor = Colors.red;
      signed = false;
      return false;
    } else {
      signOutRemark = 'Clear Signature';
      signOutRemarkColor = Colors.blueGrey.withOpacity(0.6);
      signed = true;
      return true;
    } 
  } else {
    return true;
  }
}

checkSOTagInput(c) {
    if (tagEnabled) {
    return compileError(soVisitorTagForm);
  } else {
    return true;
  }
}

refreshSignOutVariables() {
  resetInputValues();
  soVisitorTagForm = [];
  signatureEnabled = false;
  signOutRemark = 'Sign Here';
  signOutRemarkColor = Colors.blueGrey.withOpacity(0.6);
  signout = false;
  signingOut = false;
  signed = false;
  soTagEntered = false;
  submitTag = false;
  soPadController.clear();
  soSignatureResult = null;
  tagEnabled = false;
}