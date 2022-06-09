import 'dart:convert';

import 'package:agora_flutter_quickstart/models/attachment.dart';
import 'package:http/http.dart' as http;
import '../config/config.dart';
import '../util/api_base.dart';

class AttachmentRepo{

  final _api=ApiBase();

  Future<AttachmentResponse> myAttachments() async{

    var finalUrl = encodeUrl('user/myAttachments', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.get(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);



    return AttachmentResponse.fromJson(jsonResponse);

  }

  Future<AttachmentResponse> myVideos() async{

    var finalUrl = encodeUrl('user/myVideos', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.get(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);



    return AttachmentResponse.fromJson(jsonResponse);

  }

  String encodeUrl(String url, {required Map<dynamic, dynamic> params, String prefix = '&'}) {

    var result = '';
    if(params != null){
      params.forEach( (k, v) {
        result += Uri.encodeFull('$k=$v&');
      });
    }

    if(url.contains('?')) {
      return '$url&$result';
    }

    return '$url?$result';
  }


}