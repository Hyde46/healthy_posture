import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:healthy_posture/MessageGenerator.dart';
import 'package:healthy_posture/NotificationPlugin.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!await doSettingsExist()) {
    await GlobalConfiguration().loadFromAsset("default_app_settings");
    await createSettingsFile();
  } else {
    var directory = await getApplicationDocumentsDirectory();
    await GlobalConfiguration()
        .loadFromPath(directory.path + "/app_settings.js");
  }
  runApp(new MyApp());
}

doSettingsExist() async {
  var directory = await getApplicationDocumentsDirectory();
  var file = File(directory.path + "/app_settings.js");
  print(file);
  return await file.exists();
}

createSettingsFile() async {
  var directory = await getApplicationDocumentsDirectory();
  await File(directory.path + '/app_settings.js')
      .writeAsString(jsonEncode(GlobalConfiguration().appConfig));
  print("maybe created file");
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
      _remindNotifications =
          GlobalConfiguration().getBool("allow_notifications");
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
    GlobalConfiguration().updateValue("allow_notifications", value);
    String config_file_json = jsonEncode(GlobalConfiguration().appConfig);
    saveConfigJson(config_file_json);
  }

  onNotificationInLowerVersions(ReceivedNotification receivedNotification) {
    print('Notification Received ${receivedNotification.id}');
  }

  onNotificationClick(String payload) {}

  Future<String> get _localPath async {
    var directory;
    if (!kIsWeb) {
      directory = await getApplicationDocumentsDirectory();
    } else {
      print("In Web debug mode. Skipping...");
      return null;
    }

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/app_settings.json');
  }

  Future<File> saveConfigJson(String config_json) async {
    final file = await _localFile;
    return file.writeAsString('$config_json');
  }
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
