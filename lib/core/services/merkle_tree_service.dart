import 'dart:convert';

import '../models/sync_models.dart';
import './encryption_service.dart';

class MerkleTreeService {
  static final MerkleTreeService _instance = MerkleTreeService._internal();
  factory MerkleTreeService() => _instance;
  MerkleTreeService._internal();

  // Build Merkle tree from data list
  MerkleNode buildTree(List<Map<String, dynamic>> dataList) {
    if (dataList.isEmpty) {
      return MerkleNode(
        hash: EncryptionService.generateHash('empty'),
        isLeaf: true,
      );
    }

    // Create leaf nodes
    final leafNodes =
        dataList
            .map(
              (data) => MerkleNode(
                hash: EncryptionService.generateHash(jsonEncode(data)),
                data: data,
                isLeaf: true,
              ),
            )
            .toList();

    return _buildTreeFromNodes(leafNodes);
  }

  // Build tree from nodes recursively
  MerkleNode _buildTreeFromNodes(List<MerkleNode> nodes) {
    if (nodes.length == 1) {
      return nodes.first;
    }

    final parentNodes = <MerkleNode>[];

    for (int i = 0; i < nodes.length; i += 2) {
      final leftNode = nodes[i];
      final rightNode = i + 1 < nodes.length ? nodes[i + 1] : leftNode;

      final parentHash = EncryptionService.generateHash(
        leftNode.hash + rightNode.hash,
      );

      final parentNode = MerkleNode(
        hash: parentHash,
        leftHash: leftNode.hash,
        rightHash: rightNode.hash,
        isLeaf: false,
      );

      parentNodes.add(parentNode);
    }

    return _buildTreeFromNodes(parentNodes);
  }

  // Generate Merkle proof for specific data
  List<String> generateProof(
    List<Map<String, dynamic>> dataList,
    Map<String, dynamic> targetData,
  ) {
    final targetHash = EncryptionService.generateHash(jsonEncode(targetData));
    final leafNodes =
        dataList
            .map(
              (data) => MerkleNode(
                hash: EncryptionService.generateHash(jsonEncode(data)),
                data: data,
                isLeaf: true,
              ),
            )
            .toList();

    return _generateProofRecursive(leafNodes, targetHash, []);
  }

  // Generate proof recursively
  List<String> _generateProofRecursive(
    List<MerkleNode> nodes,
    String targetHash,
    List<String> proof,
  ) {
    if (nodes.length == 1) {
      return proof;
    }

    final parentNodes = <MerkleNode>[];
    bool targetFound = false;

    for (int i = 0; i < nodes.length; i += 2) {
      final leftNode = nodes[i];
      final rightNode = i + 1 < nodes.length ? nodes[i + 1] : leftNode;

      if (leftNode.hash == targetHash) {
        proof.add(rightNode.hash);
        targetFound = true;
      } else if (rightNode.hash == targetHash) {
        proof.add(leftNode.hash);
        targetFound = true;
      }

      final parentHash = EncryptionService.generateHash(
        leftNode.hash + rightNode.hash,
      );

      final parentNode = MerkleNode(
        hash: parentHash,
        leftHash: leftNode.hash,
        rightHash: rightNode.hash,
        isLeaf: false,
      );

      parentNodes.add(parentNode);

      if (targetFound) {
        targetHash = parentHash;
        targetFound = false;
      }
    }

    return _generateProofRecursive(parentNodes, targetHash, proof);
  }

  // Verify Merkle proof
  bool verifyProof(String rootHash, String targetHash, List<String> proof) {
    String currentHash = targetHash;

    for (final proofHash in proof) {
      // Try both left and right combinations
      final leftCombination = EncryptionService.generateHash(
        currentHash + proofHash,
      );
      final rightCombination = EncryptionService.generateHash(
        proofHash + currentHash,
      );

      // Choose the correct combination based on lexicographic order
      currentHash =
          currentHash.compareTo(proofHash) < 0
              ? leftCombination
              : rightCombination;
    }

    return currentHash == rootHash;
  }

