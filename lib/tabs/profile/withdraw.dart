import 'dart:convert';
import 'dart:io';

import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:random_string/random_string.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class Withdraw extends StatefulWidget {

  @override
  _WithdrawState createState() => _WithdrawState();
}

class _WithdrawState extends State<Withdraw> {
  final _withdrawKey = GlobalKey<FormState>();
  var amountcontroller = TextEditingController();
  String? amount;
   String? phoneNumber;
  String phoneIsoCode = '+254';
  bool visible = false;
  String? confirmedNumber;
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'KEN';
  PhoneNumber number = PhoneNumber(isoCode: 'NG');
  String? username;
  String? balance;

  @override
  void initState() {
    super.initState();
    UserinterfaceUtils().getUserId().then((value) {
      fetchProfile(value);
    });
  }

  Future fetchProfile(String userId) async {
    var response = await http.get(
        Uri.parse(UserinterfaceUtils.BASE_URL + '/profile/$userId'),
        headers: {'Accept': 'application/json'});
    var jsonresponse = jsonDecode(response.body);
    setState(() {
      username = jsonresponse['user']['name'];
      balance = jsonresponse['user']['wallet_balance'].toString();
    });
  }

  void onPhoneNumberChange(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(number);
    setState(() {
      confirmedNumber = internationalizedPhoneNumber;
      phoneIsoCode = isoCode;
    });
  }

  // ignore: always_declare_return_types
  onValidPhoneNumber(
      String number, String internationalizedPhoneNumber, String isoCode) {
    print(internationalizedPhoneNumber);
    setState(() {
      visible = true;
      confirmedNumber = internationalizedPhoneNumber;
    });
  }

  Future withdraw() async {
    if (int.parse(balance!) <= int.parse(amount!)) {
      return showDialog(
          context: context,
          builder: (context) {
            return AlertDialog(
              content: Text('Insufficient funds please enter a lower amount'),
              actions: [
                FlatButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text('CANCEL'))
              ],
            );
          });
    } else {
      var pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Loading...');

      var response = await http.post(Uri.parse(UserinterfaceUtils.transferUrl),
          body: jsonEncode({
            'account_bank': 'MPS',
            'account_number': confirmedNumber.toString(),
            'amount': amount,
            'narration': 'New transfer',
            'currency': 'KES',
            'reference': randomAlphaNumeric(5).toString(),
            'beneficiary_name': username
          }),
          headers: {
            HttpHeaders.authorizationHeader:
                'Bearer ' + UserinterfaceUtils.secretkey,
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          });

      var jsonResponse = json.decode(response.body);

      if (jsonResponse['data'] == null) {
       pd.close();
       await UserinterfaceUtils()
           .errortoast(context, 'An error occured please try again');
      } else {
       pd.close();
       recordTransaction(
           jsonResponse['data']['status'],
           jsonResponse['data']['currency'],
           jsonResponse['data']['reference'],
           jsonResponse['data']['fee'].toString());
       await UserinterfaceUtils().successToast(context, 'Withdrawal successful');
      }
    }
  }

  // ignore: always_declare_return_types
  recordTransaction(
      String status, String currency, String reference, String fee) async {
    var preferences = await SharedPreferences.getInstance();
    var userId = preferences.getString('user_id');
    // ignore: omit_local_variable_types
    int amount_withdrawable = int.parse(amount!) + int.parse(fee);
    var response =
        await http.post(Uri.parse(UserinterfaceUtils.BASE_URL + '/withdraw'), body: {
      'user_id': userId,
      'currency': currency,
      'reference': reference,
      'amount': amount_withdrawable.toString(),
      'status': status
    }, headers: {
      'Accept': 'application/json'
    });
    var jsonResponse = json.decode(response.body);
    if (jsonResponse['withdraw'] != null) {
      await UserinterfaceUtils()
          .successToast(context, 'Amount withdrawn successfully');
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
          'Withdraw',
          style: GoogleFonts.ubuntuCondensed(color: Colors.white),
        ),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Form(
            key: _withdrawKey,
            child: ListView(
              children: [
                SizedBox(
                  height: 20,
                ),
                InternationalPhoneNumberInput(
                  onInputChanged: (PhoneNumber number) {
                    print(number.phoneNumber);
                  },
                  onInputValidated: (bool value) {
                    print(value);
                  },
                  selectorConfig: SelectorConfig(
                    selectorType: PhoneInputSelectorType.BOTTOM_SHEET,
                  ),
                  ignoreBlank: false,
                  autoValidateMode: AutovalidateMode.disabled,
                  selectorTextStyle: TextStyle(color: Colors.black),
                  initialValue: number,
                  textFieldController: controller,
                  formatInput: false,
                  keyboardType:
                  TextInputType.numberWithOptions(signed: true, decimal: true),
                  inputBorder: OutlineInputBorder(),
                  onSaved: (PhoneNumber number) {
                    print('On Saved: $number');
                  },
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
                        color: Colors.redAccent,
                        onPressed: () {
                          if (_withdrawKey.currentState!.validate()) {
                            withdraw();
                          } else {}
                        },
                        child: Text(
                          'Withdraw',
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
