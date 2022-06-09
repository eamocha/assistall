import 'package:flutter/material.dart';
import 'package:agora_flutter_quickstart/tabs/inter.dart';
import 'package:agora_flutter_quickstart/tabs/help/help.dart';
import 'package:agora_flutter_quickstart/tabs/profile/profile.dart';
import 'package:agora_flutter_quickstart/tabs/profile/myTransactions.dart';
import 'package:agora_flutter_quickstart/tabs/profile/callReservations.dart';


class MainPage extends StatelessWidget {
  // This widget is the root of your application.
  ///recommended
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Application name
      // Application theme data, you can set the colors for the application as
      // you want
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      // A widget which will be started on application startup
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
    
      body: GridView.count(
        primary: false,
        padding: const EdgeInsets.all(20),
        crossAxisSpacing: 15,
        mainAxisSpacing: 19,
        crossAxisCount: 2,
        children: <Widget>[
          InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(
                          Icons.group,
                          color: Colors.deepPurple,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        'Interpreters',
                        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1.0, fontFamily: 'Roboto'),
                      ),
                    ),
                  ],
                ),
                color: Colors.white,
              ),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Interpreters()),
                );
              }),
          InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(
                          Icons.wallet_travel,
                          color: Colors.deepPurple,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('Wallet', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1.0, fontFamily: 'Roboto')),
                    ),
                  ],
                ),
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              }),
          InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(
                          Icons.person,
                          color: Colors.deepPurple,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('Profile', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1.0, fontFamily: 'Roboto')),
                    ),
                  ],
                ),
                color: Colors.white,
              ),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              }),
          InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(
                          Icons.help_center,
                          color: Colors.deepPurple,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('Help', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1.0, fontFamily: 'Roboto')),
                    ),
                  ],
                ),
                color: Colors.white,
              ),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Help()),
                );
              }),
          InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(
                          Icons.call,
                          color: Colors.deepPurple,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('Calls', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1.0, fontFamily: 'Roboto')),
                    ),
                  ],
                ),
                color: Colors.white,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallReservations()),
                );
              }),
          InkWell(
              child: Container(
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: const <Widget>[
                    Padding(
                      padding: EdgeInsets.all(20.0),
                    ),
                    Expanded(
                      child: FittedBox(
                        fit: BoxFit.contain, // otherwise the logo will be tiny
                        child: Icon(
                          Icons.monetization_on,
                          color: Colors.deepPurple,
                          size: 10.0,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.all(5.0),
                      child: Text('Transactions', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 18, letterSpacing: 1.0, fontFamily: 'Roboto')),
                    ),
                  ],
                ),
                color: Colors.white,
              ),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyTransactions()),
                );
              })
        ],
      ),
    );
  }
}
