import 'dart:async';

import 'mainpage.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/src/public_ext.dart';
import 'package:agora_flutter_quickstart/tabs/inter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:agora_flutter_quickstart/tabs/help/help.dart';
import 'package:agora_flutter_quickstart/tabs/history/history.dart';
import 'package:agora_flutter_quickstart/tabs/profile/profile.dart';
import 'package:agora_flutter_quickstart/tabs/profile/myTransactions.dart';
import 'package:agora_flutter_quickstart/tabs/profile/callReservations.dart';


class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<IndexPage> {
  List<Widget> pages = [MainPage(), Interpreters(), Profile(), Help()];
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Theme.of(context).accentColor,
        title: Text(
          'assistALL',
          style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold),
        ),
        actions: [],
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Container(
                child: Column(children: const <Widget>[
                  Padding(
                    padding: EdgeInsets.all(50.0),
                  ),
                  DrawerHeader(
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                    ),
                    child: Text('assistALL', style: TextStyle(fontWeight: FontWeight.w500, fontSize: 25, letterSpacing: 1.0, fontFamily: 'Roboto', color: Colors.white)),
                  ),
                ]),
                color: Colors.deepPurple),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.group,
                color: Colors.deepPurple,
                size: 30.0,
              ),
              title: const Text('Interpreters'),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Interpreters()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.wallet_travel,
                color: Colors.deepPurple,
                size: 30.0,
              ),
              title: const Text('Wallet'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.person,
                color: Colors.deepPurple,
                size: 30.0,
              ),
              title: const Text('Profile'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Profile()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.call,
                color: Colors.deepPurple,
                size: 30.0,
              ),
              title: const Text('Calls'),
              onTap: () {
                 Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CallReservations()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.monetization_on,
                color: Colors.deepPurple,
                size: 30.0,
              ),
              title: const Text('Transactions'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyTransactions()),
                );
              },
            ),
            ListTile(
              dense: true,
              leading: Icon(
                Icons.help_center,
                color: Colors.deepPurple,
                size: 30.0,
              ),
              title: const Text('Help'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Help()),
                );
              },
            )
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          setState(() {
            currentIndex = index;
          });
        },
        currentIndex: currentIndex,
        selectedItemColor: Theme.of(context).accentColor,
        selectedIconTheme: IconThemeData(color: Theme.of(context).accentColor),
        type: BottomNavigationBarType.fixed,
        items: [
           BottomNavigationBarItem(
              icon: Icon(
                Icons.home,
              ),
              // ignore: deprecated_member_use
              label: 'home'.tr()),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.group,
              ),
              // ignore: deprecated_member_use
              label: 'interpreters'.tr()),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.wallet_giftcard,
              ),
              // ignore: deprecated_member_use
              label: 'wallet'.tr()),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.person,
              ),
              // ignore: deprecated_member_use
              label: 'help'.tr()),
        ],
      ),
      body: pages[currentIndex],
    );
  }
}
