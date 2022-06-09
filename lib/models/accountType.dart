class AccountTypeResponse{

  List<AccountType>? accountType;

  bool? status;

  AccountTypeResponse({this.accountType, this.status});

  AccountTypeResponse.fromJson(Map<String,dynamic> json ){
    status=json['status'];
    accountType=(json['account_types'] as List)
        .map((e) =>  AccountType.fromJson(e))
        .toList();
  }

}

class AccountType {
  late String name;
  late int id;

      AccountType(
         this.id,
         this.name,
      );

       AccountType.fromJson(Map<String,dynamic> json) {
        id=json['id'];
        if(json['name'] !=null){
          name= json['name'];
        }
        else if(json['swahili'] !=null){
          name= json['swahili'];
        }
        else if(json['spanish'] !=null){
          name= json['spanish'];
        }
        else if(json['arabic'] !=null){
          name= json['arabic'];
        }
        else if(json['french'] !=null){
          name= json['french'];
        }
        else if(json['portuguese'] !=null){
          name= json['portuguese'];
        }
  }
}

