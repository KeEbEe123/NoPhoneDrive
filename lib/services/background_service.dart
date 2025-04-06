import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';
import 'location_service.dart';
import 'dnd_service.dart';
import 'package:call_log/call_log.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

Future<void> logMissedCalls() async {
  Iterable<CallLogEntry> entries = await CallLog.get();

  for (var entry in entries) {
    if (entry.callType == CallType.missed) {
      await http.post(
        Uri.parse('https://your-backend.com/api/missed-calls'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": entry.name,
          "number": entry.number,
          "timestamp": entry.timestamp,
        }),
      );
    }
  }
}

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: true,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: (service) => onStart(service),
    ),
  );

  service.startService();
}

Future<bool> onStart(ServiceInstance service) async {
  final LocationService _locationService = LocationService();
  final DndService _dndService = DndService();

  service.on('stopService').listen((event) {
    service.stopSelf();
  });

  while (true) {
    double? speed = await _locationService.getCurrentSpeed();
    if (speed != null && speed > 10) {
      await _dndService.enableDND();
    } else {
      await _dndService.disableDND();
    }
    await Future.delayed(const Duration(seconds: 5));
  }
}
