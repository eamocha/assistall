
import 'dart:convert';

class InterpretersResponse{

  List<InterpretersList> interpreters;

  bool status;

  InterpretersResponse(this.interpreters,this.status);

  InterpretersResponse.fromJson(Map<String, dynamic> json)
      :interpreters=(json['interpreters'] as List)
      .map((e) =>  InterpretersList.fromJson(e))
      .toList(),
        status=json['status'];


}


class InterpretersList {
  late String name;
  late String last_name='';
  late String account_type;
  late String location='Kenya';
  late String device='test';
  late String rate='0';
  late  String profileImage='default.jpeg';
  late String id;
  late String speciality='Interpreter';

  InterpretersList(
      {
         required this.id,
         required this.name,
         required this.last_name,
         required this.speciality,
         required this.account_type,
         required this.location,
         required this.device,
         required this.rate,
         required this.profileImage
      });

  InterpretersList.fromJson(Map<String,dynamic> json) {
    if(json['id'] !=null){
      id=json['id'].toString();
    }
    if(json['name'] !=null){
      name= json['name'];
    }
    if(json['last_name'] !=null){
      last_name=json['last_name'];
    }
    if(json['account_type_id'] !=null){
      account_type= json['account_type_id'].toString();
    }
    if(json['country'] !=null){
      location= json['country'];
    }
    if(json['device'] !=null){
      device= json['device'];
    }
    if(json['profile'] !=null){
      profileImage=json['profile'];
    }
    else{
      profileImage='default.jpeg';
    };
    rate= json['rate'].toString();
  }
}
