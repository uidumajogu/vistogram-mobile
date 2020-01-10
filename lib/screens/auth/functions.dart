
import 'package:flutter/material.dart';
import 'package:visitor_register/screens/auth/ui.dart';

String value;
bool authError;
String authErrorString;
String authText;
String authProcess = 'Verifiying....';
bool loading;
bool authCodeComplete;
bool noAuthCode;
int authFieldCount;
List<FocusNode> focusNodes;
List authCode;
String authCodeString;
String loadingText;
Color mColor = Color(0xFF8934FF);
Color tColor = Color(0xFF2C2826);
Color sColor = Color(0xFFFFC233);
Color dColor = Color(0xFFE57373);

getAuthFieldParameters(){
  for(var i = 0; i < authFieldCount; i++){
    FocusNode i = new FocusNode();
    focusNodes.add(i);
    authCode.add('');
  }
}

nextFocus(FocusNode fn,c){
  FocusScope.of(c).requestFocus(fn);
}

addAuthCodeInput(i,v){
  authCode[i] = v;
}

checkAuthCodeInputs(i,c){
  for(var x = 0; x < i; x++){
    if(authCode[x].length < 4){
      nextFocus(focusNodes[x], c);
      break;
    }
  }
}

TextInputType inputType(i) {
  return 
    i == 'text' ? TextInputType.text :
    i == 'number' ? TextInputType.number :
    i == 'emailAddress' ? TextInputType.emailAddress :
    null;
}


IconData icon(i) {
  return 
    i == 'person_outline' ? Icons.person_outline :
    i == 'person' ? Icons.person :
    i == 'phone' ? Icons.phone :
    i == 'alternate_email' ? Icons.alternate_email :

    i == 'map' ? Icons.map :
    i == 'adjust' ? Icons.adjust :
    i == 'location_city' ? Icons.location_city :
    i == 'public' ? Icons.public :

    i == 'person_pin' ? Icons.person_pin :
    i == 'work' ? Icons.work :
    i == 'all_out' ? Icons.all_out :

    i == 'account_balance' ? Icons.account_balance :

    i == 'picture_in_picture' ? Icons.picture_in_picture :
    null;
}

NetworkImage image(i) {
  return NetworkImage(i);
}

remapFlutterMaterialForm(l) {
  for (var x = 0; x < l.length; x++) {
    l[x]['keyboardType'] = inputType(l[x]['keyboardType']);
    l[x]['suffixIcon'] = icon(l[x]['suffixIcon']);
  }
}

remapFlutterMaterialImage(l) {
  for (var x = 0; x < l.length; x++) {
    adverts.add(image(l[x]));
  }
}


class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll("#", "");
    if (hexColor.length == 6) {
      hexColor = "FF" + hexColor;
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

var dPeepSetting = {
    "logoImageDownloadUrl" : "https://firebasestorage.googleapis.com/v0/b/digitalvisitorregister.appspot.com/o/images-demo%2FdemoLogo.png?alt=media&token=6f1e4009-c9a1-46c7-a308-538ae9901eeb",
    "advertsDownloadUrl" : ["https://firebasestorage.googleapis.com/v0/b/digitalvisitorregister.appspot.com/o/images-default%2FadvImg.jpeg?alt=media&token=f8487a7c-9313-4c7e-8203-4b81fa5fc1c1"],
    "backgroundImageDownloadUrl" : "https://firebasestorage.googleapis.com/v0/b/digitalvisitorregister.appspot.com/o/images-demo%2FdemoBkg.jpg?alt=media&token=f838f6c6-2855-4fa9-8351-c238ebfc95bc",
    "businessBranch" : "",
    "businessCategory" : "Corporate",
    "businessMultiOffices" : [],
    "businessName" : "Aived Limited",
    "businessSlogan" : "",
    "primaryColor" : "#01185F",
    "secondaryColor" : "#FF9001",
    "welcomeMessage" : "",
    "purposeOfVisitOptions" : [
        {"active":true,"option":"Official"},
        {"active":true,"option":"Personal"},
        {"active":true,"option":"Delivery"}],
    "fields" : {
        "addressForm":[
            {"active":true,"errorMessage":null,"field":"Address","hintText":"Address","key":"address","keyboardType":"text","maxLines":2,"suffixIcon":"map"},
            {"active":true,"errorMessage":null,"field":"Zip Code","hintText":"Zip Code","key":"zipCode","keyboardType":"text","maxLines":1,"suffixIcon":"adjust"},
            {"active":true,"errorMessage":null,"field":"State","hintText":"State","key":"state","keyboardType":"text","maxLines":1,"suffixIcon":"location_city"},
            {"active":true,"errorMessage":null,"field":"Country","hintText":"Country","key":"country","keyboardType":"text","maxLines":1,"suffixIcon":"public"}],
        "bioForm":[
            {"active":true,"errorMessage":null,"field":"First Name","hintText":"First Name","key":"firstName","keyboardType":"text","maxLines":1,"suffixIcon":"person_outline"},
            {"active":true,"errorMessage":null,"field":"Last Name","hintText":"Last Name","key":"lastName","keyboardType":"text","maxLines":1,"suffixIcon":"person"},
            {"active":true,"errorMessage":null,"field":"Phone Number","hintText":"Phone Number","key":"phoneNumber","keyboardType":"number","maxLines":1,"suffixIcon":"phone"},
            {"active":true,"errorMessage":null,"field":"Email","hintText":"Email","key":"email","keyboardType":"emailAddress","maxLines":1,"suffixIcon":"alternate_email"}],
        "hostForm":[
            {"active":false,"errorMessage":null,"field":"Company","hintText":"Select Company","key":"selectCompany","keyboardType":"text","maxLines":1,"suffixIcon":"account_balance"},
            {"active":true,"errorMessage":null,"field":"Whom to See","hintText":"name of staff to See","key":"whomToSee","keyboardType":"text","maxLines":1,"suffixIcon":"person_pin"},
            {"active":true,"errorMessage":null,"field":"Department or Unit","hintText":"Enter Department or Unit","key":"duOfwWomToSee","keyboardType":"text","maxLines":1,"suffixIcon":"work"},
            {"active":true,"errorMessage":null,"field":"Purpose of Visit","hintText":"e.g. official or unnofficial","key":"purposeOfVisit","keyboardType":"text","maxLines":1,"suffixIcon":"all_out"}],
        "inputParams":{"1bioForm":true,"2addressForm":true,"3hostForm":true,"4takePicture":true,"5signaturePad":true,"6tagForm":true},
        "tagForm":[
            {"active":true,"errorMessage":null,"field":"Tag Number","hintText":"Tag Number","key":"tagNumber","keyboardType":"number","maxLines":1,"suffixIcon":"picture_in_picture"}]
        },
};
