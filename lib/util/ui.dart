import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class Ui{

  // Vertical spacing constants. Adjust to your liking.
  static const double _VerticalSpaceSmall = 20.0;
  static const double _VerticalSpaceMedium = 40.0;
  static const double _VerticalSpaceLarge = 60.0;

  // Vertical spacing constants. Adjust to your liking.
  static const double _HorizontalSpaceSmall = 20.0;
  static const double _HorizontalSpaceMedium = 40.0;
  static const double HorizontalSpaceLarge = 60.0;

  /// Returns a vertical space with height set to [_VerticalSpaceSmall]
  static Widget verticalSpaceSmall() {
    return verticalSpace(_VerticalSpaceSmall);
  }

  /// Returns a vertical space with height set to [_VerticalSpaceMedium]
  static Widget verticalSpaceMedium() {
    return verticalSpace(_VerticalSpaceMedium);
  }

  /// Returns a vertical space with height set to [_VerticalSpaceLarge]
  static Widget verticalSpaceLarge() {
    return verticalSpace(_VerticalSpaceLarge);
  }

  /// Returns a vertical space equal to the [height] supplied
  static Widget verticalSpace(double height) {
    return Container(height: height);
  }

  /// Returns a vertical space with height set to [_HorizontalSpaceSmall]
  static Widget horizontalSpaceSmall() {
    return horizontalSpace(_HorizontalSpaceSmall);
  }

  /// Returns a vertical space with height set to [_HorizontalSpaceMedium]
  static Widget horizontalSpaceMedium() {
    return horizontalSpace(_HorizontalSpaceMedium);
  }

  /// Returns a vertical space with height set to [HorizontalSpaceLarge]
  static Widget horizontalSpaceLarge() {
    return horizontalSpace(HorizontalSpaceLarge);
  }

  /// Returns a vertical space equal to the [width] supplied
  static Widget horizontalSpace(double width) {
    return Container(width: width);
  }


  static Widget gestureDetector({required String title , required VoidCallback onTap}){
    return Container(
      child: GestureDetector(
        onTap: onTap,
        child: Text(title,style: TextStyle(
          fontWeight: FontWeight.bold
        ),),
      ),
    );
  }


  Future errorToast(String message){
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }


  Future successToast(String message){
    return Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }



  Future alertDialogError(String description,BuildContext context) async{
    await showDialog(context: context,
        builder: (BuildContext context){
         return AlertDialog(
           title: Icon(Icons.error,size: 50,),
           content: Text(description),
           actions: [

             TextButton(
               onPressed: () => Navigator.pop(context, 'OK'),
               child: const Text('OK',style: TextStyle(
                 fontWeight: FontWeight.bold,
                 color:Colors.black
               ),),
             ),
           ],
         );

        });
  }

  Future confirmDialogError(String title, description,BuildContext context) async{
    await showDialog(context: context,
        builder: (BuildContext context){
          return AlertDialog(
            title: Text("Confirm"),
            content: Text(description),
            actions: [

              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('CANCEL',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:Colors.red
                ),),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, 'OK'),
                child: const Text('OK',style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color:Colors.green
                ),),
              ),
            ],
          );

        });
  }





  static Widget primaryButton({required String title ,
    required VoidCallback onTap,
    required BuildContext context}){
    final style =
    ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        textStyle: const TextStyle(
          fontWeight: FontWeight.bold
        ));

    return ConstrainedBox(
      constraints: BoxConstraints.tightFor(width: 350, height: 40),
      child: ElevatedButton(
        style: style,
        onPressed: onTap, child:Text(title)),);

  }

  static Widget textField({
    required String placeholder,
    required String label,
    required TextEditingController controller,
    bool isPassword=false,
    required TextInputType inputType,
    Widget? suffixIcon,
    Widget? prefixIcon,
    int? maxLines,
    required BuildContext context,}){

    return TextField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: placeholder,
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).primaryColor, width: 1.0),
        ),
      ),
    );

  }

  static Widget textFormFiled({
    required String placeholder,
    required String label,
    required TextEditingController controller,
    bool isPassword=false,
    required TextInputType inputType,
    Widget? suffixIcon,
    Widget? prefixIcon,
    int? maxLines,
    required BuildContext context,

   }){

    return TextFormField(
      controller: controller,
      obscureText: isPassword,
      keyboardType: inputType,
      maxLines: maxLines,
      validator: (value){
        if(value==null || value.isEmpty){
          return 'Please enter $label';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: placeholder,
        labelText: label,
        labelStyle: TextStyle(color: Colors.black),
        hintStyle: TextStyle(color: Colors.grey[600]),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 1.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black12, width: 1.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(color:Theme.of(context).primaryColor, width: 1.0),
        ),
      ),

    );

   }
}