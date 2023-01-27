
/// Base interface for use cases, to ensure predictability
abstract class UseCase<T> {
  const UseCase();
  T call();
}
