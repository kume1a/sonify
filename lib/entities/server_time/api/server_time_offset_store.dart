abstract interface class ServerTimeOffsetStore {
  void write(int value);

  int? read();
}
