import 'dart:convert';

import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/ApiResponse.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:http/http.dart' as http;
class CallRepo{
  final _api=ApiBase();


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

  Future<ApiResponse> scheduleCall(Map<String,String?> params) async{

    var finalUrl = encodeUrl('user/reserve_call', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        },body: params);

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);



    return ApiResponse.map(jsonResponse);

  }

  Future<ApiResponse> recordCallLog(Map<String,String?> params) async{

    var finalUrl = encodeUrl('user/channels', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        },body: params);

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }

  Future<ApiResponse> recordCallTime(Map<String,String?> params) async{

    var finalUrl = encodeUrl('user/recordCallTime', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        },body: params);

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }

  Future<ApiResponse> joinCall(Map<String,String?> params) async{

    var finalUrl = encodeUrl('user/joinCall', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        },body: params);

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }

  Future<ApiResponse> endCall(Map<String,String?> params) async{

    var finalUrl = encodeUrl('user/endCall', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        },body: params);

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }

  Future<ApiResponse> rateCall(Map<String,String?> params) async{

    var finalUrl = encodeUrl('user/rateCall', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        },body: params);

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }

}