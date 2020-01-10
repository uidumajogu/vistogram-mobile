import 'package:flutter/material.dart';
import 'package:visitor_register/screens/auth/functions.dart';
import 'package:visitor_register/utils/common.dart';
import 'package:visitor_register/screens/auth/ui.dart';

String _vcErrorText;
TextEditingController _vcTextController;
FocusNode _vcFocusNode;
String _vcInputBoxLabel;
String _vistocode;
bool _enterVistode;
bool _checkingVistocode;
bool _checkVistocodeStatus;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  _textListener() {
    if(_vcFocusNode.hasFocus){
      final _text = _vcTextController.text == '' ? _vcTextController.text : _vcTextController.text.toUpperCase();
        _vcTextController.value = _vcTextController.value.copyWith(
          text: _text,
          selection: TextSelection(baseOffset: _text.length, extentOffset: _text.length),
          composing: TextRange.empty,
        );
        _vistocode = _text;
    }
  }

  _focusListener() {
  }

  _unfocus() {
    _vcFocusNode.unfocus();
  }

  _getVistocodeData(){
    _checkingVistocode = true;
    _vcErrorText = null;
    _unfocus();

    if(_vistocode == '') {
        setState(() {
          _vcErrorText = 'No vistocode was entered';
          _checkingVistocode = false;
        });  
    } else {
    db.collection('vistocode-' + licenceData['ID'])
    .document(_vistocode) 
    .get()
    .then((doc) {
      if(doc.exists){
        assignInputValues(doc.data);
          _enterVistode = false;
          _vistocode = '';
          _checkingVistocode = false;
          _checkVistocodeStatus = false;
          _vcErrorText = null;
          Navigator.pushReplacementNamed(context, '/WelcomeScreen');
      }else{
        setState(() {
          _vcErrorText = 'This Vistocode does not exist';
          _checkingVistocode = false;
        });   
      }
    }).catchError((error){
      setState(() {
        _vcErrorText = error.toString();
        _checkingVistocode = false;
      });
    });
    }
  }

  @override
  void initState() {
    super.initState();

    _vistocode = '';
    _enterVistode = false;
    _checkingVistocode = false;
    _checkVistocodeStatus = false;
    _vcErrorText = null;
    _vcTextController =TextEditingController();
    _vcFocusNode = FocusNode();
    _vcInputBoxLabel = 'Enter your Vistocode';

    _vcTextController.addListener(_textListener);
    _vcFocusNode.addListener(_focusListener);
  }

  @override
  void dispose() {
    super.dispose();
    _vcTextController.dispose();
    _vcFocusNode.dispose();
  }


  @override
  Widget build(BuildContext context) {


    return Theme(
      data: themeSet,
          child: Scaffold(
        body: !_checkVistocodeStatus ? Container(
          decoration: BoxDecoration(
              color: colorPrimary,
              image: DecorationImage(
                  image: homeBackgroundImage,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(colorPrimary.withOpacity(0.8), BlendMode.dstATop)
              ),

            ),
          child: Padding(
            padding: EdgeInsets.only(top: mediaHeight(context)*0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                      peep ? Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 100.0),
                          child: InkWell(
                            child: Align(
                              alignment: Alignment.topRight,
                                child: Container(
                                  // color: Colors.white,
                                    alignment: Alignment.center,
                                    width: 100.0,
                                    height: 100.0,
                                    decoration: new BoxDecoration(
                                      color: Color(0xFFFFC233),
                                      shape: BoxShape.circle,
      ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Exit Demo',
                                  style: TextStyle(
                                    fontSize: 15.0, 
                                    fontWeight: FontWeight.bold,
                                    color: Color(0XFF253061), ),),
                                )),   
                            ),
                            onTap: (){

                              Navigator.pushReplacementNamed(context, '/AuthScreen');
                            },
                            ),
                        ) :Padding(padding:EdgeInsets.all(0.0)),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Image(image: logo,
                          height: 80.0,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text('Visitor Register',
                          textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 30.0,),),
                        ),
                      ],
                    ),
                !_enterVistode ? Padding(
                  padding: EdgeInsets.only(bottom: mediaHeight(context)*0.1),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: mediaWidth(context)*0.15),
                        color: colorPrimary.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                              side: BorderSide(color: Colors.white, width: 3.0),
                              borderRadius: BorderRadius.circular(50.0)),
                        child: Text('Sign IN  ', 
                        style: TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700, color: Colors.white)), 
                        onPressed: (){
                          if(peep){
                            Navigator.pushReplacementNamed(context, '/WelcomeScreen');
                          } else {
                            setState(() {
                              _checkVistocodeStatus = true;
                            });
                          }

                        },
                      ),
                      RaisedButton(
                        padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: mediaWidth(context)*0.05),
                        color: colorSecondary.withOpacity(0.7),
                        shape: RoundedRectangleBorder(
                              side: BorderSide(color: colorSecondary),
                              borderRadius: BorderRadius.circular(50.0),),
                        child: Text('Sign OUT', 
                        style: TextStyle(fontSize: 25.0, color: Colors.white),),  
                        onPressed: (){
                            if(peep){
                              Navigator.pushReplacementNamed(context, '/SignOutScreen');
                            }else{
                              Navigator.pushReplacementNamed(context, '/SignOutScreen');
                            }
                          },
                      )
                    ],),
                ) : Padding(padding: EdgeInsets.all(0.0),),
                  ],
                ),
          ),
        ) :
        ListView(
          children: <Widget>[
          Container(
            height: mediaHeight(context),
          decoration: BoxDecoration(
              color: Colors.white,
              image: DecorationImage(
                  image: homeBackgroundImage,
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.white.withOpacity(0.05), BlendMode.dstATop)
              ),

            ),
          child: Padding(
            padding: EdgeInsets.only(top: mediaHeight(context)*0.1),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Image(image: logo,
                          height: 80.0,),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Text('Visitor Register',
                          textAlign: TextAlign.center,
                            style: TextStyle(color: colorPrimary, fontSize: 30.0,),),
                        ),
                      ],
                    ),
                Padding(
                  padding: EdgeInsets.only(bottom: mediaHeight(context)*0.25),
                  child: Center(
                    child: Container(
                      width: mediaWidth(context)*0.5,
                      child: Column(
                        children: <Widget>[
                          !_enterVistode ? Padding(
                              padding: const EdgeInsets.only(bottom: 50.0),
                              child: Text('Do you have a Vistocode?',
                              textAlign: TextAlign.center,
                                style: TextStyle(color: colorSecondary, fontSize: 30.0,),),
                            ) :Padding(padding: EdgeInsets.all(0.0),), 
                          _enterVistode ? Padding(
                            padding: const EdgeInsets.all(50.0),
                            child: TextField(
                              controller: _vcTextController..text = _vistocode,
                              focusNode: _vcFocusNode,
                              keyboardType: TextInputType.text,
                              decoration: InputDecoration(
                              contentPadding: EdgeInsets.all(24.0),
                              border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(15.0)
                                      ),
                              labelText: _vcInputBoxLabel,
                              labelStyle: TextStyle(fontSize: 20.0),
                              suffixIcon: Icon(Icons.lock),
                              errorText: _vcErrorText,
                              ),
                              onChanged: (value){
                                setState(() {
                                  _vcErrorText = null;
                                });
                              },
                            ),
                          ) :Padding(padding: EdgeInsets.all(0.0),),
                          _checkingVistocode ? CircularProgressIndicator(
                            strokeWidth: 4.0,
                            valueColor: AlwaysStoppedAnimation<Color>(mColor)) :
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: !_enterVistode ? mediaWidth(context)*0.06 : mediaWidth(context)*0.04),
                                color: !_enterVistode ? Colors.grey.withOpacity(0.7) : Color(0xFFE57373),
                                shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.white, width: 3.0),
                                      borderRadius: BorderRadius.circular(50.0)),
                                child: Text(!_enterVistode ? 'No' : 'Cancel', 
                                style: TextStyle(fontSize: 25.0, color: Colors.white)), 
                                onPressed: (){
                                  setState(() {
                                    !_enterVistode ? 
                                      Navigator.pushReplacementNamed(context, '/WelcomeScreen') : 
                                      _enterVistode = false;
                                      _vistocode = '';
                                      _checkingVistocode = false;
                                      _checkVistocodeStatus = false;
                                      _vcErrorText = null;
                                  });
  
                                },
                              ),
                              // Padding(padding: EdgeInsets.all(8.0),),
                              RaisedButton(
                                padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: !_enterVistode ? mediaWidth(context)*0.06 : mediaWidth(context)*0.08),
                                color: colorPrimary.withOpacity(0.7),
                                shape: RoundedRectangleBorder(
                                      side: BorderSide(color: Colors.white, width: 3.0),
                                      borderRadius: BorderRadius.circular(50.0),),
                                child: Text(!_enterVistode ? 'Yes' : 'Submit', 
                                style: TextStyle(fontSize: 25.0, color: Colors.white),),  
                                onPressed: (){
                                  setState(() {
                                    !_enterVistode ? 
                                    _enterVistode = true :
                                    _getVistocodeData();
                                  });

                                  },
                              )
                            ],),
                        ],
                      ),
                    ),
                  ),
                ),
                  ],
                ),
          ),
        ),
          ],
        )
      ),
    );
  }
}