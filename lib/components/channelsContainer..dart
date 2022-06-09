import 'package:agora_flutter_quickstart/components/rateDialog.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

Container channelsContainer(String channel_name, String interpreterName, String amount,
    String rating, String duration, String image, BuildContext context,String time,bool isReservation) {
  return Container(
    padding: EdgeInsets.all(2),
    color: Colors.white,
    margin: EdgeInsets.only(bottom: 0,top: 2),
    child: ListTile(
      dense: true,
      leading: CircleAvatar(
        backgroundColor: Colors.white,
        child: Center(
          child: Icon(Icons.call,color: Theme.of(context).accentColor,),
        ),
      ),
      title: Text('Call ID : $channel_name',style: TextStyle(fontWeight:FontWeight.w600),),
      trailing: Icon(Icons.arrow_forward_ios,size: 15,),
      onTap: (){
        showModalBottomSheet(
            context: context,
            builder: (BuildContext context) {
          return Container(
            child: Wrap(
              alignment: WrapAlignment.center,
              children: [
                ListTile(
                  dense: true,
                  title: Text( interpreterName),
                ),
                ListTile(
                  dense: true,
                  title: Text('Call Duration',style: TextStyle(fontWeight: FontWeight.w700),),
                  subtitle: Text( duration+' seconds'),
                ),
                ListTile(
                  dense: true,
                  title: Text('Time',style: TextStyle(fontWeight: FontWeight.w700),),
                  subtitle: Text('$time',style: TextStyle(fontWeight:FontWeight.w600),)
                ),
                ListTile(
                  dense: true,
                  title: Text('Amount Charged',style: TextStyle(fontWeight: FontWeight.w700),),
                  subtitle: Text('KES '+amount),
                ),
                Container(
                  padding: EdgeInsets.only(bottom: 10),
                  child: isReservation ? Ui.primaryButton(
                      title: 'JOIN CALL',
                      onTap: (){

                      },
                      context: context):SizedBox(height: 0,width: 0,)
                )


              ],
            ),
          );
        });
      },
      subtitle: Text('Amount : KES $amount'),
      
    ),
  );
}
