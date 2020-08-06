import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_posture/MessageGenerator.dart';
import 'package:healthy_posture/NotificationPlugin.dart';

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
  String _reminder = "";
  bool _remindNotifications = true;
  @override
  void initState() {
    super.initState();
    notificationPlugin
        .setListenerForLowerVersions(onNotificationInLowerVersions);
    notificationPlugin.setOnNotificationClick(onNotificationClick);
    setState(() {
      _reminder = messageGeneratorPlugin.getMessage(false);
      _remindNotifications = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    //Temporary. Remove at some point
    setState(() {
      _reminder = messageGeneratorPlugin.getMessage(false);
    });

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
                  new Icon(Icons.insert_emoticon,
                      color: Theme.of(context).highlightColor, size: 200.0),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 42.0, 24.0, 24.0),
                  ),
                  new Container(
                    width: screenWidth * 0.65,
                    child: new Text(
                      _reminder,
                      textAlign: TextAlign.center,
                      style: new TextStyle(
                          fontSize: 25.0,
                          color: Theme.of(context).highlightColor,
                          fontWeight: FontWeight.w200,
                          fontFamily: "Roboto"),
                    ),
                  ),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 42.0, 24.0, 24.0),
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        new Switch(
                            onChanged: switchChanged,
                            value: _remindNotifications),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                        ),
                        new Text(
                          "Notifications",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                      ]),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                  ),
                  new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        IconButton(
                          icon: Icon(Icons.settings,
                              color: Theme.of(context).accentColor, size: 30.0),
                          tooltip: "App settings",
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SettingsRoute()),
                            );
                          },
                        ),
                        new Padding(
                          padding:
                              const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                        ),
                        new Text(
                          "Settings     ",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                      ]),
                  new Padding(
                    padding: const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                  ),
                  new Row(
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
                              const EdgeInsets.fromLTRB(24.0, 12.0, 24.0, 24.0),
                        ),
                        new Text(
                          "Messages",
                          style: new TextStyle(
                              fontSize: 12.0,
                              color: Theme.of(context).highlightColor,
                              fontWeight: FontWeight.w200,
                              fontFamily: "Roboto"),
                        )
                      ]),
                  Center(
                      child: FlatButton(
                    onPressed: () async {
                      await notificationPlugin.showNotification();
                      //await notificationPlugin.scheduleNotification(2,
                      //   "Would be a shame if you'd sit like a banana right now...");
                      //await notificationPlugin.repeatNotification();
                    },
                    child: Text('Send Notification'),
                  )),
                ])
          ]),
    );
  }

  void switchChanged(bool value) {
    setState(() {
      _remindNotifications = value;
    });
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {}
}

class SettingsRoute extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
      ),
      body: Center(
        child: RaisedButton(
          onPressed: () {
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
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
            // Navigate back to first route when tapped.
          },
          child: Text('Go back!'),
        ),
      ),
    );
  }
}
