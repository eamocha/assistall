import 'dart:convert';

import 'package:agora_flutter_quickstart/bloc/userBloc.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/chat.dart';
import 'package:agora_flutter_quickstart/models/user.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_5.dart';
import 'package:http/http.dart' as http;
class ChatScreen extends StatefulWidget {
   final String name,receiverId;
   ChatScreen(this.name,this.receiverId);

  @override
  _ChatScreenState createState() => _ChatScreenState(name,receiverId);
}

class _ChatScreenState extends State<ChatScreen> {
  final String name,receiverId;
  _ChatScreenState(this.name,this.receiverId);
  final firestoreInstance = FirebaseFirestore.instance;
  TextEditingController chatTextController=TextEditingController();
  bool _isComposing=false;
  final _apiBase=ApiBase();
  String? myName;
  Future sendMessage(message)  async{
    await firestoreInstance.collection('messages').add(
        {
          'receiverName':name,
          'name' : myName,
          'message' : message,
          'time':DateTime.now()
        }).then((value){
    });
  }
  var moviesRef = FirebaseFirestore.instance
      .collection('messages')
      .withConverter<Chat>(
    fromFirestore: (snapshots, _) => Chat.fromJson(snapshots.data()!),
    toFirestore: (movie, _) => movie.toJson(),
  );

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
        myName=jsonResponse['user']['name'];
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc.myProfile();
    getProfile().then((value){
    });
  }

  Widget myMessage(String name,String message){
    return  Padding(padding: EdgeInsets.all(10),child: ChatBubble(
      clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
      alignment: Alignment.topRight,
      margin: EdgeInsets.only(top: 20),
      backGroundColor: Theme.of(context).accentColor,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        child: Text(
         message,
          style: TextStyle(color: Colors.white),
        ),
      ),
    ),);
  }

  Widget otherMessage(String name,String message){
    return Container(
      padding: EdgeInsets.only(left: 10,right: 10),
      child:ChatBubble(
        clipper: ChatBubbleClipper5(type: BubbleType.sendBubble),
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 10),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.7,
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.black),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat'),
      ),
      body: Column(
        children: [
          Expanded(child: Container(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance.collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot){
                if(snapshot.hasData){
                  return ListView.builder(
                      itemCount: snapshot!.data!.docs.length,
                      itemBuilder: (context,index){

                        if(snapshot.data!.docs[index]['name']== myName){
                         return myMessage(snapshot.data!.docs[index]['name'], snapshot.data!.docs[index]['message']);
                        }
                        else{
                         return otherMessage(snapshot.data!.docs[index]['name'], snapshot.data!.docs[index]['message']);
                        }

                      });
                }
                else{
                  return Center();

                }

              },

            ),
          )),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 0,vertical: 5),
            child: ListTile(
                title: TextField(
                  controller: chatTextController,
                  minLines: 1,
                  maxLines: 4,
                  decoration: InputDecoration(
                      hintText: 'Type message',
                      border: InputBorder.none),
                  onChanged: (text) {
                    setState(() {
                      _isComposing = text.isNotEmpty;
                    });
                  },
                ),
                trailing: IconButton(
                    icon: Icon(Icons.send,
                        color: _isComposing
                            ? Theme.of(context).primaryColor
                            : Colors.grey),
                    onPressed: _isComposing
                        ? () async {
                      /// Get text
                      final text = chatTextController.text.trim();

                      /// clear input text
                      chatTextController.clear();
                      setState(() {
                        _isComposing = false;
                      });

                      /// Send text message
                      await sendMessage(text);

                      /// Update scroll
                    }
                        : null)),
          )
        ],
      ),
    );
  }
}
