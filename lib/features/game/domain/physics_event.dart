enum PhysicsEventType {
  ballContact,
  cushionContact,
  pocketed,
  scratch,
  stopped,
}

final class PhysicsEvent {
  const PhysicsEvent({
    required this.type,
    required this.tick,
    required this.ballId,
    this.otherBallId,
    this.pocketIndex,
  });

  final PhysicsEventType type;
  final int tick;
  final int ballId;
  final int? otherBallId;
  final int? pocketIndex;

  @override
  String toString() {
    return 'PhysicsEvent($type, tick: $tick, ball: $ballId, '
        'other: $otherBallId, pocket: $pocketIndex)';
  }
}
