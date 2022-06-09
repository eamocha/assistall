import 'package:agora_flutter_quickstart/models/user.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:rxdart/rxdart.dart';

final userBloc=UserBloc();

class UserBloc{
  final AuthRepo _authRepo=AuthRepo();

  final BehaviorSubject<User> _user=BehaviorSubject<User>();

  myProfile() async{
    var response=await _authRepo.myProfile();
    _user.sink.add(response);
  }

  dispose(){
    _user.close();
  }


  BehaviorSubject<User> get subject=>_user;
}