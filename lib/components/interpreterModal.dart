import 'dart:convert';
import 'dart:math';
import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:random_string/random_string.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';



class InterpreterModalContainer extends StatelessWidget {

  final String name;
  final String location;
  final String accountType;
  final String rate;
  final BuildContext context;
  final String accessToken;
  final String device;
  final String interpreterId;

  const InterpreterModalContainer( this.name, this.location, this.accountType, this.rate, this.context, this.accessToken, this.device, this.interpreterId);


  Future createChannel() async{
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...');

    var response=await  http.post(Uri.parse(UserinterfaceUtils.BASE_URL + '/user/channels'),
        body: {
          'name':randomAlphaNumeric(10),
          'description':randomAlphaNumeric(10),
          'interpreter_id':'$interpreterId'
        },
        headers: {
          'Authorization':'Bearer '+ accessToken,
          'Accept': 'application/json'
        });
    var jsonResponse=json.decode(response.body);


    if(jsonResponse['channel'] !=null){
      var random = Random();
      var channelName= random.nextInt(100000).toString();

      pd.close();
      await mic();
       await UserinterfaceUtils().sendAndRetrieveMessage(
           channelName, device);
      await UserinterfaceUtils().successToast(
          context, 'Call initiated successfully please wait for');

    }

  }

  Future<void> mic() async {
    await Permission.microphone.request();
    await cam();
  }

  Future<void> cam() async {
    await Permission.camera.request();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Wrap(
        alignment: WrapAlignment.center,
        children: [
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Center(
                child: Icon(
                  Icons.person,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              'Interpreters name',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(name),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Center(
                child: Icon(
                  Icons.location_on,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              'Interpreters location',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(location),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundColor: Theme.of(context).accentColor,
              child: Center(
                child: Icon(
                  Icons.local_activity,
                  color: Colors.white,
                ),
              ),
            ),
            title: Text(
              'Interpreters rating',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(rate),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ConstrainedBox(
              constraints: BoxConstraints.tightFor(width: 300, height: 50),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    primary: Theme.of(context).accentColor),
                onPressed: ()  async {

                 await createChannel();

                },
                child: Text(
                  'CALL',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}




