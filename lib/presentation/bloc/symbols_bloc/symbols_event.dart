part of 'symbols_bloc.dart';

abstract class SymbolsEvent {
  const SymbolsEvent();
}

class GetSymbolsEvent extends SymbolsEvent {}

class GetSymbolTicksEvent extends SymbolsEvent {
  final String symbolName;

  const GetSymbolTicksEvent(this.symbolName);
}
