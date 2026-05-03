class Genre {
  final String name;

  const Genre({required this.name});

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Genre && other.name == name;
  }

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => name;
}
