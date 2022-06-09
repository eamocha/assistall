import 'dart:convert';

import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/ApiResponse.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:http/http.dart' as http;
class PaymentRepo{
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

  Future<ApiResponse> deposit(Map<String,String> body) async{

    var finalUrl = encodeUrl('accountant/stkPush', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(
        fineUrl ,
        body: body,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    print('The json response profile' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }

  Future<String> cardDeposit(Map<String,String> body) async{

    var finalUrl = encodeUrl('user/pesaPal', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(
        fineUrl ,
        body: body,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    print('The json response profile' + response.body.toString());

    return response.body.toString();

  }
  Future<ApiResponse> withdraw(Map<String,String> body) async{

    var finalUrl = encodeUrl('accountant/withdraw', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(
        fineUrl ,
        body: body,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    print('The json response profile' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }

  Future<ApiResponse> payPalDeposit(Map<String,String> body) async{

    var finalUrl = encodeUrl('accountant/process-transaction', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.post(
        fineUrl ,
        body: body,
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    print('The json response profile' + response.body);

    var jsonResponse=json.decode(response.body);


    return ApiResponse.map(jsonResponse);

  }
}