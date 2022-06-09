import 'dart:convert';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
class ApiBase{

  String baseUrl;
  String profileImage;


  ApiBase({this.baseUrl='https://assistallbackend.signmediake.com.assistallapp.com/api/',this.profileImage='https://assistallbackend.signmediake.com.assistallapp.com/profile/'});


  Future<String> getAuthHeader() async{

    var auth=AuthRepo();

    var accessToken =auth.getToken();

    return  accessToken;

  }


  Future get(String url, {required Map params}) async {

    var finalUrl = encodeUrl(url, params: params);
    var fineUrl=Uri.parse(baseUrl+finalUrl);
    var response= await http.get(fineUrl ,
        headers: {
          'Authorization': 'Bearer '+ Config.get('accessToken')

        });

    var responseJson=_returnResponse(response);


    return responseJson;

  }


  post(String url, params) async {
    final response = await http.post(Uri.parse(baseUrl+ url),
        body: params ,
        headers: {
          'Accept':'application/json',
        });

    print('The response'+response.body);

    var jsonResponse=json.decode(response.body);

    return jsonResponse;

  }

  authPost(String url, params) async {
    final response = await http.post(Uri.parse(baseUrl+ url),
        body: params ,
        headers: {
          'Authorization': 'Bearer '+ await getAuthHeader(),
          'Accept':'application/json',
        });

    var jsonResponse=json.decode(response.body);

    return jsonResponse;

  }


  String encodeUrl(String url, {required Map<dynamic, dynamic> params, String prefix: '&'}) {

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


  Future<dynamic> upload(String url, {  required FormData formData }) async {

    var dio = Dio();

    var response = await dio.post(baseUrl+ url, data: formData);

    return response.data;


  }


  dynamic _returnResponse(http.Response response){

  }





}