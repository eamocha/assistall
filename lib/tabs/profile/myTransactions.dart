import 'dart:convert';

import 'package:agora_flutter_quickstart/bloc/userBloc.dart';
import 'package:agora_flutter_quickstart/models/user.dart';
import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class MyTransactions extends StatefulWidget {


  @override
  _MyTransactionsState createState() => _MyTransactionsState();
}

class _MyTransactionsState extends State<MyTransactions> {
  @override
  void initState() {
    super.initState();
    userBloc.myProfile();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'my_trans',
          style: GoogleFonts.quicksand(color: Colors.white),
        ).tr(),
      ),
      body: Padding(
        padding: EdgeInsets.all(5),
        child: StreamBuilder(
            stream: userBloc.subject.stream,
            builder: (context,AsyncSnapshot<User> snapshot){
              if(snapshot.hasData){
                return ListView.separated(
                  separatorBuilder: (context,index){
                    return Divider();
                  },
                  itemCount: snapshot.data!.account.ledgers.length,
                    itemBuilder: (context,index){
                     return Container(
                       margin: EdgeInsets.all(2),
                       child: ListTile(
                         dense: true,
                         leading: CircleAvatar(
                           radius: 25,
                           backgroundColor: snapshot.data!.account.ledgers[index].debit !=0 ?
                           Colors.green:Colors.red,
                           child: Center(
                             child:snapshot.data!.account.ledgers[index].debit !=0 ?
                                 Icon(Icons.arrow_upward,color: Colors.white,)
                                 :Icon(Icons.arrow_downward,color: Colors.white,),
                           ),
                         ),
                         title: Text(snapshot.data!.account.ledgers[index].description,
                           style: TextStyle(fontWeight: FontWeight.bold),),
                         subtitle: Text(DateTime.parse(snapshot.data!.account.ledgers[index].time.toString()).toString(),
                           style: TextStyle(fontWeight: FontWeight.bold),),
                         trailing: Text(snapshot.data!.account.ledgers[index].debit !=0?
                         'KES '+ snapshot.data!.account.ledgers[index].debit.toString():
                         'KES '+ snapshot.data!.account.ledgers[index].credit.toString(),
                           style: TextStyle(fontWeight: FontWeight.bold),),
                       ),
                     );
                    }
                );
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

            }),
      ),
    );
  }
}
