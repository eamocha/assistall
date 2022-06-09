import 'dart:convert';
import 'dart:math';
import 'package:agora_flutter_quickstart/bloc/interpretersBloc.dart';
import 'package:agora_flutter_quickstart/components/interpreterContainer.dart';
import 'package:agora_flutter_quickstart/components/interpretersList.dart';
import 'package:agora_flutter_quickstart/repo/callRepo.dart';
import 'package:agora_flutter_quickstart/screens/chatScreen.dart';
import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:agora_flutter_quickstart/models/intconverter.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:permission_handler/permission_handler.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import '../config/config.dart';
import '../util/api_base.dart';

class Interpreters extends StatefulWidget {
  Interpreters();

  @override
  _InterpretersState createState() => _InterpretersState();
}

class _InterpretersState extends State<Interpreters> {
   String? userId,accessToken;
   String?  userName;
  List<InterpretersList> interpretersList = [];
  bool interpretersLoading = false;
  TextEditingController timeController=TextEditingController();
   TextEditingController durationController=TextEditingController();
   late FirebaseMessaging messaging= FirebaseMessaging.instance;
 final CallRepo _callRepo=CallRepo();
   final _scheduleCallKey = GlobalKey<FormState>();
   int? accountTypeId;
   double? accountBalance=0.00;
   static const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
   final Random _rnd = Random();
   final _apiBase=ApiBase();
   String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
       length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
   @override
  void initState() {
    super.initState();
    notification();
    interpretersBloc.getInterpreters();
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
       print('Phone data'+jsonResponse['user']['phone'].toString().substring(1));
       setState(() {
         accountTypeId=jsonResponse['user']['account_type_id'];
         accountBalance=double.parse(jsonResponse['user']['account']['balance'].toString());
         userName=jsonResponse['user']['name'].toString() + ' '+jsonResponse['user']['last_name'].toString() ;
       });
     } else {
       // If the server did not return a 200 OK response,
       // then throw an exception.
       throw Exception('Failed to load album');
     }
   }
  Future<String?> getAuthToken() async{
    var sharedPreferences=await  SharedPreferences.getInstance();

   return sharedPreferences.getString('accessToken');

  }


   @override
   void dispose() {
     super.dispose();
      _handleCameraAndMic(Permission.camera);
      _handleCameraAndMic(Permission.microphone);
   }







   Future onRefresh() async  {
   await interpretersBloc.getInterpreters();
  }


   Future joinalert(String title, String body, String channel) async {
     await showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             content: Text(
               body,
               style: GoogleFonts.quicksand(),
             ),
             title: Text(
               title,
               style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
             ),
             actions: <Widget>[
               TextButton(
                   onPressed: () {
                     FlutterRingtonePlayer.stop();
                     Navigator.pop(context);
                   },
                   child: Text(
                     'CANCEL',
                     style: GoogleFonts.quicksand(),
                   )),
               TextButton(
                   onPressed: () {

                   },
                   child: Text(
                     'OK',
                     style: GoogleFonts.quicksand(),
                   ))
             ],
           );
         });
   }

   Future ratingDialog(String channel) async {
     await showDialog(
         context: context,
         builder: (BuildContext context) {
           return RatingDialog(
             initialRating: 1.0,
             // your app's name?
             title: Text(
               'Rate Interpreter',
               textAlign: TextAlign.center,
               style: const TextStyle(
                 fontSize: 25,
                 fontWeight: FontWeight.bold,
               ),
             ),
             // encourage your user to leave a high rating?
             message: Text(
               'Rate the  quality of service delivered.',
               textAlign: TextAlign.center,
               style: const TextStyle(fontSize: 15),
             ),
             // your app's logo?
             submitButtonText: 'Submit',
             enableComment: false,
             showCloseButton: true,
             commentHint: 'Set your custom comment hint',
             onCancelled: () {
               Navigator.pop(context);
             },
             onSubmitted: (response) {
               print('rating: ${response.rating}, channel: $channel');

              rateCall(response.rating.toString(), channel);

             },
           );
         });
   }

   Future notification() async {
     FirebaseMessaging.onMessage.listen((event) {
       /*print('The message'+ event.toString());
       joinalert(
           event.notification!.title.toString(),
           event.notification!.body.toString(),
           event.data['channel'].toString());*/
     });
   }

   Future interpreterProfileDialog(String id, String name,String last_name, String country,String rating,String token,String speciality,String image) async {
     await showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             content: Wrap(
               crossAxisAlignment: WrapCrossAlignment.center,
               alignment: WrapAlignment.center,
               children: [
                 Container(
                   child:CircleAvatar(
                     backgroundColor: Theme.of(context).accentColor,
                     radius: 25,
                     child: GestureDetector(
                       child: image !=''?
                       CircleAvatar(
                         radius: 35,
                         backgroundImage: NetworkImage(_apiBase.profileImage+ image),
                       )
                           :
                       Center(
                         child: Text(
                           name.substring(0,1),
                           style: TextStyle(
                             color: Colors.white,
                               fontWeight: FontWeight.bold
                           ),
                         ),
                       ),
                     ),
                   ),
                 ),
                 Ui.verticalSpaceSmall(),
                 Text(name + '  '+ last_name),
                 Ui.verticalSpaceSmall(),

                 Row(
                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                   children: [
                     Column(
                       children: [
                         Text('Speciality',style: TextStyle(
                             fontWeight: FontWeight.bold
                         ),),
                         Ui.verticalSpaceSmall(),
                         Text(speciality,style: TextStyle(
                             fontWeight: FontWeight.normal
                         ),),
                       ],
                     ),
                     Column(
                       children: [
                         Text('Country',style: TextStyle(
                             fontWeight: FontWeight.bold
                         ),),
                         Ui.verticalSpaceSmall(),
                         Text(country,style: TextStyle(
                             fontWeight: FontWeight.normal
                         ),),
                       ],
                     ),
                     Column(
                       children: [
                         Text('Rating',style: TextStyle(
                             fontWeight: FontWeight.bold
                         ),),
                         Ui.verticalSpaceSmall(),
                         Text(rating,style: TextStyle(
                             fontWeight: FontWeight.normal
                         ),),
                       ],
                     ),
                   ],
                 )

               ],
             ),
             title: Text(
               'sli_profile',
               style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
             ).tr(),
             actions: <Widget>[
               Container(
                 child: accountBalance! > 0 ?TextButton(
                     onPressed: () async {

                     },
                     child: Text(
                       'call',
                       style: TextStyle(
                           fontWeight: FontWeight.bold
                       ),
                     ).tr()):SizedBox(
                   height: 0,
                     width: 0,
                 ),
               ),
               TextButton(

                   onPressed: () {

                     Navigator.pop(context);
                     reserveCallDialog(id, name, country, rating);
                   },
                   child: Text(
                     'reserve_call',
                     style: TextStyle(
                         fontWeight: FontWeight.bold
                     ),
                   ).tr()),
               Container(
                 child: accountTypeId==4?
           TextButton(
           onPressed: () {

           Navigator.pop(context);
           Navigator.push(context, MaterialPageRoute(builder: (context)=>ChatScreen(name,id)));
           },
           child: Text(
           'chat',
           style: TextStyle(
           fontWeight: FontWeight.bold
           ),
           ).tr())
                     :SizedBox(
                   height: 0,
                   width: 0,
                 ),
               ),
             ],
           );
         });
   }

   Future reserveCallDialog(String id, String name, String country,String rating) async {
     await showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             content: Form(
               key: _scheduleCallKey,
               child: Wrap(
               crossAxisAlignment: WrapCrossAlignment.center,
               alignment: WrapAlignment.center,
               children: [

                 ListTile(
                   leading: CircleAvatar(
                     radius: 26,
                     child: Text(
                       name.toString().substring(0, 1),
                       style: TextStyle(
                           fontWeight: FontWeight.w600, color: Colors.white),
                     ),
                   ),
                   title: Text(name),
                   subtitle: Text(country),
                 ),
                 Ui.verticalSpaceSmall(),
                 Row(
                   children: [

                     Flexible(child: TextFormField(
                       controller: timeController,
                       readOnly: true,
                       keyboardType: TextInputType.name,
                       style: TextStyle(fontFamily: 'Proxima Nova Reg', fontSize: 16),
                       decoration: InputDecoration(
                         border:  OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5.0),
                           borderSide: BorderSide(
                             color: Colors.grey,
                             width: 2.0,
                           ),
                         ),
                         hintText: 'Select Time',
                       ),
                       validator: (String? value) {
                         if (value!.isEmpty) {
                           return 'Please select time';
                         }
                         return null;
                       },
                       onTap: () async {
                         final result = await showTimePicker(
                             context: context,

                             initialTime: TimeOfDay.now(),

                             builder: (context, child) {
                               return MediaQuery(
                                   data: MediaQuery.of(context).copyWith(
                                     alwaysUse24HourFormat: false,
                                   ),
                                   child: child!);
                             });

                         setState(() {

                           var data = result!.format(context).toLowerCase();
                           String str;
                           var parts;
                           String? startPart;

                           int checkData;
                           str = data;
                           parts = str.split(':');
                           startPart = parts[0].trim();
                           checkData = int.parse(startPart!) ;
                           if(checkData > 9 ){
                             timeController.text = result.format(context).toLowerCase();
                           }else{
                             timeController.text = result.format(context).toLowerCase();
                           }
                         });
                       },
                     ),),
                     SizedBox(width: 10,),
                     Flexible(child: TextFormField(
                       controller: durationController,
                       keyboardType: TextInputType.number,
                       style: TextStyle(fontFamily: 'Proxima Nova Reg', fontSize: 16),
                       decoration: InputDecoration(
                         border:  OutlineInputBorder(
                           borderRadius: BorderRadius.circular(5.0),
                           borderSide: BorderSide(
                             color: Colors.grey,
                             width: 2.0,
                           ),
                         ),
                         hintText: 'Duration',
                       ),
                       validator: (String? value) {
                         if (value!.isEmpty) {
                           return 'Please enter duration';
                         }
                         return null;
                       },
                       onTap: () async {
                       },
                     ),)
                   ],
                 ),
                 Ui.verticalSpaceSmall(),
                 ElevatedButton(
                     onPressed: () {

                       if(_scheduleCallKey.currentState!.validate()){
                         Navigator.pop(context);
                         reserveCall(id);
                       }
                       else{

                       }

                     },
                     child: Text(
                       'reserve_call',
                       style: TextStyle(
                           fontWeight: FontWeight.bold
                       ),
                     ).tr()),

               ],
             )),
             title: Text(
               'RESERVE SLI',
               style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
             ),
             actions: <Widget>[



             ],
           );
         });
   }

   Widget _interpretersStreamBuilder(){
     return  StreamBuilder(
         stream: interpretersBloc.subject.stream,
         builder: (context, AsyncSnapshot<InterpretersResponse> snapshot ){

           if(snapshot.hasData){

             return CustomScrollView(
               slivers: [
                 SliverList(
                   delegate: SliverChildBuilderDelegate(
                         (BuildContext context, int index) {
                       return GestureDetector(
                         onTap: (){

                           interpreterProfileDialog(snapshot.data!.interpreters[index].id,
                               snapshot.data!.interpreters[index].name,
                               snapshot.data!.interpreters[index].last_name,
                               snapshot.data!.interpreters[index].location,
                               snapshot.data!.interpreters[index].rate.toString(),
                               snapshot.data!.interpreters[index].device.toString(),
                               snapshot.data!.interpreters[index].speciality.toString(),
                             snapshot.data!.interpreters[index].profileImage.toString()
                           );
                         },
                         child: interpreterContainer(
                           snapshot.data!.interpreters[index].name,
                           snapshot.data!.interpreters[index].last_name,
                           snapshot.data!.interpreters[index].location,
                           snapshot.data!.interpreters[index].rate,
                           context,
                           snapshot.data!.interpreters[index].profileImage.toString(),
                         ),
                       );
                     },
                     childCount: snapshot.data!.interpreters.length, // 1000 list items
                   ),
                 ),
               ],
             );

           }
           else if(snapshot.data ==null){
             return  Center(
               child: Text('No Interpreters found'),
             );
           }
           else{

             return Center(
               child: CircularProgressIndicator(),
             );

           }

         });
   }

   Future reserveCall(String id) async{
     var pd = ProgressDialog(context: context);
     pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);

     var channel=getRandomString(6);

     double duration=int.parse(durationController.text.toString()) * 60;

     var params={
       'reservation_time':durationController.text,
       'name':channel,
       'description':'Call reservation',
       'interpreter_id':id,
       'duration':duration.toString()
     };

     await _callRepo.scheduleCall(params).then((value) async {
       pd.close();
       if(value.status){
         durationController.clear();
         timeController.clear();
         await Ui().successToast(value.message);
       }
       else{
         await Ui().errorToast(value.message);
       }
     });

   }

   Future rateCall(String rate,String channel) async{
     var pd = ProgressDialog(context: context);
     pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);

     var channel=getRandomString(6);

     var params={

       'name':channel,
       'rate':rate,
     };

     await _callRepo.rateCall(params).then((value) async {
       pd.close();
       if(value.status){
         await Ui().successToast(value.message);
       }
       else{
         await Ui().errorToast(value.message);
       }
     });

   }

   Future recordCallLog(String id,String channel) async{
     var pd = ProgressDialog(context: context);
     pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);

     var params={
       'name':channel,
       'description':channel,
       'interpreter_id':id,
     };

     await _callRepo.recordCallLog(params).then((value) async {
       pd.close();
       if(value.status){
         durationController.clear();
         timeController.clear();
         await Ui().successToast(value.message);
       }
       else{
         await Ui().errorToast(value.message);
       }
     });

   }

   Future<void> _handleCameraAndMic(Permission permission) async {
     final status = await permission.request();
     print('This is the microphone and camera status'+status.toString());
   }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:_interpretersStreamBuilder() ,
    );
  }
}
