
class EducationLevelResponse{

  List<EducationLevel> levels;

  bool status;

  EducationLevelResponse(this.levels,this.status);

  EducationLevelResponse.fromJson(Map<String, dynamic> json)
      :levels=(json['levels'] as List)
      .map((e) => EducationLevel.fromJson(e))
      .toList(),
        status=json['status'];


}


class EducationLevel{
  late int id;
  late String name;

  EducationLevel(this.id,this.name);
  EducationLevel.fromJson(Map<String,dynamic> json){
    id=json['id'];
    name=json['name'];
  }
}