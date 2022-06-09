import 'package:agora_flutter_quickstart/auth/phone.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/screens/landing.dart';
import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SignIn extends StatefulWidget {

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
   String? email, password;
    bool authenticated = false;
   String? newtoken;
   final AuthRepo _authRepo=AuthRepo();
  final _signinKey = GlobalKey<FormState>();
  late FirebaseMessaging messaging=FirebaseMessaging.instance;

  @override
  void initState() {
    super.initState();

    checkIfAuthenticated();
    notification();
    deviceToken();
  }

  Future deviceToken() async {
    print('Hello Alvin');
    await messaging.getToken().then((value){
      print('The device token' + value.toString());
      setState(() {
        newtoken = value;
      });
    });
  }

  void checkIfAuthenticated() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('accessToken') != null) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IndexPage()));
    } else {
      await deviceToken();
    }
  }

  Future joinAlert(String title, String body, String channel) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              body,
              style: GoogleFonts.quicksand(),
            ),
            title: Text(
              title,
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.quicksand(),
                  )),
              TextButton(
                  onPressed: () {

                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.quicksand(),
                  ))
            ],
          );
        });
  }

  @override
  void dispose() {
    super.dispose();

  }

  Future notification() async {
    FirebaseMessaging.onMessage.listen((event) {
      FlutterRingtonePlayer.play(
        android: AndroidSounds.ringtone,
        ios: IosSounds.glass,
        looping: true, // Android only - API >= 28
        volume: 0.7, // Android only - API >= 28
        asAlarm: false, // Android only - all APIs
      );

      joinAlert(
          event.notification!.title.toString(),
          event.notification!.body.toString(),
          event.data['channel'].toString());
    });
  }

  Future authenticate() async {
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...');

    var params={
      'email':email,
      'password':password,
      'device':newtoken
    };

    await _authRepo.login(params).then((value) async {
     pd.close();
     if(value.status){
       await Ui().successToast('Login successfully');

       Config.set('accessToken', value.message);

       await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
     }
     else{
       await Ui().successToast(value.message);
     }
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
          key: _signinKey,
          child: Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 150,
                ),
                Center(
                  child: Text(
                    'assistALL',
                    style: GoogleFonts.quicksand(
                        fontSize: 30,
                        color: Theme.of(context).accentColor,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    children: [
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Invalid email';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          decoration: InputDecoration(
                            label: Text('email',style: TextStyle(color: Colors.black),).tr(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            } else if (value.trim().length < 8) {
                              return 'Password should not be less than 8 characters';
                            } else {
                              return null;
                            }
                          },
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          decoration: InputDecoration(
                            label: Text('password',style: TextStyle(color: Colors.black),).tr(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),

                Center(
                  child: GestureDetector(
                    onTap: () {
                      Navigator.of(context).
                      push(MaterialPageRoute(builder:
                          (context)=>Phone(step: 'FORGOT_PASSWORD')));

                    },
                    child: Text(
                      'forgot',
                      style: GoogleFonts.quicksand(
                          color: Theme.of(context).accentColor,
                          fontWeight: FontWeight.bold),
                    ).tr(),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: ButtonTheme(
                    height: 50,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (_signinKey.currentState!.validate()) {
                            authenticate();
                          } else {}
                        },
                        child: Text(
                          'sign_in',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ).tr()),
                  ),
                ),


                SizedBox(
                  height: 30,
                ),

              ],
            ),
          )),
    );
  }
}
