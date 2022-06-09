import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/accountType.dart';
import 'package:agora_flutter_quickstart/repo/accountTypeRepo.dart';
import 'package:rxdart/rxdart.dart';

final AccountTypesBloc accountTypesBloc=AccountTypesBloc();

class AccountTypesBloc{
  final AccountTypeRepo _accountTypeRepo=AccountTypeRepo();
  final BehaviorSubject<AccountTypeResponse> _subject=BehaviorSubject<AccountTypeResponse>();

  getAccountTypes() async{

    var locale=await Config.get('locale');

    print('This is the locale'+locale.toString().substring(0,2));
    var response=await _accountTypeRepo.getAccountTypes(locale.toString().substring(0,2));

    _subject.sink.add(response);

  }

  dispose(){
    _subject.close();
  }

  BehaviorSubject<AccountTypeResponse> get subject => _subject;

}