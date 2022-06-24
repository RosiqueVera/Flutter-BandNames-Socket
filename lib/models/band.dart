class Band {
  String id;
  String Name;
  int votes;

  Band({
    required this.Name,
    required this.id,
    required this.votes,
  });
  factory Band.fromMap(Map<String, dynamic> obj) => Band(
        id: obj['id'] ?? 'No-Id',
        Name: obj['name'] ?? 'No-Name',
        votes: obj['votes'] ?? 0,
      );
}
