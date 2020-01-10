import 'dart:async';
import 'package:flutter/material.dart';
import 'package:visitor_register/screens/auth/ui.dart';
import 'dart:core';
import 'dart:math';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:connectivity/connectivity.dart';


final StorageReference visitorStorageRef = FirebaseStorage.instance.ref();

const chars = "3456789ABCDEFGHJMNPRSTUVWXZ";
bool tagEnabled = false;
bool signatureEnabled = false;
bool photoEnabled = false;
var advertNum = 0;
NetworkImage advertImg = adverts[advertNum];
Map<String, dynamic> visitorDetails = {}; 
Map<String, dynamic> readOnly = {}; 
bool hasVistocode = false;
String vVistocode = '';
String vVID = '';
var vVdetails = [];

resetInputValues(){
  hasVistocode = false;
  vVistocode = '';
  vVID = '';
  vVdetails = [];

  visitorDetails = {
    'First Name': '', 
    'Last Name': '',
    'Email': '',
    'Phone Number': '',
    'Address': '',
    'Zip Code': '',
    'State': '',
    'Country': '',
    'Company': '',
    'Whom to See': '',
    'Department or Unit': '',
    'Purpose of Visit': '',
    'Tag Number': '',
  };

  readOnly = {
    'First Name': true, 
    'Last Name': true,
    'Email': true,
    'Phone Number': true,
    'Address': true,
    'Zip Code': true,
    'State': true,
    'Country': true,
    'Company': true,
    'Whom to See': true,
    'Department or Unit': true,
    'Purpose of Visit': true,
    'Tag Number': true,
  };
}

assignInputValues(data){
    hasVistocode = true;
    vVistocode = data['vistocode'];
    vVID = data['docID'];

    visitorDetails = {
    'First Name': data['firstName'], 
    'Last Name': data['lastName'],
    'Email': data['email'],
    'Phone Number': '${data['phoneCode']}${data['phoneNumber']}',
    'Address': data['address'],
    'State': data['state'],
    'Country': data['country'],
    'Zip Code': '',
    'Company': data['businessName'],
    'Whom to See': data['hostFullName'],
    'Department or Unit': data['hostLocation'],
    'Purpose of Visit': data['purpose'],
    'Tag Number': '',
  };

  readOnly = {
    'First Name': false, 
    'Last Name': false,
    'Email': false,
    'Phone Number': false,
    'Address': false,
    'Zip Code': false,
    'State': false,
    'Country': false,
    'Company': false,
    'Whom to See': false,
    'Department or Unit': false,
    'Purpose of Visit': false,
    'Tag Number': true,
  };

  db.collection('vistocodeUsers')
    .document(data['docID']) 
    .get().then((doc) {
      if(doc.exists){
        vVdetails = doc.data['visitorsDetails'];
      }
    });
}



mediaWidth(context) {
  return MediaQuery.of(context).size.width;
}

mediaHeight(context) {
  return MediaQuery.of(context).size.height;
}

mediaBottom(context){
  return MediaQuery.of(context).viewInsets.bottom;
}

bool _validateEmail(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value))
      return false;
    else
      return true;
  }


bool _validateFullName(String value) {
    if (value.trim().indexOf(' ') <= 0 || value.trim().indexOf(' ') >= value.trim().length - 1) {
          return false;
    } else {
       return true;
    }

}

validate(f) {
  if (visitorDetails[f] != ''){
    if (f == 'Email') {
      if(_validateEmail(visitorDetails[f])) {
        return null;
      } else {
        return 'Enter a Valid Email';
      }
    } else {
      if(f == 'Whom to See'){
        if(_validateFullName(visitorDetails[f])) {
          return null;
        } else {
          return 'Enter at least a First and Last Name';
        }
      } else {
        return null;
      }
    }
  } else {
    return 'Your ' + f + ' is required';
  }
}


getTagParameter() {
  inputParams.forEach((k,v){
    if (k == '6tagForm') {
      tagEnabled = v;
    }
  });
}

getSignatureParameter() {
  inputParams.forEach((k,v){
    if (k == '5signaturePad') {
      signatureEnabled = v;
    }
  });
}

getPhotoParameter() {
  inputParams.forEach((k,v){
    if (k == '4takePicture') {
      photoEnabled = v;
    }
  });
}

initialValue(val) {
  return TextEditingController(text: val);
}

addFieldInput(f,i){
  visitorDetails[f['field']] = i;
}

compileError(ff) {
    bool _goToNext = true;
    for(var i = 0; i < ff.length; i++){
      ff[i]['errorMessage'] = validate(ff[i]['field']);
      if (ff[i]['errorMessage'] != null) {
        _goToNext = false;
      }
    }

    return _goToNext;
}

String randomString(int strlen) {
  Random rnd = new Random(new DateTime.now().millisecondsSinceEpoch);
  String result = "";
  for (var i = 0; i < strlen; i++) {
    if(i!=0 && i%4 == 0) {
      result += ' ' + chars[rnd.nextInt(chars.length)];
    } else {
      result += chars[rnd.nextInt(chars.length)];
    }
  }
  return result;
}


  Future<String> uploadToStore(type, id, docID, fileName, img, chk) async {
      String location;

    if(chk) {
      StorageReference reference =  visitorStorageRef.child(id).child(docID).child(fileName);
      StorageUploadTask uploadTask = type == 'file' ? reference.putFile(img) :
                                     type == 'data' ? reference.putData(img) : null;

      final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
      location = await downloadUrl.ref.getDownloadURL();
    } else {
      location = '';
    }

      return location;
    }


    
  Future<bool> checkNetworkConnectivity() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  String capitalizeFirst(String value) {
    return value[0].toUpperCase() + value.substring(1);
  }
