import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserinterfaceUtils {
  static const String BASE_URL = 'https://assistallbackend.signmediake.com.assistallapp.com/api/';
  static const String token =
      'AAAAfkj2xVM:APA91bHqgoDcStprO5F7mGxl7aDXH2bUZxo3Jvhf5MybGBUmlbR8e9lEMFi1_3yeTpmnT9wdhCXpbUys66shOYkhJoNdWnfBhLeZ0gDQm0rVO9C1ZRHH-8DeXL5BwX8f-KrjyQSweAmZ';
  // final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  static const String publicKey =
      'FLWPUBK_TEST-2f4f639946d4806227b4813fde0c20cf-X';
  static const String encryptionKey = 'FLWSECK_TESTab0e63b35417';
  static const String secretkey =
      'FLWSECK_TEST-154e1a6cf01949d11492efdadf94bac9-X';
  static const transferUrl = 'https://api.flutterwave.com/v3/transfers';


  Future getUserId() async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getString('user_id');
  }

  Future getAccountType() async {
    var preferences = await SharedPreferences.getInstance();
    return preferences.getString('account_type');
  }

  Future<Map<String, dynamic>?> sendAndRetrieveMessage(
      String channelName, String device) async {
    var random = Random();

    var response=await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': 'Interpreter required',
            'title': 'A user has requested for interpreter service'
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'msgId': random.nextInt(100000).toString(),
            'status': 'done',
            'channel': channelName,
          },
          'registration_ids': [device],
        },
      ),
    );

    var jsonResponse = jsonDecode(response.body);
    print('This is the request response' +jsonResponse.toString());

    return jsonResponse;
    
  }

  Future successToast(BuildContext context, String message) async {
    await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future errortoast(BuildContext context, String message) async {
    await Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }

  Future store_history(String user_id, String channel_id) async {
    var response =
        await http.post(Uri.parse(UserinterfaceUtils.BASE_URL + '/store_history'), body: {
      'user_id': user_id,
      'channel_id': channel_id,
    });

    var jsonResponse = json.decode(response.body);
  }

  Future<void> alertmessage(BuildContext context, String message) async {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message, style: GoogleFonts.quicksand()),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('OK', style: GoogleFonts.quicksand()))
            ],
          );
        },
        barrierDismissible: false);
  }
}
