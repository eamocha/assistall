class Genders{
  late int id;
  late String name;
  Genders(this.id,this.name);
  Genders.map(Map<String,dynamic> json){
    id=json['id'];
    name=json['name'];
  }
}