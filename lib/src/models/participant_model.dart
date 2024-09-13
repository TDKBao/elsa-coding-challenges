class Participant {
  final String id;
  final String name;
  final int joinedAt;

  Participant({required this.id, required this.name, required this.joinedAt});

  factory Participant.fromMap(String id, Map<String, dynamic> map) {
    return Participant(
      id: id,
      name: map['name'] ?? '',
      joinedAt: map['joinedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'joinedAt': joinedAt,
    };
  }
}