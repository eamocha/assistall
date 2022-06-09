class CardDepositModel{
  bool? status;
  String? url;

  CardDepositModel(this.status,this.url);
  CardDepositModel.fromJson(Map<String,dynamic>json){
    status=json['status'];
    url=json['url'];
  }
}