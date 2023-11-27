class Base {
  int id;
  DateTime? createdAt;
  DateTime? updatedAt;

  Base({required this.id, this.createdAt, this.updatedAt});

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }


  @override
  String toString() {
    return 'Base{id: $id, createdAt: $createdAt, updatedAt: $updatedAt}';
  }
}
