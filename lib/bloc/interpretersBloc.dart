import 'package:agora_flutter_quickstart/models/intconverter.dart';
import 'package:agora_flutter_quickstart/repo/interpretersRepo.dart';
import 'package:rxdart/rxdart.dart';

final interpretersBloc=InterpretersBloc();
class InterpretersBloc{
  final InterpretersRepo _interpretersRepo=InterpretersRepo();

  final BehaviorSubject<InterpretersResponse> _interpreters=BehaviorSubject<InterpretersResponse>();

  getInterpreters() async{
    var response=await _interpretersRepo.getInterpreters();
    _interpreters.sink.add(response);
  }

  dispose(){

    _interpreters.close();
  }


  BehaviorSubject<InterpretersResponse> get subject=>_interpreters;

}