import 'dart:convert';

import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Deposit extends StatefulWidget {

  @override
  _DepositState createState() => _DepositState();
}

class _DepositState extends State<Deposit> {
  final depositKey = GlobalKey<FormState>();
   String? phoneNumber;
   String? phoneIsoCode;
  bool visible = false;
   String? confirmedNumber, amount, username, email;
  TextEditingController amountcontroller = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    fetchProfile();
  }

  void fetchProfile() async {
    var preferences = await SharedPreferences.getInstance();
    var id = preferences.getString('user_id');
    var response = await http.get(
        Uri.parse(UserinterfaceUtils.BASE_URL + '/profile/' + id!),
        headers: {'Accept': 'application/json'});
    var jsonresponse = jsonDecode(response.body);

    print('This is the json response' + jsonresponse.toString());
    setState(() {
      username = jsonresponse['user']['name'];
      email = jsonresponse['user']['email'];
    });
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      phoneNumber = number;
      phoneIsoCode = isoCode;
    });
  }

  // ignore: always_declare_return_types
  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  void deposit() async {}

  // ignore: always_declare_return_types
  recordTransaction(String status, String currency, String tx_ref) async {
    var preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString('user_id');
    var response =
        await http.post(Uri.parse(UserinterfaceUtils.BASE_URL + '/deposit'), body: {
      'email': email,
      'user_id': userId,
      'currency': currency,
      'tx_ref': tx_ref,
      'amount': amount,
      'status': status
    }, headers: {
      'Accept': 'application/json'
    });
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['transaction'] != null) {
      await UserinterfaceUtils()
          .successToast(context, 'Amount deposited successfully');
      amountcontroller.clear();
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'Deposit',
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
            key: depositKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: amountcontroller,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter amount';
                    } else {
                      return null;
                    }
                  },
                  onChanged: (value) {
                    setState(() {
                      amount = value;
                    });
                  },
                  onSaved: (value) {
                    setState(() {
                      amount = value;
                    });
                  },
                  decoration: InputDecoration(
                    labelText: 'Amount',
                    labelStyle: TextStyle(color: Theme.of(context).accentColor),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                          color: Theme.of(context).accentColor, width: 0.5),
                    ),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey, width: 0.5),
                    ),
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                Container(
                  child: ButtonTheme(
                    height: 50,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (depositKey.currentState!.validate()) {
                            deposit();
                          } else {}
                        },
                        child: Text(
                          'Deposit',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
              ],
            )),
      ),
    );
  }
}
