import 'dart:async';
import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:nearby_connections/nearby_connections.dart';
import 'package:synchronized/synchronized.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

import '../models/sync_models.dart';
import './encryption_service.dart';
import './local_storage_service.dart';
import 'encryption_service.dart';
import 'local_storage_service.dart';
import 'merkle_tree_service.dart';

class SyncService {
  static final SyncService _instance = SyncService._internal();
  factory SyncService() => _instance;
  SyncService._internal();

  final _lock = Lock();
  final _syncStatusController = StreamController<SyncStatus>.broadcast();
  final _deviceConnections = <String, DeviceConnection>{};

  WebSocketChannel? _websocketChannel;
  bool _isInitialized = false;
  String? _currentUserId;
  String? _currentDeviceId;

  Stream<SyncStatus> get syncStatusStream => _syncStatusController.stream;

  // Initialize sync service
  Future<void> initialize(String userId, String deviceId) async {
    if (_isInitialized) return;

    _currentUserId = userId;
    _currentDeviceId = deviceId;

    await _initializeBluetoothSync();
    await _initializeNearbyConnections();
    await _initializeWebSocketSync();

    _isInitialized = true;
    _syncStatusController.add(SyncStatus.initialized);
  }

  // Start sync process
  Future<void> startSync() async {
    return _lock.synchronized(() async {
      if (!_isInitialized) {
        throw Exception('Sync service not initialized');
      }

      _syncStatusController.add(SyncStatus.syncing);

      try {
        // Check connectivity
        final connectivity = await Connectivity().checkConnectivity();

        if (connectivity.contains(ConnectivityResult.wifi) ||
            connectivity.contains(ConnectivityResult.mobile)) {
          await _performInternetSync();
        }

        // Always try local sync
        await _performBluetoothSync();
        await _performNearbySync();

        _syncStatusController.add(SyncStatus.completed);
      } catch (e) {
        _syncStatusController.add(SyncStatus.error);
        rethrow;
      }
    });
  }

  // Perform internet-based sync
  Future<void> _performInternetSync() async {
    if (_websocketChannel == null) return;

    // Get local changes
    final localChanges = await LocalStorageService().getPendingSyncDeltas();

    for (final delta in localChanges) {
      final syncPacket = await _createSyncPacket(delta);
      _websocketChannel!.sink.add(jsonEncode(syncPacket.toJson()));
    }

    // Wait for acknowledgments and apply remote changes
    await _processRemoteChanges();
  }

  // Perform Bluetooth sync
  Future<void> _performBluetoothSync() async {
    try {
      // Scan for nearby devices
      await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

      final devices = await FlutterBluePlus.scanResults.first;

      for (final result in devices) {
        if (_isLegacyVaultDevice(result)) {
          await _connectAndSyncBluetooth(result.device);
        }
      }
    } catch (e) {
      // Bluetooth not available or permission denied
    }
  }

  // Perform nearby connections sync
  Future<void> _performNearbySync() async {
    try {
      // Start advertising
      await NearbyConnections().startAdvertising(
        'legacy_vault_user',
        Strategy.P2P_CLUSTER,
        onConnectionInitiated: _onNearbyConnectionInitiated,
        onConnectionResult: _onNearbyConnectionResult,
        onDisconnected: _onNearbyDisconnected,
      );

      // Start discovery
      await NearbyConnections().startDiscovery(
        'legacy_vault_user',
        Strategy.P2P_CLUSTER,
        onEndpointFound: _onNearbyEndpointFound,
        onEndpointLost: _onNearbyEndpointLost,
      );
    } catch (e) {
      // Nearby connections not available
    }
  }

  // Create sync packet
  Future<SyncPacket> _createSyncPacket(SyncDelta delta) async {
    final encryptedData = await _encryptSyncData(delta.toJson());
    final checksum = EncryptionService.generateHash(jsonEncode(encryptedData));

    return SyncPacket(
      id: delta.id,
      deviceId: _currentDeviceId!,
      userId: _currentUserId!,
      timestamp: DateTime.now().millisecondsSinceEpoch,
      dataType: delta.recordType,
      encryptedData: encryptedData,
      checksum: checksum,
      version: 1,
    );
  }

