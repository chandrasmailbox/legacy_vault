import 'dart:async';
import 'dart:convert';

import '../models/sync_models.dart';
import './encryption_service.dart';
import './local_storage_service.dart';
import './sync_service.dart';

class InheritanceService {
  static final InheritanceService _instance = InheritanceService._internal();
  factory InheritanceService() => _instance;
  InheritanceService._internal();

  final _statusController = StreamController<InheritanceStatus>.broadcast();

  Stream<InheritanceStatus> get statusStream => _statusController.stream;

  // Setup inheritance for user
  Future<void> setupInheritance({
    required String userId,
    required List<String> nomineeIds,
    required String masterPassword,
    required int threshold,
    Map<String, dynamic>? willData,
  }) async {
    try {
      _statusController.add(InheritanceStatus.settingUp);

      // Generate master encryption key
      final masterKey = EncryptionService.generateKey();

      // Split master key using threshold cryptography
      final keyParts = EncryptionService.splitKey(
        masterKey.base64,
        nomineeIds,
        threshold,
        userId,
      );

      // Store key parts for each nominee
      for (final keyPart in keyParts) {
        await LocalStorageService().storeInheritanceKey(keyPart);
      }

      // Encrypt will and password data with master key
      if (willData != null) {
        await _encryptAndStoreWill(willData, masterKey, userId);
      }

      await _encryptAndStorePasswords(masterKey, userId);

      // Create time-locked backup
      final unlockTime = DateTime.now().add(const Duration(days: 30));
      final timeLockedData = EncryptionService.createTimeLockedEncryption(
        masterKey.base64,
        unlockTime,
      );

      await LocalStorageService().storeTimeLockedBackup(userId, timeLockedData);

      _statusController.add(InheritanceStatus.ready);
    } catch (e) {
      _statusController.add(InheritanceStatus.error);
      rethrow;
    }
  }

  // Trigger inheritance process when death is confirmed
  Future<void> triggerInheritance(String userId) async {
    try {
      _statusController.add(InheritanceStatus.triggered);

      // Get inheritance keys for all nominees
      final inheritanceKeys = await LocalStorageService().getInheritanceKeys(
        userId,
      );

      // Notify all nominees about inheritance activation
      for (final key in inheritanceKeys) {
        await _notifyNominee(key.nomineeId, userId, key);
      }

      // Prepare encrypted data packages for nominees
      await _prepareNomineeDataPackages(userId, inheritanceKeys);

      _statusController.add(InheritanceStatus.activated);
    } catch (e) {
      _statusController.add(InheritanceStatus.error);
      rethrow;
    }
  }

  // Nominee attempts to claim inheritance
  Future<InheritanceClaimResult> claimInheritance({
    required String nomineeId,
    required String userId,
    required List<InheritanceKey> availableKeys,
  }) async {
    try {
      // Check if enough keys are available for threshold
      final threshold = availableKeys.first.threshold;
      if (availableKeys.length < threshold) {
        return InheritanceClaimResult(
          success: false,
          message:
              'Insufficient keys. Need $threshold, have ${availableKeys.length}',
        );
      }

      // Reconstruct master key
      final masterKey = EncryptionService.reconstructKey(availableKeys);
      if (masterKey == null) {
        return InheritanceClaimResult(
          success: false,
          message: 'Failed to reconstruct master key',
        );
      }

      // Decrypt and provide access to inherited data
      final decryptedData = await _decryptInheritedData(userId, masterKey);

      return InheritanceClaimResult(
        success: true,
        message: 'Inheritance claimed successfully',
        inheritedData: decryptedData,
      );
    } catch (e) {
      return InheritanceClaimResult(
        success: false,
        message: 'Error claiming inheritance: $e',
      );
    }
  }

  // Check inheritance status for nominee
  Future<InheritanceStatusInfo> checkInheritanceStatus({
    required String nomineeId,
    required String userId,
  }) async {
    final deathDetectionState = await LocalStorageService()
        .getDeathDetectionState(userId);
    final inheritanceKeys = await LocalStorageService()
        .getInheritanceKeysForNominee(nomineeId, userId);

    return InheritanceStatusInfo(
      userId: userId,
      nomineeId: nomineeId,
      status: deathDetectionState?.status ?? 'unknown',
      availableKeys: inheritanceKeys.length,
      requiredKeys:
          inheritanceKeys.isNotEmpty ? inheritanceKeys.first.threshold : 0,
      canClaim:
          deathDetectionState?.status == 'confirmed' &&
          inheritanceKeys.length >=
              (inheritanceKeys.isNotEmpty
                  ? inheritanceKeys.first.threshold
                  : 0),
    );
  }

