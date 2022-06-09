import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:uuid/uuid.dart';

class CallScreen extends StatefulWidget {

  @override
  _CallScreenState createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _uuid = Uuid();
  var _currentUuid;
  var textEvents = '';

  @override
  void initState() {
    super.initState();
    listenerEvent();
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
          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).accentColor,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.call,
                color: Colors.white,
              ),
              onPressed: () async {
                this.makeFakeCallInComing();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.call_end,
                color: Colors.white,
              ),
              onPressed: () async {
                this.endCurrentCall();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.call_made,
                color: Colors.white,
              ),
              onPressed: () async {
                this.startOutGoingCall();
              },
            ),
            IconButton(
              icon: Icon(
                Icons.call_merge,
                color: Colors.white,
              ),
              onPressed: () async {
                this.activeCalls();
              },
            )
          ],
        ),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints viewportConstraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: viewportConstraints.maxHeight,
                ),
                child: Text('$textEvents'),
              ),
            );
          },
        ),
      ),
    );
  }

  Future<void> makeFakeCallInComing() async {
    await Future.delayed(const Duration(seconds: 2), () async {
      _currentUuid = _uuid.v4();
      var params = <String, dynamic>{
        'id': _currentUuid,
        'nameCaller': 'Alvin Odiwuor',
        'appName': 'Callkit',
        'avatar': 'https://i.pravatar.cc/100',
        'handle': 'assistALL',
        'type': 0,
        'duration': 30000,
        'extra': <String, dynamic>{'userId': '1a2b3c4d'},
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
    });
  }

  Future<void> endCurrentCall() async {
    var params = <String, dynamic>{'id': this._currentUuid};
    await FlutterCallkitIncoming.endCall(params);
  }

  Future<void> startOutGoingCall() async {
    this._currentUuid = _uuid.v4();
    var params = <String, dynamic>{
      'id': this._currentUuid,
      'nameCaller': 'Hien Nguyen',
      'handle': '0123456789',
      'type': 1,
      'extra': <String, dynamic>{'userId': '1a2b3c4d'},
      'ios': <String, dynamic>{'handleType': 'number'}
    }; //number/email
    await FlutterCallkitIncoming.startCall(params);
  }

  Future<void> activeCalls() async {
    var calls = await FlutterCallkitIncoming.activeCalls();
    print(calls);
  }
}
