import 'package:flutter/material.dart';
import 'package:do_not_disturb/do_not_disturb.dart';
import '../services/dnd_service.dart';
import '../services/location_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DndService _dndService = DndService();
  final LocationService _locationService = LocationService();

  bool _isDndActive = false;
  bool _hasDndPermission = false;
  double _currentSpeed = 0.0;

  @override
  void initState() {
    super.initState();
    _checkDndPermission();
    _checkDndStatus();
    _updateSpeed();
  }

  /// Checks if DND permission is granted
  Future<void> _checkDndPermission() async {
    bool permission = await _dndService.hasDndPermission();
    setState(() {
      _hasDndPermission = permission;
    });

    // If permission is missing, ask for it
    if (!permission) {
      _dndService.requestPermissions(context).then((_) {
        _checkDndPermission(); // Re-check permission after user action
      });
    }
  }

  /// Checks if DND mode is active
  Future<void> _checkDndStatus() async {
    bool isActive = await _dndService.isDndActive();
    setState(() {
      _isDndActive = isActive;
    });
  }

  /// Continuously updates speed and toggles DND accordingly
  Future<void> _updateSpeed() async {
    while (mounted) {
      double? speed = await _locationService.getCurrentSpeed();
      if (speed != null) {
        setState(() {
          _currentSpeed = speed;
        });

        // Log speed to the console
        debugPrint("Current Speed: $_currentSpeed km/h");

        // Toggle DND based on speed
        if (speed > 1) {
          await _dndService.enableDND();
        } else {
          await _dndService.disableDND();
        }

        _checkDndStatus();
      }

      await Future.delayed(
        const Duration(seconds: 2),
      ); // Update every 2 seconds
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('NoPhoneDrive')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Current Speed: ${_currentSpeed.toStringAsFixed(1)} km/h',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'NoPhoneDrive: ${_isDndActive ? "Active" : "Inactive"}',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: _isDndActive ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),

            // Show "Grant DND Permission" button only if permission is missing
            if (!_hasDndPermission)
              ElevatedButton(
                onPressed:
                    () => _dndService.requestPermissions(context).then((_) {
                      _checkDndPermission(); // Re-check permission after user action
                    }),
                child: const Text("Grant DND Permission"),
              ),
          ],
        ),
      ),
    );
  }
}
