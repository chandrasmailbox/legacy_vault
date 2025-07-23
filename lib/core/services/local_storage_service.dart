import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sync_models.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  static const _storage = FlutterSecureStorage();
  Database? _database;

  // Initialize database
  Future<void> initialize() async {
    if (_database != null) return;

    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = '${documentsDirectory.path}/legacy_vault.db';

    _database = await openDatabase(path, version: 1, onCreate: _createTables);
  }

  // Create database tables
  Future<void> _createTables(Database db, int version) async {
    // Sync deltas table
    await db.execute('''
      CREATE TABLE sync_deltas (
        id TEXT PRIMARY KEY,
        operation TEXT NOT NULL,
        record_id TEXT NOT NULL,
        record_type TEXT NOT NULL,
        old_data TEXT,
        new_data TEXT,
        timestamp INTEGER NOT NULL,
        device_id TEXT NOT NULL,
        synced INTEGER DEFAULT 0
      )
    ''');

    // Heartbeat signals table
    await db.execute('''
      CREATE TABLE heartbeat_signals (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        device_id TEXT NOT NULL,
        timestamp INTEGER NOT NULL,
        status TEXT NOT NULL,
        metadata TEXT,
        signature TEXT NOT NULL
      )
    ''');

    // Inheritance keys table
    await db.execute('''
      CREATE TABLE inheritance_keys (
        id TEXT PRIMARY KEY,
        nominee_id TEXT NOT NULL,
        encrypted_key_part TEXT NOT NULL,
        threshold INTEGER NOT NULL,
        total_parts INTEGER NOT NULL,
        part_number INTEGER NOT NULL,
        algorithm TEXT NOT NULL,
        created_at INTEGER NOT NULL,
        expires_at INTEGER
      )
    ''');

    // Encrypted data table
    await db.execute('''
      CREATE TABLE encrypted_data (
        id TEXT PRIMARY KEY,
        user_id TEXT NOT NULL,
        data_type TEXT NOT NULL,
        encrypted_data TEXT NOT NULL,
        iv TEXT NOT NULL,
        timestamp INTEGER NOT NULL
      )
    ''');

    // Notifications table
    await db.execute('''
      CREATE TABLE notifications (
        id TEXT PRIMARY KEY,
        nominee_id TEXT NOT NULL,
        type TEXT NOT NULL,
        message TEXT NOT NULL,
        data TEXT,
        timestamp INTEGER NOT NULL,
        read INTEGER DEFAULT 0
      )
    ''');

    // Death detection states table
    await db.execute('''
      CREATE TABLE death_detection_states (
        user_id TEXT PRIMARY KEY,
        last_heartbeat INTEGER NOT NULL,
        check_in_interval INTEGER NOT NULL,
        grace_period INTEGER NOT NULL,
        status TEXT NOT NULL,
        warning_started INTEGER,
        dead_man_switch_activated INTEGER,
        notified_nominees TEXT NOT NULL
      )
    ''');
  }

  // Sync Deltas operations
  Future<void> storeSyncDelta(SyncDelta delta) async {
    await _ensureInitialized();

    await _database!.insert('sync_deltas', {
      'id': delta.id,
      'operation': delta.operation,
      'record_id': delta.recordId,
      'record_type': delta.recordType,
      'old_data': delta.oldData != null ? jsonEncode(delta.oldData!) : null,
      'new_data': delta.newData != null ? jsonEncode(delta.newData!) : null,
      'timestamp': delta.timestamp,
      'device_id': delta.deviceId,
      'synced': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<SyncDelta>> getPendingSyncDeltas() async {
    await _ensureInitialized();

    final maps = await _database!.query(
      'sync_deltas',
      where: 'synced = ?',
      whereArgs: [0],
      orderBy: 'timestamp ASC',
    );

    return maps
        .map(
          (map) => SyncDelta(
            id: map['id'] as String,
            operation: map['operation'] as String,
            recordId: map['record_id'] as String,
            recordType: map['record_type'] as String,
            oldData:
                map['old_data'] != null
                    ? jsonDecode(map['old_data'] as String)
                    : null,
            newData:
                map['new_data'] != null
                    ? jsonDecode(map['new_data'] as String)
                    : null,
            timestamp: map['timestamp'] as int,
            deviceId: map['device_id'] as String,
          ),
        )
        .toList();
  }

  Future<void> markDeltaAsSynced(String deltaId) async {
    await _ensureInitialized();

    await _database!.update(
      'sync_deltas',
      {'synced': 1},
      where: 'id = ?',
      whereArgs: [deltaId],
    );
  }

  // Heartbeat signals operations
  Future<void> storeHeartbeatSignal(HeartbeatSignal signal) async {
    await _ensureInitialized();

    await _database!.insert('heartbeat_signals', {
      'id': '${signal.userId}_${signal.timestamp}',
      'user_id': signal.userId,
      'device_id': signal.deviceId,
      'timestamp': signal.timestamp,
      'status': signal.status,
      'metadata': signal.metadata != null ? jsonEncode(signal.metadata!) : null,
      'signature': signal.signature,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<HeartbeatSignal>> getHeartbeatSignals(String userId) async {
    await _ensureInitialized();

    final maps = await _database!.query(
      'heartbeat_signals',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'timestamp DESC',
    );

    return maps
        .map(
          (map) => HeartbeatSignal(
            userId: map['user_id'] as String,
            deviceId: map['device_id'] as String,
            timestamp: map['timestamp'] as int,
            status: map['status'] as String,
            metadata:
                map['metadata'] != null
                    ? jsonDecode(map['metadata'] as String)
                    : null,
            signature: map['signature'] as String,
          ),
        )
        .toList();
  }

  // Inheritance keys operations
  Future<void> storeInheritanceKey(InheritanceKey key) async {
    await _ensureInitialized();

    await _database!.insert('inheritance_keys', {
      'id': key.id,
      'nominee_id': key.nomineeId,
      'encrypted_key_part': key.encryptedKeyPart,
      'threshold': key.threshold,
      'total_parts': key.totalParts,
      'part_number': key.partNumber,
      'algorithm': key.algorithm,
      'created_at': key.createdAt,
      'expires_at': key.expiresAt,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<InheritanceKey>> getInheritanceKeys(String userId) async {
    await _ensureInitialized();

    // This query would need to be adjusted based on how you associate keys with users
    final maps = await _database!.query('inheritance_keys');

    return maps
        .map(
          (map) => InheritanceKey(
            id: map['id'] as String,
            nomineeId: map['nominee_id'] as String,
            encryptedKeyPart: map['encrypted_key_part'] as String,
            threshold: map['threshold'] as int,
            totalParts: map['total_parts'] as int,
            partNumber: map['part_number'] as int,
            algorithm: map['algorithm'] as String,
            createdAt: map['created_at'] as int,
            expiresAt: map['expires_at'] as int?,
          ),
        )
        .toList();
  }

  Future<List<InheritanceKey>> getInheritanceKeysForNominee(
    String nomineeId,
    String userId,
  ) async {
    await _ensureInitialized();

    final maps = await _database!.query(
      'inheritance_keys',
      where: 'nominee_id = ?',
      whereArgs: [nomineeId],
    );

    return maps
        .map(
          (map) => InheritanceKey(
            id: map['id'] as String,
            nomineeId: map['nominee_id'] as String,
            encryptedKeyPart: map['encrypted_key_part'] as String,
            threshold: map['threshold'] as int,
            totalParts: map['total_parts'] as int,
            partNumber: map['part_number'] as int,
            algorithm: map['algorithm'] as String,
            createdAt: map['created_at'] as int,
            expiresAt: map['expires_at'] as int?,
          ),
        )
        .toList();
  }

  // Encrypted data operations
  Future<void> storeEncryptedWill(
    String userId,
    Map<String, dynamic> willData,
  ) async {
    await _ensureInitialized();

    await _database!.insert('encrypted_data', {
      'id': '${userId}_will',
      'user_id': userId,
      'data_type': 'will',
      'encrypted_data': willData['data'],
      'iv': willData['iv'],
      'timestamp': willData['timestamp'],
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<Map<String, dynamic>?> getEncryptedWill(String userId) async {
    await _ensureInitialized();

    final maps = await _database!.query(
      'encrypted_data',
      where: 'user_id = ? AND data_type = ?',
      whereArgs: [userId, 'will'],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    return {
      'data': map['encrypted_data'],
      'iv': map['iv'],
      'timestamp': map['timestamp'],
    };
  }

  Future<void> storeEncryptedPassword(
    String userId,
    Map<String, dynamic> passwordData,
  ) async {
    await _ensureInitialized();

    await _database!.insert('encrypted_data', {
      'id': '${userId}_password_${passwordData['id']}',
      'user_id': userId,
      'data_type': 'password',
      'encrypted_data': passwordData['data'],
      'iv': passwordData['iv'],
      'timestamp': passwordData['timestamp'],
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getEncryptedPasswords(
    String userId,
  ) async {
    await _ensureInitialized();

    final maps = await _database!.query(
      'encrypted_data',
      where: 'user_id = ? AND data_type = ?',
      whereArgs: [userId, 'password'],
    );

    return maps
        .map(
          (map) => {
            'id': map['id'],
            'data': map['encrypted_data'],
            'iv': map['iv'],
            'timestamp': map['timestamp'],
          },
        )
        .toList();
  }

  // Notification operations
  Future<void> storeNotification(
    String nomineeId,
    Map<String, dynamic> notification,
  ) async {
    await _ensureInitialized();

    await _database!.insert('notifications', {
      'id': '${nomineeId}_${notification['timestamp']}',
      'nominee_id': nomineeId,
      'type': notification['type'],
      'message': notification['message'],
      'data':
          notification.containsKey('data')
              ? jsonEncode(notification['data'])
              : null,
      'timestamp': notification['timestamp'],
      'read': 0,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // Death detection state operations
  Future<void> storeDeathDetectionState(DeathDetectionState state) async {
    await _ensureInitialized();

    await _database!.insert('death_detection_states', {
      'user_id': state.userId,
      'last_heartbeat': state.lastHeartbeat,
      'check_in_interval': state.checkInInterval,
      'grace_period': state.gracePeriod,
      'status': state.status,
      'warning_started': state.warningStarted,
      'dead_man_switch_activated': state.deadManSwitchActivated,
      'notified_nominees': jsonEncode(state.notifiedNominees),
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<DeathDetectionState?> getDeathDetectionState(String userId) async {
    await _ensureInitialized();

    final maps = await _database!.query(
      'death_detection_states',
      where: 'user_id = ?',
      whereArgs: [userId],
    );

    if (maps.isEmpty) return null;

    final map = maps.first;
    return DeathDetectionState(
      userId: map['user_id'] as String,
      lastHeartbeat: map['last_heartbeat'] as int,
      checkInInterval: map['check_in_interval'] as int,
      gracePeriod: map['grace_period'] as int,
      status: map['status'] as String,
      warningStarted: map['warning_started'] as int?,
      deadManSwitchActivated: map['dead_man_switch_activated'] as int?,
      notifiedNominees: List<String>.from(
        jsonDecode(map['notified_nominees'] as String),
      ),
    );
  }

  // Time-locked backup operations
  Future<void> storeTimeLockedBackup(
    String userId,
    Map<String, dynamic> backup,
  ) async {
    final backupJson = jsonEncode(backup);
    await _storage.write(key: 'time_locked_backup_$userId', value: backupJson);
  }

  Future<Map<String, dynamic>?> getTimeLockedBackup(String userId) async {
    final backupJson = await _storage.read(key: 'time_locked_backup_$userId');
    if (backupJson == null) return null;

    return jsonDecode(backupJson);
  }

  // Nominee package operations
  Future<void> storeNomineePackage(
    String nomineeId,
    Map<String, dynamic> package,
  ) async {
    final packageJson = jsonEncode(package);
    await _storage.write(key: 'nominee_package_$nomineeId', value: packageJson);
  }

  Future<Map<String, dynamic>?> getNomineePackage(String nomineeId) async {
    final packageJson = await _storage.read(key: 'nominee_package_$nomineeId');
    if (packageJson == null) return null;

    return jsonDecode(packageJson);
  }

  // Mock data operations (for testing)
  Future<List<Map<String, dynamic>>> getAllPasswords(String userId) async {
    // This would return actual password data from your existing storage
    return [
      {
        'id': 'pass1',
        'title': 'Gmail',
        'username': 'user@gmail.com',
        'password': 'encrypted_password_1',
        'type': 'password',
      },
      {
        'id': 'pass2',
        'title': 'Bank Account',
        'username': 'user123',
        'password': 'encrypted_password_2',
        'type': 'password',
      },
    ];
  }

  // Ensure database is initialized
  Future<void> _ensureInitialized() async {
    if (_database == null) {
      await initialize();
    }
  }

  // Close database
  Future<void> close() async {
    await _database?.close();
    _database = null;
  }
}
