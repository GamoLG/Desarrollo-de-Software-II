import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _plugin = FlutterLocalNotificationsPlugin();
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );
    await _plugin.initialize(settings: settings);

    final androidImpl =
    _plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await androidImpl?.requestNotificationsPermission();
    _initialized = true;
  }

  Future<void> showUvAlert({
    required String districtName,
    required double uvIndex,
  }) async {
    await initialize();
    const androidDetails = AndroidNotificationDetails(
      'wayra_uv_alerts',
      'Alertas de Radiación UV',
      channelDescription: 'Notificaciones cuando el índice UV supera el umbral configurado en Cusco',
      importance: Importance.high,
      priority: Priority.high,
    );
    const details = NotificationDetails(
      android: androidDetails,
      iOS: DarwinNotificationDetails(),
    );

    await _plugin.show(
      id: 101,
      title: 'Alerta UV en $districtName: ${uvIndex.toStringAsFixed(1)}',
      body: 'Radiación superior al umbral configurado. Usa protector FPS 50+ y gafas UV400.',
      notificationDetails: details,
    );
  }
}