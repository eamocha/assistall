class Account{

   late int id;
   late double debit;
   late double credit;
   late double balance;
   late List<LedgerEntry> ledgers;

  Account({required this.id,required this.debit,required this.credit,required this.balance,required this.ledgers});

  Account.map(dynamic json){
    id=json['id'];
    debit=double.parse(json['debit'].toString());
    credit=double.parse(json['credit'].toString());
    balance=double.parse(json['balance'].toString());
    if(json['ledgers'] !=null){
      ledgers=(json['ledgers'] as List)
          .map((e) =>  LedgerEntry.fromJson(e))
          .toList();
    }
  }

}


class LedgerEntry{
  late int id;
  late double debit;
  late double credit;
  late double balance;
  late String description;
  late String time;
  LedgerEntry({required this.id,required this.debit,required this.credit,
    required this.balance,required this.description,required this.time});

  LedgerEntry.fromJson(Map<String,dynamic> json){
    id=json['id'];
    debit=double.parse(json['debit'].toString());
    credit=double.parse(json['credit'].toString());
    balance=double.parse(json['balance'].toString());
    description=json['description'];
    time=json['created_at'];
  }
}