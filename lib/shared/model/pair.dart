class Pair<T1, T2> {
  Pair(this.first, this.second);

  final T1 first;
  final T2 second;

  @override
  String toString() => 'Pair(first: $first, second: $second)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }

    return other is Pair<T1, T2> && other.first == first && other.second == first;
  }

  @override
  int get hashCode => Object.hash(first, second);
}
