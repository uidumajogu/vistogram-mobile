// import 'package:flutter/material.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:visitor_register/utils/common.dart';

// Map inputParams = {};
// Map fields = {};
// List visitorBioForm = [];
// List visitorAddressForm = [];
// List visitorHostForm = [];
// List purposeOfVisitOptions = [];
// List visitorTagForm = [];
// List adverts = [];
// NetworkImage homeBackgroundImage;
// NetworkImage logo;
// Color colorPrimary = Color(0xff000000);
// Color colorSecondary = Colors.blueGrey;
// Color spColor = Colors.blueGrey;

// getParameters(id, s) {
//      Firestore.instance
//         // .collection('settings-' + id)
//         // .document(s)
//         .collection('settings-H37QIJmooIMjouEs6k3GoEmXeiE2')
//         .document('default') 
//         .get()
//         .then((doc) {
//           if(doc.exists){
//             fields = doc.data['fields'];
//             inputParams = fields['inputParams'];

//             visitorBioForm = fields['bioForm'];
//             remapFlutterMaterialForm(visitorBioForm);

//             visitorAddressForm = fields['addressForm'];
//             remapFlutterMaterialForm(visitorAddressForm);

//             visitorHostForm = fields['hostForm'];
//             remapFlutterMaterialForm(visitorHostForm);

//             visitorTagForm = fields['tagForm'];
//             remapFlutterMaterialForm(visitorTagForm);

//             purposeOfVisitOptions = doc.data['purposeOfVisitOptions'];

//             adverts = doc.data['advertsDownloadUrl'];
//             remapFlutterMaterialImage(adverts);

//             homeBackgroundImage = NetworkImage(doc.data['backgroundImageDownloadUrl']);

//             logo = NetworkImage(doc.data['logoImageDownloadUrl']);

//             colorPrimary = Color(0xff + num.parse(doc.data['primaryColor']));
//             // colorSecondary = Color(0xff + doc.data['secondaryColor']);
//             // spColor = Color(0xff + doc.data['secondaryColor']);

//             print(doc.data['primaryColor']);

            


//           } else {
//             print('does not exist');
//           }
      
//     }).catchError((error){
//       print(error);
//     });
// }

// TextInputType inputType(i) {
//   return 
//     i == 'text' ? TextInputType.text :
//     i == 'number' ? TextInputType.number :
//     i == 'emailAddress' ? TextInputType.emailAddress :
//     null;
// }


// IconData icon(i) {
//   return 
//     i == 'person_outline' ? Icons.person_outline :
//     i == 'person' ? Icons.person :
//     i == 'phone' ? Icons.phone :
//     i == 'alternate_email' ? Icons.alternate_email :

//     i == 'map' ? Icons.map :
//     i == 'adjust' ? Icons.adjust :
//     i == 'location_city' ? Icons.location_city :
//     i == 'public' ? Icons.public :

//     i == 'person_pin' ? Icons.person_pin :
//     i == 'work' ? Icons.work :
//     i == 'all_out' ? Icons.all_out :

//     i == 'all_out' ? Icons.picture_in_picture :
//     null;
// }

// NetworkImage image(i) {
//   return NetworkImage(i);
// }

// remapFlutterMaterialForm(l) {
//   for (var x = 0; x < l.length; x++) {
//     l[x]['keyboardType'] = inputType(l[x]['keyboardType']);
//     l[x]['suffixIcon'] = icon(l[x]['suffixIcon']);
//   }
// }

// remapFlutterMaterialImage(l) {
//   for (var x = 0; x < l.length; x++) {
//     l[x] = image(l[x]);
//   }
// }

// // Map inputParams = {
// //   'bioForm': true, 
// //   'addressForm': true, 
// //   'hostForm': true,
// //   'takePicture': true,
// //   'signaturePad': true,
// //   'tagForm': true,
// //   };


// // List<Map<String, dynamic>> visitorBioForm = [
// // { 'field': 'First Name', 'key':'firstName', 'active': true, 'hintText': 'First Name', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.person_outline, 'maxLines': 1, 'errorMessage': null },
// // { 'field': 'Last Name', 'key':'lastName', 'active': true, 'hintText': 'Last Name', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.person, 'maxLines': 1, 'errorMessage': null },
// // { 'field': 'Phone Number', 'key':'phoneNumber', 'active': true, 'hintText': 'Phone Number', 'keyboardType': TextInputType.number, 'suffixIcon': Icons.phone, 'maxLines': 1, 'errorMessage': null },
// // { 'field': 'Email', 'key':'email', 'active': true, 'hintText': 'Email', 'keyboardType': TextInputType.emailAddress, 'suffixIcon': Icons.alternate_email, 'maxLines': 1, 'errorMessage': null },
// // ];


// // List<Map<String, dynamic>> visitorAddressForm = [
// //   { 'field': 'Address', 'key':'address', 'active': true, 'hintText': 'Address', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.map, 'maxLines': 2, 'errorMessage': null },
// //   { 'field': 'Zip Code', 'key':'zipCode', 'active': true, 'hintText': 'Zip Code', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.adjust, 'maxLines': 1, 'errorMessage': null },
// //   { 'field': 'State', 'key':'state', 'active': true, 'hintText': 'State', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.location_city, 'maxLines': 1, 'errorMessage': null },
// //   { 'field': 'Country', 'key':'country', 'active': true, 'hintText': 'Country', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.public, 'maxLines': 1, 'errorMessage': null },
// // ];


// // List<Map<String, dynamic>> visitorHostForm = [
// //  { 'field': 'Whom to See', 'key':'whomToSee', 'active': true, 'hintText': 'name of staff to See', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.person_pin, 'maxLines': 1, 'errorMessage': null },
// //   { 'field': 'Department or Unit', 'key':'duOfwWomToSee', 'active': true, 'hintText': 'department, unit, etc', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.work, 'maxLines': 1, 'errorMessage': null },
// //   { 'field': 'Purpose of Visit', 'key':'purposeOfVisit', 'active': true, 'hintText': 'e.g. official or unnofficial', 'keyboardType': TextInputType.text, 'suffixIcon': Icons.all_out, 'maxLines': 1, 'errorMessage': null },
// // ];


// // List<Map<String, dynamic>> purposeOfVisitOptions = [
// //   { 'option': 'Official', 'active': true,},
// //   { 'option': 'Personal', 'active': true,},
// //   { 'option': 'Delivery', 'active': true,},
// // ];


// // List<Map<String, dynamic>> visitorTagForm = [
// //   { 'field': 'Tag Number', 'key':'tagNumber', 'active': true, 'hintText': 'Tag Number', 'keyboardType': TextInputType.number, 'suffixIcon': Icons.picture_in_picture, 'maxLines': 1, 'errorMessage': null },
// // ];


// // List adverts = [
// //   AssetImage('assets/images/HBNGa.jpeg'),
// //   AssetImage('assets/images/HBNGb.jpeg'),
// //   AssetImage('assets/images/HBNGc.jpeg'),
// // ];


