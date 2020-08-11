import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io' show File, Platform;

import 'package:rxdart/rxdart.dart';

class NotificationPlugin {
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final BehaviorSubject<ReceivedNotification>
      didReceivedLocalNotificationSubject =
      BehaviorSubject<ReceivedNotification>();
  var initializationSettings;

  NotificationPlugin._() {
    init();
  }

  init() async {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      _requestIOSPermission();
    }
    initializePlatformSpecifics();
  }

  initializePlatformSpecifics() {
    var initializeSettingsAndroid =
        AndroidInitializationSettings('inflammation');
    var initializationSettingsIOS = IOSInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: false,
        onDidReceiveLocalNotification: (id, title, body, payload) async {
          ReceivedNotification receivedNotification = ReceivedNotification(
              id: id, title: title, body: body, payload: payload);
          didReceivedLocalNotificationSubject.add(receivedNotification);
        });

    initializationSettings = InitializationSettings(
        initializeSettingsAndroid, initializationSettingsIOS);
  }

  _requestIOSPermission() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        .requestPermissions(alert: false, badge: true, sound: true);
  }

  setListenerForLowerVersions(Function onNotificationInLowerVersion) {
    didReceivedLocalNotificationSubject.listen((receivedNotification) {
      onNotificationInLowerVersion(receivedNotification);
    });
  }

  setOnNotificationClick(Function onNotificationClick) async {
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String payload) async {
      onNotificationClick(payload);
    });
  }

  Future<void> showNotification() async {
    var androidChannelSpecifics = AndroidNotificationDetails(
        'CHANNEL_ID', 'CHANNEL_NAME', "CHANNEL_DESCRIPTION",
        importance: Importance.Max,
        priority: Priority.High,
        styleInformation: BigTextStyleInformation(''));
    var iosChannelSpecifics = IOSNotificationDetails();
    var platformChannelSpecifics =
        NotificationDetails(androidChannelSpecifics, iosChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        'Test Title',
        'Test Body Lots of text here, more than one line now.',
        platformChannelSpecifics,
        payload: 'Test payload');
  }

  Future<void> scheduleNotification(int id, int time, String message) async {
    var scheduledNotificationDateTime =
        new DateTime.now().add(new Duration(seconds: time));
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'CHANNEL_ID',
      'CHANNEL_NAME',
      'CHANNEL DESCRIPTION',
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: BigTextStyleInformation(''),
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.schedule(
        id,
        'Healthy Posture Reminder',
        message,
        scheduledNotificationDateTime,
        platformChannelSpecifics);
  }

  Future<void> repeatNotification(RepeatInterval interval) async {
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'CHANNEL_ID 2',
      'CHANNEL_NAME 2',
      'CHANNEL DESCRIPTION 2',
      importance: Importance.Max,
      priority: Priority.High,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    NotificationDetails platformChannelSpecifics = new NotificationDetails(
        androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
      0,
      'Posture reminder',
      'Repeating Test Body',
      interval,
      platformChannelSpecifics,
    );
  }

  Future<int> getPendingNotificationCount() async {
    List<PendingNotificationRequest> p =
        await flutterLocalNotificationsPlugin.pendingNotificationRequests();
    return p.length;
  }

  Future<void> cancelNotification() async {
    await flutterLocalNotificationsPlugin.cancel(0);
  }

  Future<void> cancelAllNotification() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}

NotificationPlugin notificationPlugin = NotificationPlugin._();

class ReceivedNotification {
  final int id;
  final String title;
  final String body;
  final String payload;

  ReceivedNotification({
    this.id,
    this.title,
    this.body,
    this.payload,
  });
}
