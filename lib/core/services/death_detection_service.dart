import 'dart:async';
import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import '../models/sync_models.dart';
import './encryption_service.dart';
import './inheritance_service.dart';
import './local_storage_service.dart';
import 'encryption_service.dart';
import 'inheritance_service.dart';
import 'local_storage_service.dart';

class DeathDetectionService {
  static final DeathDetectionService _instance =
      DeathDetectionService._internal();
  factory DeathDetectionService() => _instance;
  DeathDetectionService._internal();

  static const _storage = FlutterSecureStorage();
  final _localAuth = LocalAuthentication();

  Timer? _heartbeatTimer;
  Timer? _checkInTimer;
  Timer? _deadManSwitchTimer;

  final _statusController = StreamController<DeathDetectionState>.broadcast();
  DeathDetectionState? _currentState;

  Stream<DeathDetectionState> get statusStream => _statusController.stream;
  DeathDetectionState? get currentState => _currentState;

  // Initialize death detection system
  Future<void> initialize(String userId) async {
    final savedState = await _loadState(userId);

    _currentState =
        savedState ??
        DeathDetectionState(
          userId: userId,
          lastHeartbeat: DateTime.now().millisecondsSinceEpoch,
          checkInInterval: 24 * 60 * 60 * 1000, // 24 hours
          gracePeriod: 7 * 24 * 60 * 60 * 1000, // 7 days
          status: 'active',
          notifiedNominees: [],
        );

    await _saveState();
    _startHeartbeatMonitoring();
    _startCheckInReminders();

    _statusController.add(_currentState!);
  }

