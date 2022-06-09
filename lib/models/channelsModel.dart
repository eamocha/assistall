class ChannelsModel {
  late String createdAt;
  late String channelId;
  late String callDuration;
  late String channelName;
  late String interpreterName;
  late String interpreterId;
  late String callAmount;
  late String rate;
  late int is_rated;

  ChannelsModel(
      { required this.createdAt,
       required this.channelId,
       required this.callDuration,
       required this.interpreterName,
       required this.interpreterId,
       required this.callAmount,
       required this.rate,
         required this.channelName,
         required this.is_rated,
      });
  factory ChannelsModel.fromJson(Map json) {
    return ChannelsModel(
        interpreterName:json['user'] !=null? json['user']['name']:json['interpreter']['name'],
        interpreterId: json['interpreter_id'].toString(),
        createdAt: json['created_at'],
        channelName: json['channel_name'],
        channelId: json['id'].toString(),
        callDuration: json['duration'].toString(),
        callAmount: json['amount'].toString(),
        rate: json['rate'].toString(),
        is_rated:json['is_rated']
        );
  }
}
