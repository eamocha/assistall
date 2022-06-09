import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as p;
import 'package:sn_progress_dialog/progress_dialog.dart';
import '../../bloc/attachmentBloc.dart';
import '../../config/config.dart';
import '../../models/attachment.dart';
import '../../util/api_base.dart';
import '../../util/ui.dart';

class MyVideos extends StatefulWidget {
  const MyVideos({Key? key}) : super(key: key);

  @override
  State<MyVideos> createState() => _MyVideosState();
}

class _MyVideosState extends State<MyVideos> {
  final _api=ApiBase();
  final ImagePicker _picker = ImagePicker();

  List<XFile>? _imageFileList;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }

  Future pickProfile() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    await uploadAttachment();
  }

  Future uploadAttachment() async{
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...');
    Response response;
    var dio = Dio();
    var formData = FormData.fromMap({
      'videos': await MultipartFile.fromFile(_imageFileList![0].path,
          filename: p.basename(_imageFileList![0].path))
    });
    response = await dio.post( _api.baseUrl+'user/videos', data: formData,options: Options(
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')
        }
    ));

    print(response.toString());

    pd.close();
    await Ui().successToast('Video uploaded successful pending verification');

    attachmentBloc.getVideos();
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    attachmentBloc.getVideos();

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).accentColor,
        iconTheme: IconThemeData(color: Colors.white),
        title: Text(
          'My Videos',
          style: GoogleFonts.quicksand(color: Colors.white),
        ),
        actions: [
          IconButton(onPressed: (){
            pickProfile();
          }, icon: Icon(Icons.add)
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 10),
        child: StreamBuilder(
          stream: attachmentBloc.videoSubject.stream,
          builder: (ctx, AsyncSnapshot<AttachmentResponse>snapshot) {
            return CustomScrollView(
              slivers: [
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                      return GestureDetector(
                          onTap: (){
                          },
                          child:ListTile(
                            dense: true,
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).accentColor,
                              child: Icon(Icons.videocam,color: Colors.white,),
                            ),
                            title: Text(snapshot.data!.videos[index].name),
                          ));
                    },
                    childCount: snapshot.data!.videos.length, // 1000 list items
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
