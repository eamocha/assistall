import 'dart:convert';

import 'package:agora_flutter_quickstart/auth/signUpMain.dart';
import 'package:agora_flutter_quickstart/bloc/accountTypesBloc.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/accountType.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class SelectAccountType extends StatefulWidget {
   final String country;
   SelectAccountType(this.country);

  @override
  _SelectAccountTypeState createState() => _SelectAccountTypeState(country);
}

class _SelectAccountTypeState extends State<SelectAccountType> {
  String country;
  _SelectAccountTypeState(this.country);
  String? accountTypeSelected='2';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    accountTypesBloc.getAccountTypes();
  }

  Future navigateToSignUpMainPage() async{

    if(accountTypeSelected?.trim()?.isEmpty ?? true){
      await Ui().errorToast('Please select account type');
    }
    else{

      await Navigator.
      push(context, MaterialPageRoute(builder:
          (context)=>SignUpMainPage(country,accountTypeSelected!)));

    }

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar:Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.6, color: Colors.blueGrey),
          ),
          color: Colors.white,
        ),
        child:  Padding(
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
                        navigateToSignUpMainPage();
                      },
                      child: Text(
                        'next',
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
        child: StreamBuilder(
          stream: accountTypesBloc.subject.stream,
          builder: (context, AsyncSnapshot<AccountTypeResponse> snapshot){
            return Column(
              children: [
                Ui.verticalSpace(250),
                Center(
                  child: Text('assistALL',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).accentColor
                  ),),
                ),
                Ui.verticalSpaceSmall(),
                Center(
                  child: Text('account_type',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: Theme.of(context).accentColor
                    ),).tr(),
                ),

                Center(
                  child: Container(
                    padding: EdgeInsets.all(20),
                    child: DropdownButtonFormField(
                      value: accountTypeSelected,
                      isDense: true,
                      isExpanded: true,
                      onChanged: (valueSelectedByUser) {
                        setState(() {
                          accountTypeSelected=valueSelectedByUser.toString();
                        });
                        print(valueSelectedByUser.toString()+"The value");
                      },
                      validator: (value){
                        if(value.toString().trim().isEmpty){
                          return 'Please select Account Type';
                        }
                        return null;
                      },
                      hint: Text('Choose Account Type'),
                      decoration: InputDecoration(
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black12, width: 1.0),
                        ),
                      ),
                      items: snapshot.data!.accountType
                          ?.map((document) {
                        return DropdownMenuItem<String>(
                          value: document.id.toString(),
                          child: Text(document.name),
                        );
                      }).toList(),
                    ),
                  ),
                )
              ],
            );
          },
        ),

      ),
    );
  }
}
