class MarketSymbol {
  final String displayName;
  final String id;
  final String marketId;

  const MarketSymbol({
    required this.displayName,
    required this.id,
    required this.marketId,
  });

  @override
  operator ==(dynamic other) =>
      other is MarketSymbol && other.id == id;

  @override
  int get hashCode => id.hashCode;
}
