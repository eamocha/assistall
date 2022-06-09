import 'package:agora_flutter_quickstart/auth/signin.dart';
import 'package:agora_flutter_quickstart/screens/selectlanguage.dart';
import 'package:agora_flutter_quickstart/tabs/callScreen/callScreen.dart';
import 'package:agora_flutter_quickstart/tabs/complaint/complaint.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Help extends StatefulWidget {
  const Help({Key? key}) : super(key: key);

  @override
  _HelpState createState() => _HelpState();
}

class _HelpState extends State<Help> {
  Future signOut() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Confirm to sign out'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL')),
              TextButton(
                  onPressed: () async {
                    var preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          Container(
            child: ListTile(
              dense: true,
              title: Text(
                'faq',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ).tr(),
              onTap: () {
              },
            ),
          ),
          Container(
            child: ListTile(
              dense: true,
              title: Text(
                'file_c',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ).tr(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>SubmitComplaint()));
              },
            ),
          ),
          Container(
            child: ListTile(
              dense: true,
              title: Text(
                'customer_c',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ).tr(),
              onTap: () {
              },
            ),
          ),
          Container(
            child: ListTile(
              dense: true,
              title: Text(
                'more',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ).tr(),
              onTap: () {
              },
            ),
          ),
          Container(
            child: ListTile(
              dense: true,
              title: Text(
                'language',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ).tr(),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ChangeLanguage()));

              },
            ),
          ),
          Container(
            child: ListTile(
              dense: true,
              title: Text(
                'sign_out',
                style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
              ).tr(),
              onTap: () {
                signOut();
              },
            ),
          ),
        ],
      ),
    );
  }
}
