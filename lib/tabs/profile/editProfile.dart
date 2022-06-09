import 'dart:convert';

import 'package:agora_flutter_quickstart/bloc/userBloc.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/user.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';
import 'package:http/http.dart' as http;
class EditProfile extends StatefulWidget {
  const EditProfile({Key? key}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final _editProfileKey = GlobalKey<FormState>();
  TextEditingController firstNameController= TextEditingController();
  TextEditingController lastNameController= TextEditingController();
  TextEditingController emailController= TextEditingController();
  TextEditingController phoneController= TextEditingController();
  String? email,firstName,lastName,speciality;
  String? phone;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'KEN';
  PhoneNumber number = PhoneNumber(isoCode: 'KE');
  final AuthRepo _authRepo=AuthRepo();
  final _apiBase=ApiBase();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc.myProfile();
    getProfile();
  }

  Future getProfile() async {
    final response = await http
        .get(Uri.parse(_apiBase.baseUrl+'user/profile'),
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonResponse=jsonDecode(response.body);
      setState(() {
        firstName=jsonResponse['user']['name'];
        lastName=jsonResponse['user']['last_name'];
        email=jsonResponse['user']['email'];
        phone=jsonResponse['user']['phone'];
        speciality=jsonResponse['user']['phone'] !=null?jsonResponse['user']['phone']:"spciality";
        controller.text=phone.toString().substring(4);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future submit() async {
    var pd = ProgressDialog(context: context,);
    pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);

    var params={
      'name':firstName,
      'last_name':lastName,
      'email':email,
      'phone':phone
    };

    await _authRepo.updateProfile(params).then((value) async {
      pd.close();
      if(value.status){
        await Ui().successToast(value.message);
        Navigator.pop(context);
      }
      else{
        await Ui().successToast(value.message);
      }
    });



  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
      ),
      body: StreamBuilder(
        stream: userBloc.subject.stream,
        builder: (context,AsyncSnapshot<User> snapshot){
          return Form(
              key: _editProfileKey,
              child: Container(
                decoration: BoxDecoration(),
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: ListView(
                  children: <Widget>[
                    SizedBox(
                      height: 30,
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
                              initialValue: snapshot.data!.name,
                              keyboardType: TextInputType.emailAddress,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter first name';
                                }  else {
                                  return null;
                                }
                              },
                              onChanged: (value){
                                setState(() {
                                  firstName=value;
                                });
                              },
                              decoration: InputDecoration(
                                label: Text('First Name',style: TextStyle(color: Colors.black),).tr(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black12, width: 1.0),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: TextFormField(
                              initialValue: snapshot.data!.last_name,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter last name';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value){
                                setState(() {
                                  lastName=value;
                                });
                              },
                              decoration: InputDecoration(
                                label: Text('Last name',style: TextStyle(color: Colors.black),).tr(),
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
                              initialValue: snapshot.data!.email,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter email';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value){
                                setState(() {
                                  email=value;
                                });
                              },
                              decoration: InputDecoration(
                                label: Text('Email',style: TextStyle(color: Colors.black),).tr(),
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
                              initialValue: snapshot.data!.speciality,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Enter speciality';
                                } else {
                                  return null;
                                }
                              },
                              onChanged: (value){
                                setState(() {
                                  speciality=value;
                                });
                              },
                              decoration: InputDecoration(
                                label: Text('Speciality',style: TextStyle(color: Colors.black),).tr(),
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
                            margin: EdgeInsets.all(20),
                            child:InternationalPhoneNumberInput(
                              onInputChanged: (PhoneNumber number) {
                                setState(() {
                                  phone = number.phoneNumber;
                                });
                              },
                              onInputValidated: (bool value) {

                              },
                              selectorConfig: SelectorConfig(
                                selectorType: PhoneInputSelectorType.DIALOG,
                              ),
                              ignoreBlank: false,
                              autoValidateMode: AutovalidateMode.always,
                              selectorTextStyle: TextStyle(color: Colors.black),
                              initialValue: number,
                              textFieldController: controller,
                              formatInput: false,
                              hintText: '799581989',
                              keyboardType:
                              TextInputType.numberWithOptions(signed: true, decimal: true),
                              inputBorder: OutlineInputBorder(),
                              onSaved: (PhoneNumber number) {
                                setState(() {
                                  phone = number.phoneNumber;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 40,
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
                              if (_editProfileKey.currentState!.validate()) {

                                submit();
                              } else {}
                            },
                            child: Text(
                              'Submit',
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
              ));
        },
      ),
    );
  }
}
