import 'package:agora_flutter_quickstart/models/account.dart';

class User{

  late int account_type;
  late String name;
  late String last_name='';
  late String phone;
  late String email;
  late  String profileImage='';
  late  String country;
  late String rate_count;
  late String speciality='speciality';
  late Account account;

  User({required this.account_type,required this.name,required this.last_name,
    required this.email,required this.speciality,required this.phone,required this.profileImage,
    required this.country, required this.rate_count,required this.account});
  User.fromJson(Map<String, dynamic> json){
    account_type=json['account_type_id'] ?? 2;
    name=json['name'] ?? '';
    phone=json['phone'] ?? '';
    email=json['email'] ?? '';
    country=json['country'] ?? '';
    rate_count=json['rate_count'].toString();
    if(json['profile'] !=null){
      profileImage=json['profile'];
    };
    if(json['last_name'] !=null){
      last_name=json['last_name'];
    };
    if(json['account'] !=null){
      account=Account.map(json['account']);
    }
    if(json['speciality'] !=null){
      speciality=json['speciality'];
    }
    }

}