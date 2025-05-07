import 'dart:io';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications = FlutterLocalNotificationsPlugin();

  Future<void> initialize() async {
    tz.initializeTimeZones();

    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTapped,
      onDidReceiveBackgroundNotificationResponse: _onBackgroundNotificationTapped,
    );

    // Request permission for iOS
    await _notifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // Request exact alarm permission for Android
    if (Platform.isAndroid) {
      final androidPlugin = _notifications
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>();
      if (androidPlugin != null) {
        await androidPlugin.requestExactAlarmsPermission();
      }
    }
  }

  void _onNotificationTapped(NotificationResponse response) {
    // Handle notification tap when app is in foreground
    debugPrint('Foreground notification tapped: ${response.payload}');
    // You can navigate to specific screen or show a dialog here
  }

  @pragma('vm:entry-point')
  static void _onBackgroundNotificationTapped(NotificationResponse response) {
    // Handle notification tap when app is in background
    debugPrint('Background notification tapped: ${response.payload}');
  }

  Future<void> showForegroundNotification({
    required String id,
    required String title,
    required String body,
  }) async {
    await _notifications.show(
      id.hashCode,
      title,
      body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          'appointment_reminders',
          'Appointment Reminders',
          channelDescription: 'Notifications for upcoming appointments',
          importance: Importance.high,
          priority: Priority.high,
          sound: null,
          ongoing: false,
          autoCancel: true,
          showWhen: true,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      ),
      payload: 'appointment_$id',
    );
  }

  Future<void> scheduleAppointmentReminder({
    required String id,
    required String title,
    required String body,
    required DateTime scheduledTime,
    required int minutesBefore,
  }) async {
    final scheduledDateTime = scheduledTime.subtract(Duration(minutes: minutesBefore));
    
    // Check if the appointment is within the next 5 minutes
    final now = DateTime.now();
    final difference = scheduledDateTime.difference(now);
    
    if (difference.inMinutes <= 5 && difference.inMinutes >= 0) {
      // Show immediate notification if within 5 minutes
      await showForegroundNotification(
        id: id,
        title: title,
        body: body,
      );
    } else {
      // Convert to local timezone and ensure it's in the future
      final localScheduledDateTime = tz.TZDateTime.from(scheduledDateTime, tz.local);
      final nowInLocal = tz.TZDateTime.now(tz.local);
      
      if (localScheduledDateTime.isBefore(nowInLocal)) {
        throw Exception('Cannot schedule notification in the past');
      }

      // Schedule future notification
      await _notifications.zonedSchedule(
        id.hashCode,
        title,
        body,
        localScheduledDateTime,
        NotificationDetails(
          android: AndroidNotificationDetails(
            'appointment_reminders',
            'Appointment Reminders',
            channelDescription: 'Notifications for upcoming appointments',
            importance: Importance.high,
            priority: Priority.high,
            sound: null,
            ongoing: false,
            autoCancel: true,
            showWhen: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        payload: 'appointment_$id',
      );
    }
  }

  Future<void> cancelReminder(String id) async {
    await _notifications.cancel(id.hashCode);
  }

  Future<void> cancelAllReminders() async {
    await _notifications.cancelAll();
  }
} 