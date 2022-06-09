import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'dart:math';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:path/path.dart' as p;
import 'package:agora_flutter_quickstart/auth/signin.dart';
import 'package:agora_flutter_quickstart/bloc/educationLevelBloc.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:country_picker/country_picker.dart';
import 'package:dio/dio.dart';
import 'package:email_validator/email_validator.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:path/path.dart' as path;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SignUp extends StatefulWidget {

  final String country,accountType;
  SignUp(this.country,this.accountType);

  @override
  _SignUpState createState() => _SignUpState(country,accountType);
}

class _SignUpState extends State<SignUp> {
  final String country,accountType;
  _SignUpState(this.country,this.accountType);
   String? email, password, confirm, name,lastName,
       account_type,
       location,
       contact_person='';
   String? device;
  String? phone;
  final _apiBase=ApiBase();
  String gender='sg';
  String educationLevel='select_edu';
  String? selectedLevel;
  String? selectedGender;
  final signUpKey = GlobalKey<FormState>();
   File? certificate;
  final  AuthRepo _authRepo=AuthRepo();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'KEN';
  PhoneNumber number = PhoneNumber(isoCode: 'KE');
   late FirebaseMessaging messaging= FirebaseMessaging.instance;
   Country? _selected;
   List<dynamic>? accountTypesList ;
   bool? pickedFile=false;
  @override
  void initState() {
    super.initState();
    EducationLevelBloc().getEducationLevels();
    setState(() {
      account_type=accountType;
      location=country;
    });
    messaging.getToken().then((value){
      setState(() {
        device = value;
      });
    });
  }


  Future pickCertificate() async{
    var result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if(result != null) {

      setState(() {

        pickedFile=true;

        certificate = File(result.files.single.path.toString());

      });
    } else {
      pickedFile=false;
      // User canceled the picker
    }
  }

  Future fetchAccountsTypes() async {
    var response = await http.get(
        Uri.parse(UserinterfaceUtils.BASE_URL + '/account_types'),
        headers: {'Accept': 'application/json'});
    var jsonResponse = json.decode(response.body);

    print('Json response'+jsonResponse['accounts'].toString());
    setState(() {
      accountTypesList = jsonResponse['accounts'];
    });
  }

  Future validate() async {
      var pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);

