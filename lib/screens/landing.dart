import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../src/pages/index.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({Key? key}) : super(key: key);

  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Ui.verticalSpace(150),
              Center(
                  child: Center(
                    child: Image.asset('lib/assets/sign.png'),
                  )
              ),
              Ui.verticalSpaceSmall(),
              Center(
                child: Text('assistALL allows anybody across the world to access sign language interpretation services to enhance inclusion & break communication barriers',
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Theme.of(context).accentColor
                  ),),
              ),
              Ui.verticalSpaceMedium(),
              Ui.primaryButton(title: 'View Interpreters', onTap: (){
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>IndexPage()));
              }, context: context)
            ],
          ),
        ),
      ),
    );
  }
}
