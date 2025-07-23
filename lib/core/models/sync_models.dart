import 'package:json_annotation/json_annotation.dart';

part 'sync_models.g.dart';

@JsonSerializable()
class SyncPacket {
  final String id;
  final String deviceId;
  final String userId;
  final int timestamp;
  final String dataType;
  final Map<String, dynamic> encryptedData;
  final String checksum;
  final int version;
  final String? previousHash;

  SyncPacket({
    required this.id,
    required this.deviceId,
    required this.userId,
    required this.timestamp,
    required this.dataType,
    required this.encryptedData,
    required this.checksum,
    required this.version,
    this.previousHash,
  });

  factory SyncPacket.fromJson(Map<String, dynamic> json) =>
      _$SyncPacketFromJson(json);

  Map<String, dynamic> toJson() => _$SyncPacketToJson(this);
}

@JsonSerializable()
class SyncDelta {
  final String id;
  final String operation; // 'create', 'update', 'delete'
  final String recordId;
  final String recordType;
  final Map<String, dynamic>? oldData;
  final Map<String, dynamic>? newData;
  final int timestamp;
  final String deviceId;

  SyncDelta({
    required this.id,
    required this.operation,
    required this.recordId,
    required this.recordType,
    this.oldData,
    this.newData,
    required this.timestamp,
    required this.deviceId,
  });

  factory SyncDelta.fromJson(Map<String, dynamic> json) =>
      _$SyncDeltaFromJson(json);

  Map<String, dynamic> toJson() => _$SyncDeltaToJson(this);
}

@JsonSerializable()
class HeartbeatSignal {
  final String userId;
  final String deviceId;
  final int timestamp;
  final String status; // 'alive', 'checkin', 'emergency'
  final Map<String, dynamic>? metadata;
  final String signature;

  HeartbeatSignal({
    required this.userId,
    required this.deviceId,
    required this.timestamp,
    required this.status,
    this.metadata,
    required this.signature,
  });

  factory HeartbeatSignal.fromJson(Map<String, dynamic> json) =>
      _$HeartbeatSignalFromJson(json);

  Map<String, dynamic> toJson() => _$HeartbeatSignalToJson(this);
}

@JsonSerializable()
class InheritanceKey {
  final String id;
  final String nomineeId;
  final String encryptedKeyPart;
  final int threshold;
  final int totalParts;
  final int partNumber;
  final String algorithm;
  final int createdAt;
  final int? expiresAt;

  InheritanceKey({
    required this.id,
    required this.nomineeId,
    required this.encryptedKeyPart,
    required this.threshold,
    required this.totalParts,
    required this.partNumber,
    required this.algorithm,
    required this.createdAt,
    this.expiresAt,
  });

  factory InheritanceKey.fromJson(Map<String, dynamic> json) =>
      _$InheritanceKeyFromJson(json);

  Map<String, dynamic> toJson() => _$InheritanceKeyToJson(this);
}

@JsonSerializable()
class DeathDetectionState {
  final String userId;
  final int lastHeartbeat;
  final int checkInInterval;
  final int gracePeriod;
  final String status; // 'active', 'warning', 'critical', 'confirmed'
  final int? warningStarted;
  final int? deadManSwitchActivated;
  final List<String> notifiedNominees;

  DeathDetectionState({
    required this.userId,
    required this.lastHeartbeat,
    required this.checkInInterval,
    required this.gracePeriod,
    required this.status,
    this.warningStarted,
    this.deadManSwitchActivated,
    required this.notifiedNominees,
  });

  factory DeathDetectionState.fromJson(Map<String, dynamic> json) =>
      _$DeathDetectionStateFromJson(json);

  Map<String, dynamic> toJson() => _$DeathDetectionStateToJson(this);
}

@JsonSerializable()
class MerkleNode {
  final String hash;
  final String? leftHash;
  final String? rightHash;
  final Map<String, dynamic>? data;
  final bool isLeaf;

  MerkleNode({
    required this.hash,
    this.leftHash,
    this.rightHash,
    this.data,
    required this.isLeaf,
  });

  factory MerkleNode.fromJson(Map<String, dynamic> json) =>
      _$MerkleNodeFromJson(json);

  Map<String, dynamic> toJson() => _$MerkleNodeToJson(this);
}
