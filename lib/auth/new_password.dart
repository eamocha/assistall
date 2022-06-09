import 'package:agora_flutter_quickstart/auth/signin.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

class NewPassword extends StatefulWidget {
  final String userId;
  NewPassword({required this.userId});

  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  final AuthRepo _authRepo=AuthRepo();

  final _resetKey=GlobalKey<FormState>();

  TextEditingController _newPassword=new TextEditingController();
  TextEditingController _confirmPassword=new TextEditingController();

  Future _submit() async{


    if(_newPassword.text!=_confirmPassword.text){

      await Ui().alertDialogError('Your password do not match',
          context);

    }

    else{

      var params={
        'user_id':widget.userId,
        'password':_newPassword.text
      };


      var pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Loading...');

      await _authRepo.resetPassword2(params).then((value) {
        pd.close();

        if(value){

          Ui().successToast('Password reset successfull');

          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context)=>SignIn()));
        }
        else{


          Ui().errorToast('An error occurred please try again');

        }

      });



    }




  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset password',style: GoogleFonts.quicksand(
            fontWeight: FontWeight.bold
        ),),
      ),

      body: Form(
          key: _resetKey,
          child: Container(
            padding: EdgeInsets.all(20),
            child: ListView(
              children: [

                Ui.verticalSpaceLarge(),


                Text('Reset password',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30
                ),),

                Ui.verticalSpaceLarge(),


                Ui.textFormFiled(
                    placeholder: 'New password',
                    label: 'New password',
                    suffixIcon: Icon(Icons.remove_red_eye),
                    controller: _newPassword,
                    inputType: TextInputType.text,
                    context: context),

                Ui.verticalSpaceSmall(),

                Ui.textFormFiled(
                    placeholder: 'Confirm password',
                    label: 'Confirm password',
                    suffixIcon: Icon(Icons.remove_red_eye),
                    controller: _confirmPassword,
                    inputType: TextInputType.text,
                    context: context),

                Ui.verticalSpaceSmall(),

                Ui.primaryButton(
                    title: 'RESET',
                    onTap: (){

                      if(_resetKey.currentState!.validate()){

                        _submit();
                      }

                    },
                    context: context)



              ],
            ),
          )

      ),
    );
  }
}
