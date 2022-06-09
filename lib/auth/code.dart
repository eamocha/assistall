import 'package:agora_flutter_quickstart/auth/signup.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:flutter/material.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'new_password.dart';


class Code extends StatefulWidget {
  final String phoneNumber;
  final String step;
  final userId;
  Code({required this.phoneNumber,required this.step,this.userId});

  @override
  _CodeState createState() => _CodeState();
}

class _CodeState extends State<Code> {

  String? code;

  AuthRepo authRepo=AuthRepo();


  Future _verifyOTP() async{


    if(code?.isEmpty??true){

      await Ui().errorToast('Please enter code');

    }
    else{
      var pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Loading...');

      var params={
        'phone':widget.phoneNumber.toString(),
        'code':code.toString()
      };


      await authRepo.validateOTP(params).then((value) async {

        pd.close();
        if(value){

          if(widget.step=='REGISTRATION'){

            /*await Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context)=>SignUp()));*/


          }
          else if(widget.step=='FORGOT_PASSWORD'){

            await Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>NewPassword(userId: widget.userId,)));

          }



        }

      });


    }


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Verify Code'),
      ),

      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [

          Ui.verticalSpace(100),

          Container(
            child: Text('Enter code sent to '+widget.phoneNumber.toString()
              ,style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600
              ),),
          ),

          Ui.verticalSpace(50),


          OTPTextField(
            length: 5,
            width: MediaQuery.of(context).size.width,
            fieldWidth: 50,
            style: TextStyle(
                fontSize: 17
            ),
            textFieldAlignment: MainAxisAlignment.spaceAround,
            fieldStyle: FieldStyle.box,
            onCompleted: (pin) {
              setState(() {
                code=pin;
              });
            },
          ),
          Ui.verticalSpaceMedium(),

          Ui.gestureDetector(title: 'Resend Code', onTap: (){

          }),

          Ui.verticalSpace(40),


          Ui.primaryButton(title: 'CONTINUE', onTap: (){

            _verifyOTP();

          }, context: context)
        ],
      ),
    );
  }
}
