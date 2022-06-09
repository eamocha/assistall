import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:flutter/material.dart';

Container interpreterContainer(String name,String last_name, String location, String rating,
     BuildContext context,String image) {
  final _apiBase=ApiBase();
  print('The image'+ image+ "Of" + name);
  return Container(
    padding: EdgeInsets.all(20),
    color: Colors.white,
    margin: EdgeInsets.only(bottom: 5,top:0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          child:CircleAvatar(
            backgroundColor: Colors.white,
            radius: 20,
            child: GestureDetector(
              child: image !=''?
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(_apiBase.profileImage+ image,),
                  )
                  :
              Center(
                child: Text(
                  name.substring(0,1),
                  style: TextStyle(
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          width: 20,
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              child: Text(
                name + ' ' + last_name,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(location)
                    ],
                  ),
                ),
                SizedBox(
                  width: 50,
                ),
                Container(
                  child: Row(
                    children: [
                      Icon(
                        Icons.local_activity,
                        size: 14,
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(rating)
                    ],
                  ),
                )
              ],
            )
          ],
        ))
      ],
    ),
  );
}
