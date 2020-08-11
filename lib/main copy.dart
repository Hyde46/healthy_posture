/*import 'dart:collection';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:PostureReminder/MessageGenerator.dart';
import 'package:PostureReminder/NotificationPlugin.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_admob/firebase_admob.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light));
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Generated App',
      theme: new ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFF84a59d),
        accentColor: const Color(0xFFf28482),
        canvasColor: const Color(0xFFf7ede2),
        highlightColor: const Color(0xFF6d6875),
      ),
      home: new MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //Adds stuff
  InterstitialAd myInterstitial;
  // App Internals
  String _reminder = "";
  bool _showNotifications;
  String _notificationInterval;
  String _messageTypeText;
  int _sessionLength;
  bool _isSarcasticReminderText;

  InterstitialAd buildInterstitialAd() {
    return InterstitialAd(
      adUnitId: InterstitialAd.testAdUnitId,
      listener: (MobileAdEvent event) {
        if (event == MobileAdEvent.failedToLoad) {
          myInterstitial..load();
        } else if (event == MobileAdEvent.closed) {
          myInterstitial = buildInterstitialAd()..load();
        }
        print(event);
      },
    );
  }

  void showInterstitialAd() {
    myInterstitial..show();
  }

  void showRandomInterstitialAd() {
    Random r = new Random();
    bool value = r.nextBool();

    if (value == true) {
      myInterstitial..show();
    }
  }

  @override
  void initState() {
    super.initState();

    /// Assign a listener.
    var eventListener = (MobileAdEvent event) {
      if (event == MobileAdEvent.opened) {
        print("eventListener: The opened ad is clicked on.");
      }
    };

    /// Notification Plugin
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);

    /// App Settings
    setState(() {
      _reminder = messageGeneratorPlugin.getMessage(false);
      _showNotifications = false;
      _isSarcasticReminderText = true;
      _sessionLength = 30;
      _notificationInterval = "Hourly";
      _messageTypeText = "Sarcastic Reminder";
    });
    loadSettings().then((result) {
      setState(() {
        _showNotifications = result["allow_notifications"];
        _isSarcasticReminderText = result["is_sarcastic_reminders"];
        _notificationInterval = result["notification_interval"];
        _sessionLength = result["session_length"];
        if (result["is_sarcastic_reminder"]) {
          _messageTypeText = "Sarcastic Reminder";
          _reminder = messageGeneratorPlugin.getMessage(false);
        } else {
          _messageTypeText = "Serious Reminder  ";
          _reminder = messageGeneratorPlugin.getMessage(true);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screeHeight = MediaQuery.of(context).size.height;
    _reminder = messageGeneratorPlugin.getMessage(!_isSarcasticReminderText);
    return new Scaffold(
      body: new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  new Image(
                    image: AssetImage('assets/inflammation.png'),
                    width: 160,
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 24.0, 24.0, 24.0),
                  ),
                  new Container(
                    width: screenWidth * 0.65,
                    height: screeHeight * 0.175,
                    child: new Text(
                      _reminder,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 22.0,
                          color: Theme.of(context).highlightColor,
                          fontWeight: FontWeight.w200,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                  ),
                  /*
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Switch(
                            onChanged: switchChanged,
                            value: _showNotifications),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(34.0, 12.0, 24.0, 24.0),
                        ),
                        new Text(
                          "Notifications",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                      ]),*/
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(12.0, 12.0, 24.0, 24.0),
                        ),
                        new Switch(
                            onChanged: sarcasticReminderSwitchChanged,
                            value: _isSarcasticReminderText),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(32.0, 12.0, 24.0, 24.0),
                        ),
                        new Text(
                          _messageTypeText,
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                      ]),
                  /* new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 24.0, 24.0, 24.0),
                        ),
                        DropdownButton<String>(
                          value: _notificationInterval,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: Theme.of(context).highlightColor),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).accentColor,
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              _notificationInterval = newValue;
                            });
                            print('Saving $newValue');
                            _saveString("notification_interval", newValue);
                          },
                          items: <String>[
                            "Every Minute",
                            "Hourly",
                            "Daily",
                            "Weekly"
                          ].map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 24.0, 24.0, 0.0),
                        ),
                        new Text(
                          "Notification interval",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                      ]),*/
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Text(
                          "Remind me every     ",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        ),
                        DropdownButton<int>(
                          value: _sessionLength,
                          icon: Icon(Icons.arrow_downward),
                          iconSize: 24,
                          elevation: 16,
                          style: TextStyle(
                              color: Theme.of(context).highlightColor),
                          underline: Container(
                            height: 2,
                            color: Theme.of(context).accentColor,
                          ),
                          onChanged: (int newValue) {
                            setState(() {
                              _sessionLength = newValue;
                            });
                            _saveInt("session_length", newValue);
                          },
                          items: <int>[
                            2,
                            5,
                            10,
                            15,
                            30,
                            45,
                            60,
                            75,
                            90,
                            100,
                            110,
                            120
                          ].map<DropdownMenuItem<int>>((int value) {
                            return DropdownMenuItem<int>(
                              value: value,
                              child: Text(value.toString() + " min"),
                            );
                          }).toList(),
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(0.0, 24.0, 24.0, 0.0),
                        ),
                      ]),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 0.0, 24.0, 24.0),
                  ),
                  /*new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.chat_bubble_outline,
                              color: Theme.of(context).accentColor, size: 30.0),
                          tooltip: "See messages",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => MessagesRoute()),
                            );
                          },
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(34.0, 12.0, 24.0, 24.0),
                        ),
                        new Text(
                          "Messages",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                      ]),*/
                  Center(
                      child: ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: [
                      OutlineButton(
                        onPressed: () async {
                          await notificationPlugin.cancelAllNotification();
                          if (_sessionLength == null) {
                            showMissingLengthDialog(context);
                          } else {
                            dispatchNotifications();
                            showStartDialog(context, _sessionLength);
                          }
                          //await notificationPlugin.repeatNotification();
                        },
                        textColor: Theme.of(context).highlightColor,
                        child: Text('Remind me!'),
                      ),
                      OutlineButton(
                        onPressed: () async {
                          await notificationPlugin.cancelAllNotification();
                          showStopDialog(context);
                        },
                        textColor: Theme.of(context).highlightColor,
                        child: Text('Stop reminding me!'),
                      )
                    ],
                  )),
                ])
          ]),
    );
  }

  dispatchNotifications() async {
    //await notificationPlugin.showNotification();
    int maxDuration = 2 * 60 * 60; // 2 hours
    int currentTime = 0;
    int idCounter = 0;
    while (currentTime < maxDuration) {
      print("scheduled notification $currentTime");
      String message =
          messageGeneratorPlugin.getMessage(!_isSarcasticReminderText);
      await notificationPlugin.scheduleNotification(
          idCounter, currentTime, message);
      currentTime = currentTime + _sessionLength * 60;
      idCounter++;
    }
  }

  void switchChanged(bool value) async {
    setState(() {
      _showNotifications = value;
    });
    if (value) {
      // Turn on repeated Notifications
      var interval = stringToInterval(_notificationInterval);
      print("Turn on notifications");
      print(interval);
    } else {
      // Turn off repeated notifications
      await notificationPlugin.cancelAllNotification();
    }
    _saveBool("allow_notifications", value);
  }

  RepeatInterval stringToInterval(String value) {
    if (value == "Every Minute") {
      return RepeatInterval.EveryMinute;
    } else if (value == "Hourly") {
      return RepeatInterval.Hourly;
    } else if (value == "Daily") {
      return RepeatInterval.Daily;
    } else if (value == "Weekly") {
      return RepeatInterval.Weekly;
    } else {
      return RepeatInterval.Hourly;
    }
  }

  void sarcasticReminderSwitchChanged(bool value) {
    setState(() {
      _isSarcasticReminderText = value;
      if (value) {
        _messageTypeText = "Sarcastic Reminder";
        _reminder = messageGeneratorPlugin.getMessage(false);
      } else {
        _messageTypeText = "Serious   Reminder";
        _reminder = messageGeneratorPlugin.getMessage(true);
      }
    });
    _saveBool("is_sarcastic_reminders", value);
  }

  showMissingLengthDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Healthy Posture Reminders"),
      content: Text("Please specify how often you want to get reminded"),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showStopDialog(BuildContext context) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Healthy Posture Reminders"),
      content: Text("No more notifications coming."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showStartDialog(BuildContext context, int interval) {
    // set up the button
    Widget okButton = FlatButton(
      child: Text("OK"),
      onPressed: () {
        Navigator.of(context).pop(); // dismiss dialog
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Healthy Posture Reminders"),
      content: Text(
          "Starting to remind you every $interval minutes for the next 2 hours. Press 'Stop reminders' to stop getting notifications."),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {
    print('Payload $payload');
  }

  _saveBool(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(key, value);
  }

  _saveInt(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  _saveString(key, value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Future<bool> getBoolValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    bool boolValue = prefs.getBool(key);
    return boolValue;
  }

  Future<int> getIntValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    int intValue = prefs.getInt(key);
    return intValue;
  }

  Future<String> getStringValuesSF(String key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //Return bool
    String stringValue = prefs.getString(key);
    return stringValue;
  }

  Future<HashMap<String, dynamic>> loadSettings() async {
    bool showNotifications =
        await getBoolValuesSF("allow_notifications") ?? true;
    bool sarcasticReminders =
        await getBoolValuesSF("is_sarcastic_reminders") ?? true;
    String notificationInterval =
        await getStringValuesSF("notification_interval") ?? "Hourly";
    HashMap m = HashMap<String, dynamic>();
    m.putIfAbsent("allow_notifications", () => showNotifications);
    m.putIfAbsent("is_sarcastic_reminders", () => sarcasticReminders);
    m.putIfAbsent("notification_interval", () => notificationInterval);
    return m;
  }
}

class MessagesRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Messages"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
*/
