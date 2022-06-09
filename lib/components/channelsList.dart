import 'dart:convert';

import 'package:agora_flutter_quickstart/components/channelsContainer..dart';
import 'package:agora_flutter_quickstart/components/rateDialog.dart';
import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;

Container channelsListContainer(
  BuildContext context,
  List channelsList,
  bool isReservation
) {
  return Container(
    child: ListView.builder(
        itemCount: channelsList == null ? 0 : channelsList.length,
        itemBuilder: (context, index) {

          var created_at = DateTime.parse(channelsList[index].createdAt);
          var dur =  DateTime.now().difference(created_at);
          final times=DateTime.now().subtract(dur);

          return Container(
            child: Container(
              padding: EdgeInsets.all(2),
              margin: EdgeInsets.all(0),
              child: channelsContainer(
                channelsList[index].channelName,
                  channelsList[index].interpreterName,
                  channelsList[index].callAmount,
                  channelsList[index].rate,
                  channelsList[index].callDuration,
                  channelsList[index].interpreterName,
                  context,
                timeago.format(times),
                  isReservation
              ),
            ),
          );
        }),
  );
}