  // Calculate tree differences for delta sync
  List<SyncDelta> calculateDeltas(
    MerkleNode oldTree,
    MerkleNode newTree,
    String deviceId,
  ) {
    final deltas = <SyncDelta>[];
    _calculateDeltasRecursive(oldTree, newTree, deltas, deviceId);
    return deltas;
  }

  // Calculate deltas recursively
  void _calculateDeltasRecursive(
    MerkleNode? oldNode,
    MerkleNode? newNode,
    List<SyncDelta> deltas,
    String deviceId,
  ) {
    // Both nodes are null
    if (oldNode == null && newNode == null) {
      return;
    }

    // New node added
    if (oldNode == null && newNode != null) {
      if (newNode.isLeaf && newNode.data != null) {
        deltas.add(
          SyncDelta(
            id: _generateDeltaId(),
            operation: 'create',
            recordId: newNode.data!['id'] ?? newNode.hash,
            recordType: newNode.data!['type'] ?? 'unknown',
            newData: newNode.data!,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            deviceId: deviceId,
          ),
        );
      }
      return;
    }

    // Old node deleted
    if (oldNode != null && newNode == null) {
      if (oldNode.isLeaf && oldNode.data != null) {
        deltas.add(
          SyncDelta(
            id: _generateDeltaId(),
            operation: 'delete',
            recordId: oldNode.data!['id'] ?? oldNode.hash,
            recordType: oldNode.data!['type'] ?? 'unknown',
            oldData: oldNode.data!,
            timestamp: DateTime.now().millisecondsSinceEpoch,
            deviceId: deviceId,
          ),
        );
      }
      return;
    }

    // Both nodes exist
    if (oldNode != null && newNode != null) {
      // Hashes are different - there's a change
      if (oldNode.hash != newNode.hash) {
        if (oldNode.isLeaf && newNode.isLeaf) {
          // Leaf nodes changed
          deltas.add(
            SyncDelta(
              id: _generateDeltaId(),
              operation: 'update',
              recordId: newNode.data!['id'] ?? newNode.hash,
              recordType: newNode.data!['type'] ?? 'unknown',
              oldData: oldNode.data,
              newData: newNode.data,
              timestamp: DateTime.now().millisecondsSinceEpoch,
              deviceId: deviceId,
            ),
          );
        } else {
          // Recursively check children
          _calculateDeltasRecursive(
            _findChildByHash(oldNode.leftHash),
            _findChildByHash(newNode.leftHash),
            deltas,
            deviceId,
          );
          _calculateDeltasRecursive(
            _findChildByHash(oldNode.rightHash),
            _findChildByHash(newNode.rightHash),
            deltas,
            deviceId,
          );
        }
      }
    }
  }

  // Find child node by hash (simplified - in real implementation, maintain tree structure)
  MerkleNode? _findChildByHash(String? hash) {
    // This would require maintaining the full tree structure
    // For now, return null as this is a simplified implementation
    return null;
  }

  // Generate unique delta ID
  String _generateDeltaId() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = (timestamp * 1000) % 999999;
    return '${timestamp}_$random';
  }

  // Create incremental sync package
  Map<String, dynamic> createIncrementalSync(
    String rootHash,
    List<SyncDelta> deltas,
  ) {
    return {
      'rootHash': rootHash,
      'deltas': deltas.map((d) => d.toJson()).toList(),
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'deltasCount': deltas.length,
    };
  }

  // Apply incremental sync
  bool applyIncrementalSync(
    Map<String, dynamic> syncPackage,
    Function(SyncDelta) applyDelta,
  ) {
    try {
      final deltas =
          (syncPackage['deltas'] as List)
              .map((d) => SyncDelta.fromJson(d))
              .toList();

      // Sort deltas by timestamp to ensure correct order
      deltas.sort((a, b) => a.timestamp.compareTo(b.timestamp));

      // Apply each delta
      for (final delta in deltas) {
        applyDelta(delta);
      }

      return true;
    } catch (e) {
      return false;
    }
  }
}
