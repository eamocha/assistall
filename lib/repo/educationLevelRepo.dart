import 'dart:convert';

import 'package:agora_flutter_quickstart/models/educationLevel.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:http/http.dart' as http;
class EducationLevelRepo{

  final _api=ApiBase();


  Future<EducationLevelResponse> getEducationLevels() async{

    var finalUrl = encodeUrl('authenticate/education_levels', params: {});
    var fineUrl=Uri.parse(_api.baseUrl+finalUrl);
    var response= await http.get(fineUrl ,
        headers: {

        });

    var jsonResponse=json.decode(response.body);


    return EducationLevelResponse.fromJson(jsonResponse);

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