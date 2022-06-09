
import 'package:agora_flutter_quickstart/models/educationLevel.dart';
import 'package:agora_flutter_quickstart/repo/educationLevelRepo.dart';
import 'package:rxdart/rxdart.dart';

final educationLevelBloc=EducationLevelBloc();

class EducationLevelBloc{

  final EducationLevelRepo _educationLevelRepo=EducationLevelRepo();

  final BehaviorSubject<EducationLevelResponse> _levels=BehaviorSubject<EducationLevelResponse>();


  getEducationLevels() async{
    var response=await _educationLevelRepo.getEducationLevels();
    _levels.sink.add(response);
  }

  dispose(){

    _levels.close();
  }


  BehaviorSubject<EducationLevelResponse> get subject=>_levels;

}