class MarketSymbol {
  final String displayName;
  final String symbolId;
  final String marketId;

  const MarketSymbol({
    required this.displayName,
    required this.symbolId,
    required this.marketId,
  });

  @override
  operator ==(dynamic other) =>
      other is MarketSymbol && other.symbolId == symbolId;

  @override
  int get hashCode => symbolId.hashCode;
}
