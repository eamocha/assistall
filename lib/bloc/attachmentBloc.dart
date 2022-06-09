import 'package:agora_flutter_quickstart/models/attachment.dart';
import 'package:agora_flutter_quickstart/models/intconverter.dart';
import 'package:agora_flutter_quickstart/repo/attachmentRepo.dart';
import 'package:agora_flutter_quickstart/repo/interpretersRepo.dart';
import 'package:rxdart/rxdart.dart';

final attachmentBloc=AttachmentBloc();
class AttachmentBloc{
  final AttachmentRepo _attachmentRepo=AttachmentRepo();

  final BehaviorSubject<AttachmentResponse> _attachments=BehaviorSubject<AttachmentResponse>();
  final BehaviorSubject<AttachmentResponse> _videos=BehaviorSubject<AttachmentResponse>();

  getAttachments() async{
    var response=await _attachmentRepo.myAttachments();
    _attachments.sink.add(response);
  }

  getVideos() async{
    var response=await _attachmentRepo.myAttachments();
    _videos.sink.add(response);
  }

  dispose(){

    _attachments.close();
  }


  BehaviorSubject<AttachmentResponse> get subject=>_attachments;
  BehaviorSubject<AttachmentResponse> get videoSubject=>_videos;

}