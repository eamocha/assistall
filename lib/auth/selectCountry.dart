import 'package:agora_flutter_quickstart/auth/accountTypes.dart';
import 'package:agora_flutter_quickstart/config/config.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:country_picker/country_picker.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SelectCountry extends StatefulWidget {
  const SelectCountry({Key? key}) : super(key: key);

  @override
  _SelectCountryState createState() => _SelectCountryState();
}

class _SelectCountryState extends State<SelectCountry> {
  String? location;

  Future navigateToSelectType() async{

    if(location?.trim()?.isEmpty ?? true){
      await Ui().errorToast('Please select country');
    }
    else{

      await Navigator.push(context,
          MaterialPageRoute(builder: (context)=>SelectAccountType(location!)));


    }

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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: ButtonTheme(
                  height: 40,
                  child: TextButton(
                      onPressed: () {

                        Navigator.pop(context);
                      },
                      child: Text(
                        'back',
                        style: GoogleFonts.quicksand(
                            color: Theme.of(context).accentColor, fontWeight: FontWeight.bold),
                      ).tr()),
                ),
              ),
              Container(
                child: ButtonTheme(
                  height: 40,
                  child: TextButton(
                      onPressed: () {

                        navigateToSelectType();
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
      body: Container(
        child: Column(
          children: [
            Ui.verticalSpace(250),
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
              child: Text('select_country',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Theme.of(context).accentColor
                ),).tr(),
            ),

            Center(
              child: Container(
                padding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color: Colors.grey,width: 0.4)
                  ),
                  child: ListTile(
                    dense: true,
                    title: Text('Pick Country'),
                    subtitle: Text(location.toString()),
                    onTap: (){
                      showCountryPicker(
                        context: context,
                        countryListTheme: CountryListThemeData(
                          flagSize: 25,
                          backgroundColor: Colors.white,
                          textStyle: TextStyle(fontSize: 16, color: Colors.blueGrey),
                          //Optional. Sets the border radius for the bottomsheet.
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                          //Optional. Styles the search field.
                          inputDecoration: InputDecoration(
                            labelText: 'Search',
                            hintText: 'Start typing to search',
                            prefixIcon: const Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: const Color(0xFF8C98A8).withOpacity(0.2),
                              ),
                            ),
                          ),
                        ),
                        onSelect: (Country country){
                          setState(() {
                            location=country.name;
                          });
                        },
                      );
                    },
                  ),
                ) ,
              ),
            )
          ],
        ),

      ),
    );
  }
}

