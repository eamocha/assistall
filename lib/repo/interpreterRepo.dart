import 'package:agora_flutter_quickstart/models/intconverter.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';

class InterpreterRepo{
  late InterpretersList _interpretersList;
  final _api=ApiBase();

  Future<String> getAuthHeader() async{

    var auth=AuthRepo();

    var accessToken =auth.getToken();

    return  accessToken;

  }
}