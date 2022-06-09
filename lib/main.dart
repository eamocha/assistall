import 'package:agora_flutter_quickstart/auth/accountTypes.dart';
import 'package:agora_flutter_quickstart/auth/selectCountry.dart';
import 'package:agora_flutter_quickstart/auth/selectLanguage.dart';
import 'package:agora_flutter_quickstart/auth/signUpMain.dart';
import 'package:agora_flutter_quickstart/auth/signin.dart';
import 'package:agora_flutter_quickstart/models/call.dart';
import 'package:agora_flutter_quickstart/repo/callRepo.dart';
import 'package:agora_flutter_quickstart/screens/selectlanguage.dart';
import 'package:agora_flutter_quickstart/src/pages/index.dart';
import 'package:agora_flutter_quickstart/util/ui.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
GetIt getIt = GetIt.instance;
final _navKey = GlobalKey<NavigatorState>();

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  final _uuid = Uuid();
  var _currentUuid;
  var textEvents = '';

  Future.delayed(const Duration(seconds: 2), () async {
    _currentUuid = _uuid.v4();
    var params = <String, dynamic>{
      'id': _currentUuid,
      'nameCaller': message.data['name'],
      'appName': 'Callkit',
      'handle': 'assistALL',
      'type': 0,
      'duration': 30000,
      'extra': <String, dynamic>{'channel': message.data['channel']},
      'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      'android': <String, dynamic>{
        'isCustomNotification': true,
        'isShowLogo': false,
        'ringtonePath': 'ringtone_default',
        'backgroundColor': '#0955fa',
        'background': 'https://i.pravatar.cc/500',
        'actionColor': '#4CAF50'
      },
      'ios': <String, dynamic>{
        'iconName': 'AppIcon40x40',
        'handleType': '',
        'supportsVideo': true,
        'maximumCallGroups': 2,
        'maximumCallsPerCallGroup': 1,
        'audioSessionMode': 'default',
        'audioSessionActive': true,
        'audioSessionPreferredSampleRate': 44100.0,
        'audioSessionPreferredIOBufferDuration': 0.005,
        'supportsDTMF': true,
        'supportsHolding': true,
        'supportsGrouping': false,
        'supportsUngrouping': false,
        'ringtonePath': 'Ringtone.caf'
      }
    };
    await FlutterCallkitIncoming.showCallkitIncoming(params);
    try {
      FlutterCallkitIncoming.onEvent.listen((event) {
        print(event);
        switch (event!.name) {
          case CallEvent.ACTION_CALL_INCOMING:
          // TODO: received an incoming call
            break;
          case CallEvent.ACTION_CALL_START:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
            break;
          case CallEvent.ACTION_CALL_ACCEPT:
            var channel =message.data['channel'];
            print('Third' + channel);

            break;
          case CallEvent.ACTION_CALL_DECLINE:
          // TODO: declined an incoming call
            break;
          case CallEvent.ACTION_CALL_ENDED:
          // TODO: ended an incoming/outgoing call
            break;
          case CallEvent.ACTION_CALL_TIMEOUT:
          // TODO: missed an incoming call
            break;
          case CallEvent.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
            break;
          case CallEvent.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
            break;
        }
      });
    } on Exception {}
  });

  print('Handling a background message: ${message.messageId}');
}

