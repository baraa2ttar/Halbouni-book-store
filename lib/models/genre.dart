import 'package:flutter/material.dart';

class Genre {
  final String name;
  final IconData icon;

  const Genre({required this.name, required this.icon});

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