  // Update heartbeat - user is alive
  Future<void> updateHeartbeat({Map<String, dynamic>? metadata}) async {
    if (_currentState == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;

    // Require biometric authentication for heartbeat
    final isAuthenticated = await _authenticateUser();
    if (!isAuthenticated) {
      throw Exception('Biometric authentication required for heartbeat');
    }

    _currentState = DeathDetectionState(
      userId: _currentState!.userId,
      lastHeartbeat: now,
      checkInInterval: _currentState!.checkInInterval,
      gracePeriod: _currentState!.gracePeriod,
      status: 'active',
      notifiedNominees: [],
    );

    await _saveState();

    // Generate heartbeat signal
    final signal = HeartbeatSignal(
      userId: _currentState!.userId,
      deviceId: await _getDeviceId(),
      timestamp: now,
      status: 'alive',
      metadata: metadata,
      signature: await _generateHeartbeatSignature(now),
    );

    // Store heartbeat signal
    await LocalStorageService().storeHeartbeatSignal(signal);

    // Reset timers
    _resetTimers();

    _statusController.add(_currentState!);
  }

  // Configure check-in settings
  Future<void> configureSettings({
    int? checkInIntervalHours,
    int? gracePeriodDays,
  }) async {
    if (_currentState == null) return;

    _currentState = DeathDetectionState(
      userId: _currentState!.userId,
      lastHeartbeat: _currentState!.lastHeartbeat,
      checkInInterval:
          checkInIntervalHours != null
              ? checkInIntervalHours * 60 * 60 * 1000
              : _currentState!.checkInInterval,
      gracePeriod:
          gracePeriodDays != null
              ? gracePeriodDays * 24 * 60 * 60 * 1000
              : _currentState!.gracePeriod,
      status: _currentState!.status,
      warningStarted: _currentState!.warningStarted,
      deadManSwitchActivated: _currentState!.deadManSwitchActivated,
      notifiedNominees: _currentState!.notifiedNominees,
    );

    await _saveState();
    _resetTimers();

    _statusController.add(_currentState!);
  }

  // Start heartbeat monitoring
  void _startHeartbeatMonitoring() {
    _heartbeatTimer = Timer.periodic(
      const Duration(minutes: 30), // Check every 30 minutes
      (timer) => _checkHeartbeatStatus(),
    );
  }

  // Start check-in reminders
  void _startCheckInReminders() {
    _checkInTimer = Timer.periodic(
      Duration(
        milliseconds: _currentState!.checkInInterval ~/ 4,
      ), // Remind at 25%, 50%, 75%
      (timer) => _sendCheckInReminder(),
    );
  }

  // Check heartbeat status
  Future<void> _checkHeartbeatStatus() async {
    if (_currentState == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final timeSinceLastHeartbeat = now - _currentState!.lastHeartbeat;

    String newStatus = _currentState!.status;
    int? warningStarted = _currentState!.warningStarted;
    int? deadManSwitchActivated = _currentState!.deadManSwitchActivated;

    if (timeSinceLastHeartbeat > _currentState!.checkInInterval) {
      if (_currentState!.status == 'active') {
        newStatus = 'warning';
        warningStarted = now;
        await _notifyNominees('User missed check-in. Grace period started.');
      }

      if (timeSinceLastHeartbeat >
          _currentState!.checkInInterval + _currentState!.gracePeriod) {
        if (_currentState!.status != 'confirmed') {
          newStatus = 'critical';
          await _activateDeadManSwitch();
        }
      }
    }

    if (newStatus != _currentState!.status) {
      _currentState = DeathDetectionState(
        userId: _currentState!.userId,
        lastHeartbeat: _currentState!.lastHeartbeat,
        checkInInterval: _currentState!.checkInInterval,
        gracePeriod: _currentState!.gracePeriod,
        status: newStatus,
        warningStarted: warningStarted,
        deadManSwitchActivated: deadManSwitchActivated,
        notifiedNominees: _currentState!.notifiedNominees,
      );

      await _saveState();
      _statusController.add(_currentState!);
    }
  }

  // Send check-in reminder
  Future<void> _sendCheckInReminder() async {
    if (_currentState == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;
    final timeSinceLastHeartbeat = now - _currentState!.lastHeartbeat;
    final reminderThreshold = _currentState!.checkInInterval * 0.75;

    if (timeSinceLastHeartbeat > reminderThreshold &&
        _currentState!.status == 'active') {
      // Send reminder notification to user
      // This would integrate with your notification system
    }
  }

  // Activate dead man's switch
  Future<void> _activateDeadManSwitch() async {
    if (_currentState == null) return;

    final now = DateTime.now().millisecondsSinceEpoch;

    _deadManSwitchTimer = Timer(
      const Duration(hours: 24), // Final 24-hour warning
      () => _confirmDeath(),
    );

    _currentState = DeathDetectionState(
      userId: _currentState!.userId,
      lastHeartbeat: _currentState!.lastHeartbeat,
      checkInInterval: _currentState!.checkInInterval,
      gracePeriod: _currentState!.gracePeriod,
      status: 'critical',
      warningStarted: _currentState!.warningStarted,
      deadManSwitchActivated: now,
      notifiedNominees: _currentState!.notifiedNominees,
    );

    await _saveState();
    await _notifyNominees(
      'CRITICAL: Dead man\'s switch activated. 24 hours remaining.',
    );
  }

  // Confirm death and trigger inheritance
  Future<void> _confirmDeath() async {
    if (_currentState == null) return;

    _currentState = DeathDetectionState(
      userId: _currentState!.userId,
      lastHeartbeat: _currentState!.lastHeartbeat,
      checkInInterval: _currentState!.checkInInterval,
      gracePeriod: _currentState!.gracePeriod,
      status: 'confirmed',
      warningStarted: _currentState!.warningStarted,
      deadManSwitchActivated: _currentState!.deadManSwitchActivated,
      notifiedNominees: _currentState!.notifiedNominees,
    );

    await _saveState();

    // Trigger inheritance process
    await InheritanceService().triggerInheritance(_currentState!.userId);

    await _notifyNominees('Death confirmed. Inheritance process initiated.');

    _statusController.add(_currentState!);
  }

  // Notify nominees
  Future<void> _notifyNominees(String message) async {
    // This would send notifications to all nominees
    // Implementation depends on your notification system
  }

  // Authenticate user with biometrics
  Future<bool> _authenticateUser() async {
    try {
      final isAvailable = await _localAuth.isDeviceSupported();
      if (!isAvailable) return true; // Skip if biometrics not available

      return await _localAuth.authenticate(
        localizedReason: 'Authenticate to confirm you are alive',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }

  // Generate heartbeat signature
  Future<String> _generateHeartbeatSignature(int timestamp) async {
    final key = await _getSigningKey();
    final data = '${_currentState!.userId}:$timestamp:alive';
    return EncryptionService.generateHMAC(data, key);
  }

  // Get signing key
  Future<String> _getSigningKey() async {
    String? key = await _storage.read(key: 'heartbeat_signing_key');
    return key;
  }

  // Get device ID
  Future<String> _getDeviceId() async {
    String? deviceId = await _storage.read(key: 'device_id');
    return deviceId;
  }

  // Save state
  Future<void> _saveState() async {
    if (_currentState == null) return;

    final stateJson = jsonEncode(_currentState!.toJson());
    await _storage.write(
      key: 'death_detection_state_${_currentState!.userId}',
      value: stateJson,
    );
  }

  // Load state
  Future<DeathDetectionState?> _loadState(String userId) async {
    final stateJson = await _storage.read(key: 'death_detection_state_$userId');
    if (stateJson == null) return null;

    final stateMap = jsonDecode(stateJson) as Map<String, dynamic>;
    return DeathDetectionState.fromJson(stateMap);
  }

  // Reset timers
  void _resetTimers() {
    _heartbeatTimer?.cancel();
    _checkInTimer?.cancel();
    _deadManSwitchTimer?.cancel();

    _startHeartbeatMonitoring();
    _startCheckInReminders();
  }

  // Dispose resources
  void dispose() {
    _heartbeatTimer?.cancel();
    _checkInTimer?.cancel();
    _deadManSwitchTimer?.cancel();
    _statusController.close();
  }
}
