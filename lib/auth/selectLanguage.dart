import 'package:agora_flutter_quickstart/auth/selectCountry.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageSelectorScreen extends StatefulWidget {
  const LanguageSelectorScreen({Key? key}) : super(key: key);

  @override
  _LanguageSelectorScreenState createState() => _LanguageSelectorScreenState();
}

class _LanguageSelectorScreenState extends State<LanguageSelectorScreen> {
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

  void checkIfAuthenticated() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('accessToken') != null) {
      await Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => IndexPage()));
    } else {

    }
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkIfAuthenticated();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(width: 0.6, color: Colors.blueGrey),
          ),
          color: Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.only(left: 30,right: 30,bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [

              Container(
                child: ButtonTheme(
                  height: 40,
                  child:  TextButton(
                      onPressed: () {

                        Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectCountry()));

                      },
                      child: Text(
                        'next',
                        style: GoogleFonts.quicksand(
                            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                      ).tr()),
                ),
              ),

            ],
          ),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Ui.verticalSpace(50),
            Center(
              child: Text('assistALL',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: Theme.of(context).accentColor
                ),),
            ),
            Ui.verticalSpaceSmall(),
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
                    setState(() {
                      context.locale = Locale('en', 'UK');
                    });
                    Config.set('locale', 'en');
                  }
                  else if(newValue=='Spanish'){
                    setState(() {
                      context.locale = Locale('es', 'SP');
                    });
                    Config.set('locale', 'es');
                  }
                  else if(newValue=='French'){
                    setState(() {
                      context.locale = Locale('fr', 'FR');
                    });
                    Config.set('locale', 'fr');
                  }
                  else if(newValue=='Portuguese'){
                    setState(() {
                      context.locale = Locale('pt', 'PT');
                    });
                    Config.set('locale', 'pt');
                  }
                  else if(newValue=='Kiswahili'){
                    setState(() {
                      context.locale = Locale('sw', 'KE');
                    });
                    Config.set('locale', 'sw');
                  }
                  else  if(newValue=='Arabic'){
                    setState(() {
                      context.locale = Locale('ar', 'AE');
                    });
                    Config.set('locale', 'ar');
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
