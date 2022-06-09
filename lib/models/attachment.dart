
import 'dart:convert';

class AttachmentResponse{

  List<AttachmentModel> videos;

  bool status;

  AttachmentResponse(this.videos,this.status);

  AttachmentResponse.fromJson(Map<String, dynamic> json)
      :videos=(json['attachments'] as List)
      .map((e) =>  AttachmentModel.fromJson(e))
      .toList(),
        status=json['status'];


}


class AttachmentModel {
  late String name;
  late String id;

  AttachmentModel(
      {
        required this.id,
        required this.name,
      });

  AttachmentModel.fromJson(Map<String,dynamic> json) {
    id=json['id'].toString();
    name= json['name'];
  }
}