      if(accountType!='3'){
        print("object hello" + phone! );
        var formData = {
          'name': name,
          'email': email,
          'password': password,
          'last_name':lastName,
          'account_type': accountType.toString(),
          'confirm_password':'confirm',
          'device': 'device',
          'phone':phone.toString(),
          'country': country,
          'education_level':1.toString(),
          'gender':1.toString(),
        };


        await _authRepo.register(formData).then((value){


          pd.close();

          if(value.status){

            Ui().successToast('Registration successfully');

            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));


          }
          else{

            Ui().errorToast(value.message);
          }
        });

      }

      else{
        Response response;
        var dio = Dio();
        var formData = FormData.fromMap({
          'name': name,
          'email': email,
          'password': password,
          'account_type': account_type,
          'confirm_password':confirm,
          'device': 'device',
          'phone':phone,
          'country': location,
          'contact_person':contact_person,
          'attachments': await MultipartFile.fromFile(certificate!.path.toString(),
              filename: p.basename(certificate!.path))
        });
        response = await dio.post( _apiBase.baseUrl+'authenticate/register', data: formData,options: Options(

        ));

        print('The corporate response is here'+response.data.toString());

        print('The status' + response.data['status'].toString());

        pd.close();

        if(response.data['status']){

         await Ui().successToast('Registration successfully');

         await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>SignIn()));

        }
        else{
          await Ui().errorToast('Registration failed');

        }


      }

    }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'register_for_account',
          style: GoogleFonts.quicksand(color: Colors.white),
        ).tr(),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 0),
        child: Form(
            key: signUpKey,
            child: ListView(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.all(2),
                  padding: EdgeInsets.all(20),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              name = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Name';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label:  accountType!='3' ? Text('first_name',style: TextStyle(color: Colors.black),).tr()
                            :Text('company_name',style: TextStyle(color: Colors.black),).tr(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: accountType!='3' ? TextFormField(
                          keyboardType: TextInputType.text,
                          onChanged: (value) {
                            setState(() {
                              lastName = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Last Name';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label:Text('last_name',style: TextStyle(color: Colors.black),).tr(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ):SizedBox(
                          height: 0,
                          width: 0,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            setState(() {
                              email = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Email';
                            } else if (!EmailValidator.validate(value)) {
                              return 'Invalid email';
                            } else {
                              return null;
                            }
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

                      Container(
                        child: accountType!='3' && accountType!='4'?
                        DropdownButtonFormField<String>(
                          value: educationLevel,
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              educationLevel=newValue.toString();
                              if(newValue.toString()=='Primary'){
                                selectedLevel='1';
                              }
                              else if(newValue.toString()=='Secondary'){
                                selectedLevel='2';
                              }
                              else if(newValue.toString()=='College'){
                                selectedLevel='3';
                              }
                              else if(newValue.toString()=='University Degree'){
                                selectedLevel='3';
                              }
                              else if(newValue.toString()=='Post Graduate Degree'){
                                selectedLevel='4';
                              }
                            });
                          },
                          items: <String>[
                            'select_edu',
                            'primary',
                            'secondary',
                            'college',
                            'university_degree',
                            'pg'
                          ]
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value).tr(),
                            );
                          }).toList(),
                        ):
                        Container(
                          child: accountType=='3'?TextFormField(
                            keyboardType: TextInputType.text,
                            onChanged: (value) {
                              setState(() {
                                contact_person = value;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Enter contact person name';
                              }  else {
                                return null;
                              }
                            },
                            decoration: InputDecoration(
                              label: Text('contact_person',style: TextStyle(color: Colors.black),).tr(),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: Colors.black12, width: 1.0),
                              ),
                            ),
                          ):SizedBox(
                            height: 0,
                            width: 0,
                          ),
                        ),
                      ),

                      SizedBox(
                        height: 10,
                      ),

                      Container(
                        child: accountType!='3'? DropdownButtonFormField<String>(
                          value: gender,
                          iconSize: 24,
                          elevation: 16,
                          isExpanded: true,
                          decoration: InputDecoration(
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                          onChanged: (String? newValue) {
                            setState(() {
                              gender=newValue.toString();
                              if(newValue.toString()=='Male'){
                                 selectedGender='1';
                              }
                              else{
                                 selectedGender='2';
                              }
                            });
                          },
                          items: <String>['sg', 'male', 'female','pns']
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value).tr(),
                            );
                          }).toList(),
                        ):Container(
                          decoration: BoxDecoration(
                            borderRadius:BorderRadius.circular(2) ,
                            border: Border.all(
                              color: Colors.grey,  // red as border color
                            ),
                          ),
                          child: ListTile(
                            title: Text('reg_cert').tr(),
                            subtitle: Text(!pickedFile! ? 'Not Picked':'Picked'),
                            onTap: (){
                              pickCertificate();
                            },
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              password = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter password';
                            } else if (value.toString().length < 8) {
                              return 'Password must be a minimum of 8 characters';
                            } else {
                              return null;
                            }
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
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          obscureText: true,
                          onChanged: (value) {
                            setState(() {
                              confirm = value;
                            });
                          },
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Confirm password';
                            } else if (value.toString().length < 8) {
                              return 'Password must be a minimum of 8 characters';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('confirm_pass',style: TextStyle(color: Colors.black),).tr(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 0,
                ),
                Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: ButtonTheme(
                    height: 50,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (signUpKey.currentState!.validate()) {
                            validate();
                          } else {}
                        },
                        child: Text(
                          'sign_up',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ).tr()),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
              ],
            )),
      ),
    );
  }
}