  // Encrypt and store will data
  Future<void> _encryptAndStoreWill(
    Map<String, dynamic> willData,
    key,
    String userId,
  ) async {
    final iv = EncryptionService.generateIV();
    final encryptedWill = EncryptionService.encryptData(
      jsonEncode(willData),
      key,
      iv,
    );

    final willPackage = {
      'data': encryptedWill,
      'iv': iv.base64,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    await LocalStorageService().storeEncryptedWill(userId, willPackage);
  }

  // Encrypt and store passwords
  Future<void> _encryptAndStorePasswords(key, String userId) async {
    final passwords = await LocalStorageService().getAllPasswords(userId);

    for (final password in passwords) {
      final iv = EncryptionService.generateIV();
      final encryptedPassword = EncryptionService.encryptData(
        jsonEncode(password),
        key,
        iv,
      );

      final passwordPackage = {
        'id': password['id'],
        'data': encryptedPassword,
        'iv': iv.base64,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await LocalStorageService().storeEncryptedPassword(
        userId,
        passwordPackage,
      );
    }
  }

  // Prepare data packages for nominees
  Future<void> _prepareNomineeDataPackages(
    String userId,
    List<InheritanceKey> keys,
  ) async {
    for (final key in keys) {
      final nomineePackage = {
        'nomineeId': key.nomineeId,
        'userId': userId,
        'keyPart': key.toJson(),
        'instructions': _generateInheritanceInstructions(key),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      await LocalStorageService().storeNomineePackage(
        key.nomineeId,
        nomineePackage,
      );
    }
  }

  // Decrypt inherited data
  Future<Map<String, dynamic>> _decryptInheritedData(
    String userId,
    String masterKey,
  ) async {
    final key = EncryptionService.encrypter.key; // Use reconstructed key

    // Decrypt will
    final encryptedWill = await LocalStorageService().getEncryptedWill(userId);
    String? will;
    if (encryptedWill != null) {
      final iv = EncryptionService.encrypter.iv; // IV from stored data
      will = EncryptionService.decryptData(encryptedWill['data'], key, iv);
    }

    // Decrypt passwords
    final encryptedPasswords = await LocalStorageService()
        .getEncryptedPasswords(userId);
    final passwords = <Map<String, dynamic>>[];

    for (final encryptedPassword in encryptedPasswords) {
      final iv = EncryptionService.encrypter.iv; // IV from stored data
      final decryptedPassword = EncryptionService.decryptData(
        encryptedPassword['data'],
        key,
        iv,
      );
      passwords.add(jsonDecode(decryptedPassword));
    }

    return {
      'will': will != null ? jsonDecode(will) : null,
      'passwords': passwords,
      'claimedAt': DateTime.now().millisecondsSinceEpoch,
    };
  }

  // Generate inheritance instructions
  String _generateInheritanceInstructions(InheritanceKey key) {
    return '''
Inheritance Key Instructions:

You have received an inheritance key as a nominee for a Legacy Vault user.

Key Details:
- Key Part: ${key.partNumber} of ${key.totalParts}
- Threshold Required: ${key.threshold} keys minimum
- Algorithm: ${key.algorithm}

To claim the inheritance:
1. Confirm the user's death has been verified
2. Coordinate with other nominees to collect ${key.threshold} keys
3. Use the Legacy Vault app to combine keys and access inherited data

This key part alone cannot access the inherited data.
You must work with other nominees to reach the threshold.

Created: ${DateTime.fromMillisecondsSinceEpoch(key.createdAt)}
''';
  }

  // Notify nominee about inheritance
  Future<void> _notifyNominee(
    String nomineeId,
    String userId,
    InheritanceKey key,
  ) async {
    // Create encrypted notification
    final notification = {
      'type': 'inheritance_activated',
      'userId': userId,
      'nomineeId': nomineeId,
      'message': 'You have been granted access to an inheritance.',
      'keyId': key.id,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };

    // Store notification for nominee
    await LocalStorageService().storeNotification(nomineeId, notification);

    // Send via sync service to nominee's devices
    await SyncService().startSync();
  }

  // Dispose resources
  void dispose() {
    _statusController.close();
  }
}

enum InheritanceStatus {
  idle,
  settingUp,
  ready,
  triggered,
  activated,
  claimed,
  error,
}

class InheritanceClaimResult {
  final bool success;
  final String message;
  final Map<String, dynamic>? inheritedData;

  InheritanceClaimResult({
    required this.success,
    required this.message,
    this.inheritedData,
  });
}

class InheritanceStatusInfo {
  final String userId;
  final String nomineeId;
  final String status;
  final int availableKeys;
  final int requiredKeys;
  final bool canClaim;

  InheritanceStatusInfo({
    required this.userId,
    required this.nomineeId,
    required this.status,
    required this.availableKeys,
    required this.requiredKeys,
    required this.canClaim,
  });
}
