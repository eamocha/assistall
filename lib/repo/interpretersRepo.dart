import 'dart:convert';

import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/intconverter.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:http/http.dart' as http;
import 'authRepo.dart';

class InterpretersRepo{
  final _api=ApiBase();

  Future<String> getAuthHeader() async{

    var auth=AuthRepo();

    var accessToken =auth.getToken();

    return  accessToken;

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

  Future<InterpretersResponse> getInterpreters() async{

    var finalUrl = encodeUrl('user/interpreters', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.get(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    print('The json response' + response.body);

    var jsonResponse=json.decode(response.body);



    return InterpretersResponse.fromJson(jsonResponse);

  }

}