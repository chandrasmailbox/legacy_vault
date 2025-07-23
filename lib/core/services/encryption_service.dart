import 'dart:convert';
import 'dart:math';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/sync_models.dart';

class EncryptionService {
  static const _storage = FlutterSecureStorage();
  static final _random = Random.secure();

  // AES encryption for data
  static final _encrypter = Encrypter(AES(Key.fromSecureRandom(32)));

  // Generate secure random key
  static Key generateKey() => Key.fromSecureRandom(32);

  // Generate secure random IV
  static IV generateIV() => IV.fromSecureRandom(16);

  // Encrypt data with AES
  static String encryptData(String data, Key key, IV iv) {
    final encrypter = Encrypter(AES(key));
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }

  // Decrypt data with AES
  static String decryptData(String encryptedData, Key key, IV iv) {
    final encrypter = Encrypter(AES(key));
    final encrypted = Encrypted.fromBase64(encryptedData);
    return encrypter.decrypt(encrypted, iv: iv);
  }

  // Split key into parts using Shamir's Secret Sharing simulation
  static List<InheritanceKey> splitKey(
    String masterKey,
    List<String> nomineeIds,
    int threshold,
    String userId,
  ) {
    final keyBytes = utf8.encode(masterKey);
    final keyParts = <InheritanceKey>[];

    // Generate polynomial coefficients
    final coefficients = List.generate(threshold, (_) => _random.nextInt(256));
    coefficients[0] = keyBytes.fold(0, (a, b) => a ^ b); // Simple XOR for demo

    for (int i = 0; i < nomineeIds.length; i++) {
      // Calculate share using polynomial evaluation
      int share = coefficients[0];
      int x = i + 1;

      for (int j = 1; j < threshold; j++) {
        share ^= coefficients[j] * pow(x, j).toInt();
      }

      final keyPart = InheritanceKey(
        id: _generateId(),
        nomineeId: nomineeIds[i],
        encryptedKeyPart: base64.encode([share]),
        threshold: threshold,
        totalParts: nomineeIds.length,
        partNumber: i + 1,
        algorithm: 'shamir_secret_sharing',
        createdAt: DateTime.now().millisecondsSinceEpoch,
      );

      keyParts.add(keyPart);
    }

    return keyParts;
  }

  // Reconstruct key from threshold parts
  static String? reconstructKey(List<InheritanceKey> keyParts) {
    if (keyParts.length < keyParts.first.threshold) {
      return null;
    }

    // Simple reconstruction for demo - would use Lagrange interpolation in production
    int reconstructed = 0;
    for (final part in keyParts.take(keyParts.first.threshold)) {
      final shareBytes = base64.decode(part.encryptedKeyPart);
      reconstructed ^= shareBytes.first;
    }

    return String.fromCharCode(reconstructed);
  }

  // Time-locked encryption
  static Map<String, dynamic> createTimeLockedEncryption(
    String data,
    DateTime unlockTime,
  ) {
    final key = generateKey();
    final iv = generateIV();
    final encryptedData = encryptData(data, key, iv);

    // Store key with time lock
    final timeLockKey = _generateTimeLockKey(key, unlockTime);

    return {
      'encryptedData': encryptedData,
      'iv': iv.base64,
      'timeLockKey': timeLockKey,
      'unlockTime': unlockTime.millisecondsSinceEpoch,
    };
  }

  // Check if time-locked data can be unlocked
  static bool canUnlockTimeLocked(Map<String, dynamic> timeLockedData) {
    final unlockTime = DateTime.fromMillisecondsSinceEpoch(
      timeLockedData['unlockTime'],
    );
    return DateTime.now().isAfter(unlockTime);
  }

  // Unlock time-locked data
  static String? unlockTimeLockedData(Map<String, dynamic> timeLockedData) {
    if (!canUnlockTimeLocked(timeLockedData)) {
      return null;
    }

    final key = _reconstructTimeLockKey(timeLockedData['timeLockKey']);
    final iv = IV.fromBase64(timeLockedData['iv']);

    return decryptData(timeLockedData['encryptedData'], key, iv);
  }

  // Zero-knowledge proof generation (simplified)
  static Map<String, String> generateZKProof(String secret, String challenge) {
    final secretHash = sha256.convert(utf8.encode(secret)).toString();
    final challengeHash = sha256.convert(utf8.encode(challenge)).toString();
    final proof =
        sha256.convert(utf8.encode(secretHash + challengeHash)).toString();

    return {'commitment': secretHash, 'proof': proof, 'challenge': challenge};
  }

  // Verify zero-knowledge proof
  static bool verifyZKProof(Map<String, String> proof, String challenge) {
    final expectedProof =
        sha256
            .convert(utf8.encode(proof['commitment']! + challenge))
            .toString();

    return proof['proof'] == expectedProof && proof['challenge'] == challenge;
  }

  // Generate secure hash
  static String generateHash(String data) {
    final bytes = utf8.encode(data);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  // Generate HMAC signature
  static String generateHMAC(String data, String key) {
    final keyBytes = utf8.encode(key);
    final dataBytes = utf8.encode(data);
    final hmac = Hmac(sha256, keyBytes);
    final digest = hmac.convert(dataBytes);
    return digest.toString();
  }

  // Verify HMAC signature
  static bool verifyHMAC(String data, String signature, String key) {
    final expectedSignature = generateHMAC(data, key);
    return expectedSignature == signature;
  }

  // Store encrypted key securely
  static Future<void> storeSecureKey(String keyId, String key) async {
    await _storage.write(key: 'key_$keyId', value: key);
  }

  // Retrieve encrypted key securely
  static Future<String?> getSecureKey(String keyId) async {
    return await _storage.read(key: 'key_$keyId');
  }

  // Generate unique ID
  static String _generateId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = _random.nextInt(999999);
    return '${timestamp}_$random';
  }

  // Time lock key generation (simplified)
  static String _generateTimeLockKey(Key key, DateTime unlockTime) {
    final keyData = key.base64;
    final timeData = unlockTime.millisecondsSinceEpoch.toString();
    return base64.encode(utf8.encode('$keyData:$timeData'));
  }

  // Reconstruct time lock key
  static Key _reconstructTimeLockKey(String timeLockKey) {
    final decoded = utf8.decode(base64.decode(timeLockKey));
    final keyData = decoded.split(':')[0];
    return Key.fromBase64(keyData);
  }
}
