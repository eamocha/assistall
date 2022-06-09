import 'package:agora_flutter_quickstart/auth/signin.dart';
import 'package:agora_flutter_quickstart/auth/signup.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter_signin_button/button_list.dart';
import 'package:flutter_signin_button/button_view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../screens/landing.dart';

class SignUpMainPage extends StatefulWidget {

  final String country,selectedAccountType;
  SignUpMainPage(this.country,this.selectedAccountType);

  @override
  _SignUpMainPageState createState() => _SignUpMainPageState(
      country,selectedAccountType
  );
}

class _SignUpMainPageState extends State<SignUpMainPage> {
  bool terms = false;
  bool signUpOptionEnabled=false;
  String? country,selectedAccountType;
  _SignUpMainPageState(this.country,this.selectedAccountType);
  final AuthRepo _authRepo=AuthRepo();
  String? newtoken;
  late FirebaseMessaging messaging=FirebaseMessaging.instance;

  @override
  void setState(VoidCallback fn) {
    // TODO: implement setState
    super.setState(fn);
  }

  Future deviceToken() async {
    await messaging.getToken().then((value){
      print('The device token' + value.toString());
      setState(() {
        newtoken = value;
      });
    });
  }
  Future gotoSignUpPage() async{
    if(!terms){
      await Ui().errorToast('Accept terms and conditions');
    }
    else if(!signUpOptionEnabled){
      await Ui().errorToast('Select the sign up option');
    }
    else{
      await Navigator.push(context, MaterialPageRoute(builder: (context)=>SignUp(
        country!,selectedAccountType!
      )));

    }
  }
   Future signInWithGoogle({required BuildContext context}) async {
    var auth = FirebaseAuth.instance;

    final googleSignIn = GoogleSignIn();

    final googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final userCredential =
        await auth.signInWithCredential(credential);
        if(userCredential.user !=null){
          var pd = ProgressDialog(context: context);
          pd.show(max: 100, msg: 'Loading...');
          var params={
            'email':userCredential.user!.email.toString(),
            'password':userCredential.user!.uid.toString(),
            'confirm_password':userCredential.user!.uid.toString(),
            'device':newtoken.toString(),
            'name':userCredential.user!.displayName.toString(),
            'last_name':'',
            'phone':userCredential.user!.phoneNumber.toString(),
            'account_type': selectedAccountType.toString(),
          };

          //Checking if user exists
          await _authRepo.checkIfUserExist(params).then((value) async {
            pd.close();
            if(value.status){
              await Ui().successToast('Login successfully');

              Config.set('accessToken', value.message);

              await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
            }
            else{
              await Ui().errorToast(value.message);
            }
          });

          /*print('Sign in up processing'+userCredential.user!.email.toString());
          await _authRepo.googleSignIn(params).then((value) async {
            pd.close();
            if(value.status){

                await Ui().successToast('Login successfully');

                Config.set('accessToken', value.message);

                await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>IndexPage()));
            }
            else{
               await Ui().successToast(value.message);
            }

          });*/

        }

      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          // handle the error here

          await Ui().errorToast('User ecist with different credentials');
        }
        else if (e.code == 'invalid-credential') {
          // handle the error here
          await Ui().errorToast('Invalid credentials');

        }
      } catch (e) {
        // handle the error here
      }
    }
  }

  Future signInWithFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    FirebaseAuth.instance.signInWithCredential(facebookAuthCredential).then((value) async {

      if(value.user !=null){

        var pd = ProgressDialog(context: context);
        pd.show(max: 100, msg: 'Loading...');
        var params={
          'email':value.user!.email.toString(),
          'password':value.user!.uid.toString(),
          'confirm_password':value.user!.uid.toString(),
          'device':newtoken.toString(),
          'name':value.user!.displayName.toString(),
          'last_name':'',
          'phone':value.user!.phoneNumber.toString(),
          'account_type': selectedAccountType.toString(),
        };

        //Checking if user exists
        await _authRepo.checkIfUserExist(params).then((value) async {
          pd.close();
          if(value.status){
            await Ui().successToast('Login successfully');

            Config.set('accessToken', value.message);

            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LandingPage()));
          }
          else{
            await Ui().errorToast(value.message);
          }
        });
      }
      else{
        Ui().errorToast('Invalid credentials');
      }

    });

  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    deviceToken();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.6, color: Colors.blueGrey),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30,right: 30,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: ButtonTheme(
                  height: 40,
                  child: TextButton(
                      onPressed: () {

                        Navigator.pop(context);
                      },
                      child: Text(
                        'back',
                        style: GoogleFonts.quicksand(
                            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                      ).tr()),
                ),
              ),
              Container(
                child: ButtonTheme(
                  height: 40,
                  child: TextButton(
                      onPressed: () {
                        gotoSignUpPage();
                      },
                      child: Text(
                        'submit',
                        style: GoogleFonts.quicksand(
                            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                      ).tr()),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ui.verticalSpace(50),
            Center(
              child: Text('sign_up',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).accentColor
                ),).tr(),
            ),
            Ui.verticalSpaceMedium(),
            ListTile(
              title: SignInButton(
                Buttons.Google,
                onPressed: () {
                  signInWithGoogle(context: context);
                },
              ),
            ),
            ListTile(
              title: SignInButton(
                Buttons.FacebookNew,
                onPressed: () {
                  signInWithFacebook();
                },
              ),
            ),
            ListTile(
              title: SignInButton(
                Buttons.LinkedIn,
                onPressed: () {
                },
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Card(
                child: ListTile(
                  dense: true,
                  title: Text('sign_in',style: TextStyle(fontWeight: FontWeight.bold),).tr(),
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>SignIn()));
                  },
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 10,right: 10),
              child: Card(
                child: ListTile(
                  dense: true,
                  title: Text('sign_up',style: TextStyle(
                    fontWeight: FontWeight.bold
                  ),).tr(),
                  trailing: Checkbox(
                    value: signUpOptionEnabled,
                    onChanged: (value) {
                      setState(() {
                        signUpOptionEnabled=value!;
                      });
                    },
                  ),
                ),
              ),
            ),
            Ui.verticalSpaceMedium(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[ //SizedBox
                Text(
                  'terms',
                  style: TextStyle(fontSize: 17.0),
                ).tr(), //Text
                SizedBox(width: 10), //SizedBox
                /** Checkbox Widget **/
                Checkbox(
                  value: terms,
                  onChanged: (value) {
                    setState(() {
                      terms=value!;
                    });
                  },
                ), //Checkbox
              ], //<Widget>[]
            ), //R


          ],
        ),

      ),
    );
  }
}
