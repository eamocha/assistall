import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:agora_flutter_quickstart/components/channelsList.dart';
import 'package:agora_flutter_quickstart/models/channelsModel.dart';
import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CallReservations extends StatefulWidget {
  const CallReservations({Key? key}) : super(key: key);

  @override
  _CallReservationsState createState() => _CallReservationsState();
}

class _CallReservationsState extends State<CallReservations> {
  String? userId,accessToken;
  List<ChannelsModel> channelsList = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    getAuthToken().then((value){

      userChannels(value!);
      setState(() {
        accessToken=value;
      });
    });

  }

  Future<String?> getAuthToken() async{
    var sharedPreferences=await  SharedPreferences.getInstance();

    return sharedPreferences.getString('accessToken');


  }


  Future userChannels(String value) async {
    print('Hello');
    setState(() {
      loading = true;
    });



    var response = await http.get(
        Uri.parse(UserinterfaceUtils.BASE_URL + 'user/reservations'),
        headers: {
          'Authorization':'Bearer '+ value,
          'Accept': 'application/json'
        });

    var jsonResponse = jsonDecode(response.body);
    print('This is the response'+jsonResponse.toString());

    var list = jsonResponse['channels']
        .map((m) => ChannelsModel.fromJson(m))
        .toList();
    addChannelsToList(list);
  }

  // ignore: always_declare_return_types
  addChannelsToList(var list) {
    channelsList.clear();
    list.forEach((item) {
      setState(() {
        channelsList.add(item);
        loading = false;
      });
    });
  }

  // ignore: always_declare_return_types
  onRefresh() {
    userChannels(accessToken!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('reserve').tr(),
      ),
      body: loading
          ? Container(
        child: channelsList.isEmpty
            ? Center(
          child: Text(
            'No Reservations found',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 25),
          ),
        )
            : Container(
          padding:
          EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Shimmer.fromColors(
            baseColor: Colors.grey,
            highlightColor: Colors.grey,
            enabled: true,
            child: ListView.builder(
              itemBuilder: (_, __) => Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 48.0,
                      height: 48.0,
                      color: Colors.white,
                    ),
                    const Padding(
                      padding:
                      EdgeInsets.symmetric(horizontal: 8.0),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: double.infinity,
                            height: 8.0,
                            color: Colors.white,
                          ),
                          const Padding(
                            padding:
                            EdgeInsets.symmetric(vertical: 2.0),
                          ),
                          Container(
                            width: 40.0,
                            height: 8.0,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              itemCount: 15,
            ),
          ),
        ),
       )
          : Container(
        child: channelsListContainer(context, channelsList,true),
      ),
    );
  }
}

