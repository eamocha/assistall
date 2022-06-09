import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_translate/flutter_translate.dart';
import 'package:language_picker/language_picker_cupertino.dart';
import 'package:language_picker/language_picker_dialog.dart';
import 'package:language_picker/language_picker_dropdown.dart';
import 'package:language_picker/languages.dart';

class ChangeLanguage extends StatefulWidget {
  const ChangeLanguage({Key? key}) : super(key: key);

  @override
  _ChangeLanguageState createState() => _ChangeLanguageState();
}

class _ChangeLanguageState extends State<ChangeLanguage> {
  // Initial Selected Value
  String dropdownvalue = 'English';

  // List of items in our dropdown menu
  var items = [
    'English',
    'French',
    'Spanish',
    'Portuguese',
    'Kiswahili',
    'Arabic'
  ];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('select_language').tr(),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ui.verticalSpace(50),
            Center(
              child: Text('select_language',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).accentColor
                ),).tr(),
            ),
            Ui.verticalSpaceMedium(),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child:  DropdownButtonFormField(
                // Initial Value
                value: dropdownvalue,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                ),
                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),

                // Array list of items
                items: items.map((String items) {
                  return DropdownMenuItem(
                    value: items,
                    child: Text(items).tr(),
                  );
                }).toList(),
                // After selecting the desired option,it will
                // change button value to selected value
                onChanged: (String? newValue) {
                  setState(() {
                    dropdownvalue = newValue!;
                  });

                  if(newValue=='English'){
                    context.locale = Locale('en', 'UK');
                    setState(() {
                      context.locale = Locale('en', 'UK');
                    });
                  }
                  else if(newValue=='Spanish'){
                    context.locale = Locale('es', 'SP');
                    setState(() {
                      context.locale = Locale('es', 'SP');
                    });
                  }
                  else if(newValue=='French'){
                    context.locale = Locale('fr', 'FR');
                    setState(() {
                      context.locale = Locale('fr', 'FR');
                    });
                  }
                  else if(newValue=='Portuguese'){
                    context.locale = Locale('pt', 'PT');
                    setState(() {
                      context.locale = Locale('pt', 'PT');
                    });
                  }
                  else if(newValue=='Kiswahili'){
                    context.locale = Locale('sw', 'KE');
                    setState(() {
                      context.locale = Locale('sw', 'KE');
                    });
                  }
                  else  if(newValue=='Arabic'){
                    context.locale = Locale('ar', 'AE');
                    setState(() {
                      context.locale = Locale('ar', 'AE');
                    });
                  }

                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
