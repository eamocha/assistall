import 'dart:convert';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:agora_flutter_quickstart/auth/signin.dart';
import 'package:agora_flutter_quickstart/bloc/userBloc.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/models/user.dart';
import 'package:agora_flutter_quickstart/repo/paymentRepo.dart';
import 'package:agora_flutter_quickstart/screens/reusableWebView.dart';
import 'package:agora_flutter_quickstart/tabs/history/history.dart';
import 'package:agora_flutter_quickstart/tabs/profile/attachments.dart';
import 'package:agora_flutter_quickstart/tabs/profile/callReservations.dart';
import 'package:agora_flutter_quickstart/tabs/profile/deposit.dart';
import 'package:agora_flutter_quickstart/tabs/profile/editProfile.dart';
import 'package:agora_flutter_quickstart/tabs/profile/myTransactions.dart';
import 'package:agora_flutter_quickstart/tabs/profile/videos.dart';
import 'package:agora_flutter_quickstart/tabs/profile/withdraw.dart';
import 'package:agora_flutter_quickstart/util/UIutils.dart';
import 'package:agora_flutter_quickstart/util/api_base.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:dio/dio.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:flutterwave/core/flutterwave.dart';
import 'package:flutterwave/models/responses/charge_response.dart';
import 'package:flutterwave/utils/flutterwave_constants.dart';
import 'package:flutterwave/utils/flutterwave_currency.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:path/path.dart' as p;
import 'package:sn_progress_dialog/progress_dialog.dart';
class Profile extends StatefulWidget {

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  bool interpreter = true;
  String? depositMethod;
  String? transaction;
  String? withdrawMethod;
  TextEditingController _amountController=TextEditingController();
  final transactionKey = GlobalKey<FormState>();
  List<XFile>? _imageFileList;
  final _apiBase=ApiBase();
  late String phone;
  late String email;
  late String name;
  set _imageFile(XFile? value) {
    _imageFileList = value == null ? null : [value];
  }
  final ImagePicker _picker = ImagePicker();
  final String currency = FlutterwaveCurrency.KES;
  final paymentRepo=PaymentRepo();
  var txRef=Random().nextInt(1000000);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    userBloc.myProfile();
    getProfile();

  }

  Future getProfile() async {
    final response = await http
        .get(Uri.parse(_apiBase.baseUrl+'user/profile'),
        headers: {
          'Authorization': 'Bearer '+ await Config.get('accessToken')

        });

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var jsonResponse=jsonDecode(response.body);
      print('Phone data'+jsonResponse['user']['phone'].toString().substring(1));
      setState(() {
        phone=jsonResponse['user']['phone'].toString().substring(1);
        email=jsonResponse['user']['email'].toString().substring(1);
        name=jsonResponse['user']['name'].toString().substring(1);
      });
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load album');
    }
  }

  Future pickProfile() async {
    final pickedFile = await _picker.pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      _imageFile = pickedFile;
    });
    await uploadProfileImage();
  }

  Future signOut() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            content: Text('Confirm to sign out'),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text('CANCEL')),
              TextButton(
                  onPressed: () async {
                    var preferences = await SharedPreferences.getInstance();
                    await preferences.clear();
                    await Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) => SignIn()));
                  },
                  child: Text('OK'))
            ],
          );
        });
  }

  Future mpesaDeposit() async{
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);
    var body={
      'amount':_amountController.text.trim().toString(),
      'phone':phone
    };

    await paymentRepo.deposit(body).then((value){
      pd.close();
      if(value.status){
        _amountController.clear();
        Ui().successToast(value.message);
      }
      else{
        Ui().errorToast(value.message);
      }
    });


  }

  Future mpesaWithdraw() async{
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);
    var body={
      'amount':_amountController.text.trim().toString(),
    };

    await paymentRepo.withdraw(body).then((value){
      pd.close();
      if(value.status){
        _amountController.clear();
        Ui().successToast(value.message);
      }
      else{
        Ui().errorToast(value.message);
      }
    });


  }

  Future depositOptionsDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('payment_methods',style: TextStyle(
              fontWeight: FontWeight.bold
            ),).tr(),
            content: Wrap(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Image.asset('lib/assets/mpesa.png'),
                    ),
                  ),
                  title: Text('Mpesa',style: TextStyle(
                    fontWeight: FontWeight.normal
                  ),),
                  onTap: (){
                    setState(() {
                      depositMethod='Mpesa';
                    });
                    Navigator.pop(context);
                    mpesaDialog();
                  },
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(Icons.credit_card,size: 50,color: Theme.of(context).accentColor,),
                    ),
                  ),
                  title: Text('Card',style: TextStyle(
                      fontWeight: FontWeight.normal
                  ),),
                  onTap: (){
                    setState(() {
                      depositMethod='Card';
                    });
                    Navigator.pop(context);
                    cardDepositDialog();
                  },
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Image.asset('lib/assets/paypal.png',height: 100,width: 100,),
                    ),
                  ),
                  title: Text('Paypal',style: TextStyle(
                      fontWeight: FontWeight.normal
                  ),),
                  onTap: (){
                    setState(() {
                      depositMethod='Paypal';
                    });
                    Navigator.pop(context);
                    payPalDepositDialog();
                  },
                )
              ],
            ),
          );
        });
  }

  Future withDrawOptionsDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('payment_methods',style: TextStyle(
                fontWeight: FontWeight.bold
            ),).tr(),
            content: Wrap(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Image.asset('lib/assets/mpesa.png'),
                    ),
                  ),
                  title: Text('Mpesa',style: TextStyle(
                      fontWeight: FontWeight.normal
                  ),),
                  onTap: (){
                    setState(() {
                      withdrawMethod='Mpesa';
                    });
                    Navigator.pop(context);
                    mpesaDialog();
                  },
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Icon(Icons.credit_card,size: 50,color: Theme.of(context).accentColor,),
                    ),
                  ),
                  title: Text('Card',style: TextStyle(
                      fontWeight: FontWeight.normal
                  ),),
                  onTap: (){
                    setState(() {
                      withdrawMethod='Card';
                    });
                  },
                ),
                Divider(),
                ListTile(
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.white,
                    child: Center(
                      child: Image.asset('lib/assets/paypal.png',height: 100,width: 100,),
                    ),
                  ),
                  title: Text('Paypal',style: TextStyle(
                      fontWeight: FontWeight.normal
                  ),),
                  onTap: (){
                    setState(() {
                      withdrawMethod='Paypal';
                    });
                  },
                )
              ],
            ),
          );
        });
  }


  Future mpesaDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text( transaction =='Withdraw' ?
            'with_mpesa':
            'depo_mpesa',style: TextStyle(
              fontWeight: FontWeight.bold
            ),).tr(),
            content: Wrap(
              children: [
                Form(
                  key: transactionKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Amount';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Amount',style: TextStyle(color: Colors.black),),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                        Ui.verticalSpaceSmall(),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ButtonTheme(
                            height: 50,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (transactionKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    if(transaction =='Withdraw'){
                                      mpesaWithdraw();
                                    }
                                    else{
                                      mpesaDeposit();
                                    }
                                  } else {
                                  }
                                },
                                child: Text(
                                  transaction =='Withdraw' ?
                                  'withdraw':
                                  'deposit',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ).tr()),
                          ),
                        ),

                 ],))
              ],
            ),
          );
        });
  }

  Future cardDepositDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text( 'Deposit',style: TextStyle(
                fontWeight: FontWeight.bold
            ),).tr(),
            content: Wrap(
              children: [
                Form(
                    key: transactionKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Amount';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Amount',style: TextStyle(color: Colors.black),),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                        Ui.verticalSpaceSmall(),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ButtonTheme(
                            height: 50,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (transactionKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    cardDeposit();
                                  } else {
                                  }
                                },
                                child: Text(
                                  transaction =='Withdraw' ?
                                  'withdraw':
                                  'deposit',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ).tr()),
                          ),
                        ),

                      ],))
              ],
            ),
          );
        });
  }


  Future payPalDepositDialog() async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text( 'Deposit',style: TextStyle(
                fontWeight: FontWeight.bold
            ),).tr(),
            content: Wrap(
              children: [
                Form(
                    key: transactionKey,
                    child: Column(
                      children: [
                        TextFormField(
                          controller: _amountController,
                          keyboardType: TextInputType.number,
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Enter Amount';
                            } else {
                              return null;
                            }
                          },
                          decoration: InputDecoration(
                            label: Text('Amount',style: TextStyle(color: Colors.black),),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black12, width: 1.0),
                            ),
                          ),
                        ),
                        Ui.verticalSpaceSmall(),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: ButtonTheme(
                            height: 50,
                            child: RaisedButton(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(2)),
                                color: Theme.of(context).accentColor,
                                onPressed: () {
                                  if (transactionKey.currentState!.validate()) {
                                    Navigator.pop(context);
                                    payPalDeposit();
                                  } else {
                                  }
                                },
                                child: Text(
                                  transaction =='Withdraw' ?
                                  'withdraw':
                                  'deposit',
                                  style: GoogleFonts.quicksand(
                                      color: Colors.white, fontWeight: FontWeight.bold),
                                ).tr()),
                          ),
                        ),

                      ],))
              ],
            ),
          );
        });
  }


  Future cardDeposit() async{
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);
    var body={
      'amount':_amountController.text.trim().toString(),
    };

    await paymentRepo.cardDeposit(body).then((value){
      pd.close();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReusableWebview(value)));

    });


  }

  Future payPalDeposit() async{
    var pd = ProgressDialog(context: context);
    pd.show(max: 100, msg: 'Loading...',barrierDismissible: true);
    var body={
      'amount':_amountController.text.trim().toString(),
    };

    await paymentRepo.payPalDeposit(body).then((value){
      _amountController.clear();
      pd.close();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>ReusableWebview(value.message)));

    });


  }

  final _api=ApiBase();

  Future uploadProfileImage() async{
    Response response;
    var dio = Dio();
    var formData = FormData.fromMap({

      'profile': await MultipartFile.fromFile(_imageFileList![0].path,
          filename: p.basename(_imageFileList![0].path))
    });
    response = await dio.post( _api.baseUrl+'profile/uploadProfile', data: formData,options: Options(
      headers: {
        'Authorization': 'Bearer '+ await Config.get('accessToken')
      }
    ));
   await Ui().successToast('Profile image uploaded successful');
   userBloc.myProfile();
  }

  /*beginPayment() async {

    final flutterWave = Flutterwave.forUIPayment(
        context: context,
        encryptionKey: "FLWSECK_TESTab0e63b35417",
        publicKey: "FLWPUBK_TEST-2f4f639946d4806227b4813fde0c20cf-X",
        currency: currency,
        amount: 100.toString(),
        email: email,
        fullName: name,
        txRef: txRef.toString(),
        isDebugMode: true,
        phoneNumber: phone,
        acceptCardPayment: true,
        acceptUSSDPayment: false,
        acceptAccountPayment: false,
        acceptFrancophoneMobileMoney: false,
        acceptGhanaPayment: false,
        acceptMpesaPayment: false,
        acceptRwandaMoneyPayment: false,
        acceptUgandaPayment: false,
        acceptZambiaPayment: false);

    try {
      final response = await flutterWave.initializeForUiPayments();
      if (response == null) {
        // user didn't complete the transaction.
      } else {
        final isSuccessful = checkPaymentIsSuccessful(response);
        if (isSuccessful) {
          // provide value to customer
        } else {
          // check message
          print(response.message);

          // check status
          print(response.status);

          // check processor error
          print(response.data!.processorResponse);
        }
      }
    } catch (error, stacktrace) {
      // handleError(error);
    }
  }
  bool checkPaymentIsSuccessful(final ChargeResponse response) {
    return response.data?.status == FlutterwaveConstants.SUCCESSFUL &&
        response.data?.currency == currency &&
        response.data?.amount == '100' &&
        response.data?.txRef == txRef;
  }*/
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(5),
        child: StreamBuilder(
            stream: userBloc.subject.stream,
            builder: (context,AsyncSnapshot<User> snapshot){
              if(snapshot.hasData){
                return ListView(
                  children: [
                    Container(
                      child: ListTile(
                        dense: true,
                        onTap: (){
                          pickProfile();
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 20,
                          child: GestureDetector(
                            child: snapshot.data!.profileImage !=''?
                                Image.network(_apiBase.profileImage+ snapshot.data!.profileImage)
                                :
                            Center(
                          child: Text(
                          snapshot.data!.name.substring(0,1),
                          style: TextStyle(
                              fontWeight: FontWeight.bold
                          ),
                        ),
                         ),
                          ),
                        ),
                        title: Text(
                          snapshot.data!.name.toString() +' '+ snapshot.data!.last_name.toString(),
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ),
                        trailing: Text('KES '+
                            snapshot.data!.account.balance.toString(),
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold,fontSize: 25),
                        ),

                        subtitle: Text(snapshot.data!.email.toString()),

                      ),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'edit_profile',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ).tr(),
                        subtitle: Text('Update profile').tr(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EditProfile())).then((value){
                                    userBloc.myProfile();
                          });
                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      child:snapshot.data!.account_type==2? ListTile(
                        dense: true,
                        title: Text(
                          'My Attachments',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('My sttachments').tr(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyAttachments())).then((value){
                            userBloc.myProfile();
                          });
                        },
                      ):SizedBox(height: 0,width: 0,),
                    ),
                    Divider(),
                    Container(
                      child:snapshot.data!.account_type==2? ListTile(
                        dense: true,
                        title: Text(
                          'My Videos',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('My videos').tr(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyVideos())).then((value){
                            userBloc.myProfile();
                          });
                        },
                      ):SizedBox(height: 0,width: 0,),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'transactions',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ).tr(),
                        subtitle: Text('history').tr(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MyTransactions()));
                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'reserve',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ).tr(),
                        subtitle: Text('reserve').tr(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => CallReservations()));
                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'call_log',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ).tr(),
                        subtitle: Text('call_log').tr(),
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => History()));
                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'deposit',
                          style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
                        ).tr(),
                        subtitle: Text('recharge').tr(),
                        onTap: () {
                          setState(() {

                            transaction='Deposit';
                          });
                          depositOptionsDialog();

                        },
                      ),
                    ),
                    Divider(),
                    Container(
                      child: ListTile(
                        dense: true,
                        title: Text(
                          'withdraw',
                          style: GoogleFonts.quicksand(
                              fontWeight: FontWeight.bold),
                        ).tr(),
                        subtitle: Text('withdraw').tr(),
                        onTap: () {
                          setState(() {
                            transaction='Withdraw';
                          });
                         withDrawOptionsDialog();
                        },
                      ),
                    ),


                  ],
                );
              }
              else{
                return Center(
                  child: CircularProgressIndicator(),
                );
              }

            }),
      ),
    );
  }
}
