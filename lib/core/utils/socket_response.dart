class ResponseWithSubId<T> {
  const ResponseWithSubId({required this.data, required this.requestId});

  final T data;
  final int requestId;
}