  // Encrypt sync data
  Future<Map<String, dynamic>> _encryptSyncData(
    Map<String, dynamic> data,
  ) async {
    final key = EncryptionService.generateKey();
    final iv = EncryptionService.generateIV();
    final encryptedData = EncryptionService.encryptData(
      jsonEncode(data),
      key,
      iv,
    );

    return {'data': encryptedData, 'iv': iv.base64, 'key': key.base64};
  }

  // Process remote changes
  Future<void> _processRemoteChanges() async {
    // This would handle incoming sync packets from remote devices
    // Apply changes using eventual consistency with conflict resolution
  }

  // Initialize Bluetooth sync
  Future<void> _initializeBluetoothSync() async {
    try {
      if (await FlutterBluePlus.isSupported) {
        await FlutterBluePlus.turnOn();
      }
    } catch (e) {
      // Bluetooth not available
    }
  }

  // Initialize nearby connections
  Future<void> _initializeNearbyConnections() async {
    try {
      await NearbyConnections().initialize();
    } catch (e) {
      // Nearby connections not available
    }
  }

  // Initialize WebSocket sync
  Future<void> _initializeWebSocketSync() async {
    try {
      // This would connect to your backend WebSocket server
      // _websocketChannel = WebSocketChannel.connect(
      //   Uri.parse('wss://your-sync-server.com/sync'),
      // );
    } catch (e) {
      // WebSocket connection failed
    }
  }

  // Check if device is a Legacy Vault device
  bool _isLegacyVaultDevice(ScanResult result) {
    return result.device.localName.contains('LegacyVault') ||
        result.advertisementData.localName?.contains('LegacyVault') == true;
  }

  // Connect and sync via Bluetooth
  Future<void> _connectAndSyncBluetooth(BluetoothDevice device) async {
    try {
      await device.connect();

      // Discover services and exchange sync data
      final services = await device.discoverServices();

      // Find Legacy Vault sync service
      for (final service in services) {
        if (service.uuid.toString().contains('legacy-vault-sync')) {
          await _exchangeSyncDataBluetooth(service);
        }
      }

      await device.disconnect();
    } catch (e) {
      // Connection failed
    }
  }

  // Exchange sync data via Bluetooth
  Future<void> _exchangeSyncDataBluetooth(BluetoothService service) async {
    // Implementation would exchange encrypted sync packets
  }

  // Nearby connections callbacks
  void _onNearbyConnectionInitiated(String endpointId, ConnectionInfo info) {
    // Handle connection initiation
  }

  void _onNearbyConnectionResult(String endpointId, Status status) {
    if (status == Status.CONNECTED) {
      _deviceConnections[endpointId] = DeviceConnection(
        endpointId: endpointId,
        status: ConnectionStatus.connected,
        connectedAt: DateTime.now(),
      );
    }
  }

  void _onNearbyDisconnected(String endpointId) {
    _deviceConnections.remove(endpointId);
  }

  void _onNearbyEndpointFound(String endpointId, DiscoveredEndpointInfo info) {
    if (info.endpointName.contains('legacy_vault')) {
      NearbyConnections().requestConnection(
        'legacy_vault_${_currentDeviceId}',
        endpointId,
        onConnectionInitiated: _onNearbyConnectionInitiated,
        onConnectionResult: _onNearbyConnectionResult,
        onDisconnected: _onNearbyDisconnected,
      );
    }
  }

  void _onNearbyEndpointLost(String endpointId) {
    _deviceConnections.remove(endpointId);
  }

  // Dispose resources
  void dispose() {
    _syncStatusController.close();
    _websocketChannel?.sink.close();
    FlutterBluePlus.stopScan();
    NearbyConnections().stopAllEndpoints();
  }
}

enum SyncStatus { idle, initialized, syncing, completed, error }

class DeviceConnection {
  final String endpointId;
  final ConnectionStatus status;
  final DateTime connectedAt;

  DeviceConnection({
    required this.endpointId,
    required this.status,
    required this.connectedAt,
  });
}

enum ConnectionStatus { connecting, connected, disconnected, error }
