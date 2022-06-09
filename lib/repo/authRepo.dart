import 'dart:convert';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/ApiResponse.dart';
import 'package:agora_flutter_quickstart/models/user.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';

class AuthRepo{

   late User _user;

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


  Future<String> getToken() {

    return  Config.get('accessToken');
  }

   Future<User> myProfile() async{

     var finalUrl = encodeUrl('user/profile', params: {});
     var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
     var response= await http.get(fineUrl ,
         headers: {
           'Authorization': 'Bearer '+ await Config.get('accessToken')

         });

     print('The json response profile' + response.body);

     var jsonResponse=json.decode(response.body);


     return User.fromJson(jsonResponse['user']);

   }


   Future<ApiResponse> updateProfile(Map<String,String?> params) async{

     var finalUrl = encodeUrl('profile/edit-profile', params: {});
     var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
     var response= await http.post(fineUrl ,body: params,
         headers: {
           'Authorization': 'Bearer '+ await Config.get('accessToken')
         });

     print('The json response profile' + response.body);

     var jsonResponse=json.decode(response.body);


     return ApiResponse.map(jsonResponse);

   }

   Future<ApiResponse> sendOTP(Map<String,String> params) async{
    var response=await _api.post('authenticate/sendOTP', params);
    print('This is the response'+response.toString());

   
    return ApiResponse.map(response);
  }

   Future<ApiResponse> checkIfUserExist(Map<String,String> params) async{
     var response=await _api.post('authenticate/checkIfUserExist', params);
     print('This is the response'+response.toString());

     return ApiResponse.map(response);
   }

  Future<bool> validateOTP(Map<String,String> params) async{
    var response=await _api.post('authenticate/verifyOTP', params);
    if(response['status']) return true;
    return false;

  }

  Future<String?> forgotRequest(Map<String,String> params) async{
    var response=await _api.post('authenticate/forgotRequest', params);
    if(response['status']) return response['data']['id'].toString();
    return null;
  }

  Future<bool> resetPassword(Map<String,String> params) async{
    var response=await _api.authPost('user/resetPassword', params);

    if(response['status']) return true;
    return false;
  }

  Future<bool> resetPassword2(Map<String,String> params) async{
    var response=await _api.post('authenticate/resetPassword', params);
    if(response['status']) return true;
    return false;
  }


   Future<ApiResponse> registerInterpreter(FormData formData) async{
     return _api.upload('authenticate/register',
         formData: formData).then((value){
           return ApiResponse.map(value);
     });
   }

  Future<RegistrationResponse> register(params) async{

    var response=await _api.post('authenticate/register', params);

    return RegistrationResponse.map(response);


  }

  Future<ApiResponse> login(Map<String,String?> params) async{
    var response=await _api.post('authenticate/login', params);

    return ApiResponse.map(response);
  }
   Future<ApiResponse> googleSignIn(Map<String,String?> params) async{
     var response=await _api.post('authenticate/googleSignIn', params);

     return ApiResponse.map(response);
   }




}