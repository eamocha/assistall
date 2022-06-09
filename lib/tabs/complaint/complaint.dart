import 'package:agora_flutter_quickstart/repo/complainRepo.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class SubmitComplaint extends StatefulWidget {
  const SubmitComplaint({Key? key}) : super(key: key);

  @override
  _SubmitComplaintState createState() => _SubmitComplaintState();
}

class _SubmitComplaintState extends State<SubmitComplaint> {
  final complaintKey = GlobalKey<FormState>();
  var subjectController= TextEditingController();
  var descriptionController= TextEditingController();
  ComplainRepo complainRepo=ComplainRepo();

  Future submit() async {
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...');

    var params={
      'subject':subjectController.text,
      'description':descriptionController.text,
    };

    await complainRepo.submitComplain(params).then((value) async {
      pd.close();
      if(value.status){
        await Ui().successToast(value.message.toString());

         Navigator.pop(context);
      }
      else{
        await Ui().successToast(value.message);
      }
    });

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Complaint'),
      ),
      body: Form(
          key: complaintKey,
          child: Container(
            decoration: BoxDecoration(),
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: ListView(
              children: <Widget>[
                SizedBox(
                  height: 50,
                ),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey,
                            blurRadius: 0,
                            offset: Offset(0, 0))
                      ],
                      borderRadius: BorderRadius.circular(4)),
                  child: Column(
                    children: [
                      Container(
                        padding:
                        EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                        child: TextFormField(
                          controller: subjectController,
                          keyboardType: TextInputType.text,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Subject';
                            }  else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Subject',style: TextStyle(color: Colors.black),),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: TextFormField(
                          controller: descriptionController,
                          keyboardType: TextInputType.multiline,
                          maxLines: 5,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Description';
                            }  else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Description',style: TextStyle(color: Colors.black),),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                    ],
                  ),
                ),
                SizedBox(
                  height: 40,
                ),
                SizedBox(
                  height: 30,
                ),
                Container(
                  child: ButtonTheme(
                    height: 50,
                    child: RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(2)),
                        color: Theme.of(context).accentColor,
                        onPressed: () {
                          if (complaintKey.currentState!.validate()) {

                            submit();
                          } else {}
                        },
                        child: Text(
                          'SUBMIT',
                          style: GoogleFonts.quicksand(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        )),
                  ),
                ),


                SizedBox(
                  height: 30,
                ),

              ],
            ),
          )),

    );
  }
}
