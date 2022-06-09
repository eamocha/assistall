import 'package:agora_flutter_quickstart/auth/signup.dart';
import 'package:agora_flutter_quickstart/repo/authRepo.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';
import 'package:sn_progress_dialog/progress_dialog.dart';

import 'code.dart';

class Phone extends StatefulWidget {
  final String step;

  Phone({required this.step});

  @override
  _PhoneState createState() => _PhoneState(step);
}

class _PhoneState extends State<Phone> {
  final String step;

  _PhoneState( this.step);
  String? phoneNumber;
  String? phoneIsoCode;
  AuthRepo authRepo=AuthRepo();
  final TextEditingController controller = TextEditingController();
  String initialCountry = 'KEN';
  PhoneNumber number = PhoneNumber(isoCode: 'KE');

  void onPhoneNumberChange(String number, String internationalizedPhoneNumber, String isoCode) {
    setState(() {
      phoneNumber = internationalizedPhoneNumber;
      phoneIsoCode = isoCode;
    });
  }



  Future _sendOTP() async{

    if(phoneNumber?.isEmpty??true){

      await Ui().errorToast('Please enter phone number');

    }

    else{


      var pd = ProgressDialog(context: context);
      pd.show(max: 100, msg: 'Loading...');


      var params={
        'phone':phoneNumber.toString()
      };


      if(step=='FORGOT_PASSWORD'){


        await authRepo.forgotRequest(params).then((value) async {

          pd.close();

          await Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder:
              (context)=>Code(phoneNumber: phoneNumber.toString(),step: step,userId: value.toString(),)));

        });

      }
      else{


        await authRepo.sendOTP(params).then((value) async {


          pd.close();

          if(value.status){
            /*await Navigator.of(context)
                .pushReplacement(MaterialPageRoute(builder:
                (context)=>SignUp()));*/
          }
          else{

            await Ui().errorToast(value.message);

          }






        });


      }





    }


  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Enter phone'),
      ),
      body: Container(

        child: Column(
          children: [

            Ui.verticalSpace(50),

            Container(
              child: Text('Enter phone number'
                  ,style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600
                  )),
            ),

            Ui.verticalSpaceSmall(),

            Container(
              margin: EdgeInsets.all(20),
              child:InternationalPhoneNumberInput(
                onInputChanged: (PhoneNumber number) {
                  setState(() {
                    phoneNumber = number.phoneNumber;
                  });
                },
                onInputValidated: (bool value) {

                },
                selectorConfig: SelectorConfig(
                  selectorType: PhoneInputSelectorType.DIALOG,
                ),
                ignoreBlank: false,
                autoValidateMode: AutovalidateMode.disabled,
                selectorTextStyle: TextStyle(color: Colors.black),
                initialValue: number,
                textFieldController: controller,
                formatInput: false,
                keyboardType:
                TextInputType.numberWithOptions(signed: true, decimal: true),
                inputBorder: OutlineInputBorder(),
                onSaved: (PhoneNumber number) {
                  setState(() {
                    phoneNumber = number.phoneNumber;
                  });
                },
              ),
            ),

            Ui.verticalSpaceMedium(),

            Ui.primaryButton(title: 'CONTINUE', onTap: (){

              _sendOTP();

            }, context: context)

          ],
        ),
      ),
    );
  }
}
