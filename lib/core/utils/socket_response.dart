///Model used to return a value and a subscription id needed to cancel that
///subscription
class TicksResponse<T> {
  const TicksResponse({
    required this.ticksStream,
    required this.subscriptionId,
  });

  final T ticksStream;
  final String subscriptionId;
}
