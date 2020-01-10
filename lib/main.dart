import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:visitor_register/screens/auth/ui.dart';
import 'package:visitor_register/screens/goodbye/ui.dart';
import 'package:visitor_register/screens/home/ui.dart';
import 'package:visitor_register/screens/signin/functions.dart';
import 'package:visitor_register/screens/signout/ui.dart';
import 'package:visitor_register/screens/welcome/ui.dart';
import 'screens/signin/ui.dart';

import 'dart:async';
import 'dart:io';
import 'package:device_info/device_info.dart';


Map<String, dynamic> myDeviceData = <String, dynamic>{};
String myDevicePlatform = '';

void main() {
  runZoned(() {

    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
  ]).then((_){
    availableCameras().then((c){
          cameras = c;
          runApp(MyApp());
    });
  });

  }, onError: (dynamic error, dynamic stack) {
  print(error);
  print(stack);
  });

}


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  static final DeviceInfoPlugin deviceInfoPlugin = new DeviceInfoPlugin();


@override
void initState() {
super.initState();
initPlatformState();
}

Future<Null> initPlatformState() async {
Map<String, dynamic> deviceData;

try {
if (Platform.isAndroid) {
deviceData = _readAndroidBuildData(await deviceInfoPlugin.androidInfo);
} else if (Platform.isIOS) {
deviceData = _readIosDeviceInfo(await deviceInfoPlugin.iosInfo);
}
} on PlatformException {
  myDevicePlatform = 'Android';
  deviceData = _readAndroidBuildDataError();
}

if (!mounted) return;

myDeviceData = deviceData;
Platform.isAndroid ? myDevicePlatform = 'Android' : myDevicePlatform = 'iOS';

setState(() {
myDeviceData = deviceData;
Platform.isAndroid ? myDevicePlatform = 'Android' : myDevicePlatform = 'iOS';
});
}

Map<String, dynamic> _readAndroidBuildData(AndroidDeviceInfo build) {
return <String, dynamic>{
'versionSecurityPatch': build.version.securityPatch,
'versionSdkInt': build.version.sdkInt,
'versionRelease': build.version.release,
'versionPreviewSdkInt': build.version.previewSdkInt,
'versionIncremental': build.version.incremental,
'versionCodename': build.version.codename,
'versionBaseOS': build.version.baseOS,
'board': build.board,
'bootloader': build.bootloader,
'brand': build.brand,
'device': build.device,
'display': build.display,
'fingerprint': build.fingerprint,
'hardware': build.hardware,
'host': build.host,
'id': build.id,
'manufacturer': build.manufacturer,
'model': build.model,
'product': build.product,
'supported32BitAbis': build.supported32BitAbis,
'supported64BitAbis': build.supported64BitAbis,
'supportedAbis': build.supportedAbis,
'tags': build.tags,
'type': build.type,
'isPhysicalDevice': build.isPhysicalDevice,
};
}


Map<String, dynamic> _readIosDeviceInfo(IosDeviceInfo data) {
return <String, dynamic>{
'name': data.name,
'systemName': data.systemName,
'systemVersion': data.systemVersion,
'model': data.model,
'localizedModel': data.localizedModel,
'identifierForVendor': data.identifierForVendor,
'isPhysicalDevice': data.isPhysicalDevice,
'utsnameSysname:': data.utsname.sysname,
'utsnameNodename:': data.utsname.nodename,
'utsnameRelease:': data.utsname.release,
'utsnameVersion:': data.utsname.version,
'utsnameMachine:': data.utsname.machine,
'id': data.identifierForVendor,
};
}

Map<String, dynamic> _readAndroidBuildDataError() {
return <String, dynamic>{
'versionSecurityPatch': 'Failed to get device information',
'versionSdkInt': 'Failed to get device information',
'versionRelease': 'Failed to get device information',
'versionPreviewSdkInt': 'Failed to get device information',
'versionIncremental': 'Failed to get device information',
'versionCodename': 'Failed to get device information',
'versionBaseOS': 'Failed to get device information',
'board': 'Failed to get device information',
'bootloader': 'Failed to get device information',
'brand': 'Failed to get device information',
'device': 'Failed to get device information',
'display': 'Failed to get device information',
'fingerprint': 'Failed to get device information',
'hardware': 'Failed to get device information',
'host': 'Failed to get device information',
'id': 'Failed to get device information',
'manufacturer': 'Failed to get device information',
'model': 'Failed to get device information',
'product': 'Failed to get device information',
'supported32BitAbis': 'Failed to get device information',
'supported64BitAbis': 'Failed to get device information',
'supportedAbis': 'Failed to get device information',
'tags': 'Failed to get device information',
'type': 'Failed to get device information',
'isPhysicalDevice': 'Failed to get device information',
};
}


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vistogram',
      theme: ThemeData(
        fontFamily: 'Comfortaa',
        primaryColor: Color(0xFF8934FF),
        accentColor: Color(0xFFFFC233)
      ),
      home: AuthScreen(),
      routes: <String, WidgetBuilder>{
        '/AuthScreen': (BuildContext context) => new AuthScreen(),
        '/HomeScreen': (BuildContext context) => new HomeScreen(),
        '/WelcomeScreen': (BuildContext context) => new WelcomeScreen(),
        '/SignInScreen': (BuildContext context) => new SignInScreen(),
        '/SignOutScreen': (BuildContext context) => new SignOutScreen(),
        '/GoodByeScreen': (BuildContext context) => new GoodByeScreen(),
      },
    );
  }
}