void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(
    EasyLocalization(
        supportedLocales: [
          Locale('en', 'UK'),
          Locale('ar', 'AE'),
          Locale('fr', 'FR'),
          Locale('pt', 'PT'),
          Locale('sw', 'KE'),
          Locale('es', 'SP')],
        path: 'assets/translations', // <-- change the path of the translation files
        fallbackLocale: Locale('en', 'UK'),
        child: MyApp()
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _uuid = Uuid();
  var _currentUuid;
  var textEvents = '';
  CallRepo _callRepo=CallRepo();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listenerEvent();
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      var notification = message.notification;
      var android = message.notification?.android;
      if (notification != null && android != null) {
        _currentUuid = _uuid.v4();
        var params = <String, dynamic>{
          'id': _currentUuid,
          'nameCaller': message.data['name'],
          'appName': 'Callkit',
          'handle': 'assistALL',
          'type': 0,
          'duration': 30000,
          'extra': <String, dynamic>{'channel': message.data['channel']},
          'headers': <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
          'android': <String, dynamic>{
            'isCustomNotification': true,
            'isShowLogo': false,
            'ringtonePath': 'ringtone_default',
            'backgroundColor': '#0955fa',
            'background': 'https://i.pravatar.cc/500',
            'actionColor': '#4CAF50'
          },
          'ios': <String, dynamic>{
            'iconName': 'AppIcon40x40',
            'handleType': '',
            'supportsVideo': true,
            'maximumCallGroups': 2,
            'maximumCallsPerCallGroup': 1,
            'audioSessionMode': 'default',
            'audioSessionActive': true,
            'audioSessionPreferredSampleRate': 44100.0,
            'audioSessionPreferredIOBufferDuration': 0.005,
            'supportsDTMF': true,
            'supportsHolding': true,
            'supportsGrouping': false,
            'supportsUngrouping': false,
            'ringtonePath': 'Ringtone.caf'
          }
        };
        FlutterCallkitIncoming.showCallkitIncoming(params);
        try {
          FlutterCallkitIncoming.onEvent.listen((event) {
            print(event);
            switch (event!.name) {
              case CallEvent.ACTION_CALL_INCOMING:
              // TODO: received an incoming call
                break;
              case CallEvent.ACTION_CALL_START:
              // TODO: started an outgoing call
              // TODO: show screen calling in Flutter
                break;
              case CallEvent.ACTION_CALL_ACCEPT:
                var channel =message.data['channel'];
                print('Two' + channel.toString());
                var params={
                  'channel':channel.toString()
                 };
                _callRepo.joinCall(params).then((value){
                  print(value.message);
                });
                break;
              case CallEvent.ACTION_CALL_DECLINE:
              // TODO: declined an incoming call
                break;
              case CallEvent.ACTION_CALL_ENDED:
              // TODO: ended an incoming/outgoing call
                break;
              case CallEvent.ACTION_CALL_TIMEOUT:
              // TODO: missed an incoming call
                break;
              case CallEvent.ACTION_CALL_CALLBACK:
              // TODO: only Android - click action `Call back` from missed call notification
                break;
              case CallEvent.ACTION_CALL_TOGGLE_HOLD:
              // TODO: only iOS
                break;
              case CallEvent.ACTION_CALL_TOGGLE_MUTE:
              // TODO: only iOS
                break;
              case CallEvent.ACTION_CALL_TOGGLE_DMTF:
              // TODO: only iOS
                break;
              case CallEvent.ACTION_CALL_TOGGLE_GROUP:
              // TODO: only iOS
                break;
              case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
              // TODO: only iOS
                break;
            }
          });
        } on Exception {}
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('A new onMessageOpenedApp event was published!');
      var notification = message.notification;
      var android = message.notification?.android;
      if (notification != null && android != null) {
       /* FlutterRingtonePlayer.stop();
        joinAlert(
            notification.title.toString(),
            notification.body.toString(),
            message.data['channel'].toString());*/
      }
    });

    checkIfAuthenticated();
  }

  void checkIfAuthenticated() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString('accessToken') != null) {

    } else {
      Ui().successToast('Welcome back');
    }
  }


  Future<void> listenerEvent() async {
    // Platform messages may fail, so we use a try/catch PlatformException.
    // We also handle the message potentially returning null.
    try {
      FlutterCallkitIncoming.onEvent.listen((event) {
        print(event);
        if (!mounted) return;
        switch (event!.name) {
          case CallEvent.ACTION_CALL_INCOMING:
          // TODO: received an incoming call
            break;
          case CallEvent.ACTION_CALL_START:
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
            break;
          case CallEvent.ACTION_CALL_ACCEPT:
            var channel =event.body['channel'];
            print('One' + channel.toString());
            break;
          case CallEvent.ACTION_CALL_DECLINE:
          // TODO: declined an incoming call
            break;
          case CallEvent.ACTION_CALL_ENDED:
          // TODO: ended an incoming/outgoing call
            break;
          case CallEvent.ACTION_CALL_TIMEOUT:
          // TODO: missed an incoming call
            break;
          case CallEvent.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
            break;
          case CallEvent.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
            break;
          case CallEvent.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
            break;
        }
        setState(() {
          textEvents += "${event.toString()}\n";
        });
      });
    } on Exception {}
  }



  Future joinAlert(String title, String body, String channel) async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Text(
              body,
              style: GoogleFonts.quicksand(),
            ),
            title: Text(
              title,
              style: GoogleFonts.quicksand(fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              TextButton(
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    Navigator.pop(context);
                  },
                  child: Text(
                    'CANCEL',
                    style: GoogleFonts.quicksand(),
                  )),
              TextButton(
                  onPressed: () {
                    FlutterRingtonePlayer.stop();
                    Navigator.pop(context);


                  },
                  child: Text(
                    'OK',
                    style: GoogleFonts.quicksand(),
                  ))
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'assistALL',
      navigatorKey: _navKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
        textTheme: GoogleFonts.quicksandTextTheme(),
      ),
      onGenerateRoute: (RouteSettings settings) {
        final List<String> pathElements = settings.name!.split('/');
        if (pathElements[0] != '') {
          return null;
        }
        return null;
      },
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: LanguageSelectorScreen(),
    );
  }
}


