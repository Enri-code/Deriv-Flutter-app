import 'package:deriv_test/core/utils/operation_status.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/domain/entities/market_symbol.dart';
import 'package:deriv_test/presentation/bloc/symbols_bloc/symbols_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SymbolsScreen extends StatefulWidget {
  const SymbolsScreen({Key? key}) : super(key: key);

  @override
  State<SymbolsScreen> createState() => _SymbolsScreenState();
}

class _SymbolsScreenState extends State<SymbolsScreen> {
  @override
  void initState() {
    context.read<SymbolsBloc>().add(GetSymbolsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Deriv Price Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<SymbolsBloc, SymbolsState>(
          builder: (context, state) {
            if (state.status == OperationStatus.loading &&
                state is! SymbolTicksState) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              children: [
                _PickerWidget(markets: state.markets ?? []),
                if (state is SymbolTicksState)
                  const Expanded(
                    child: Align(
                      alignment: Alignment(0, -0.2),
                      child: _PriceSection(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

///Widget that contains dropdown for selecting a market
class _PickerWidget extends StatefulWidget {
  const _PickerWidget({required this.markets});
  final List<Market> markets;

  @override
  State<_PickerWidget> createState() => _PickerWidgetState();
}

class _PickerWidgetState extends State<_PickerWidget> {
  Market? selectedMarket;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 32),
        DropdownButtonFormField<Market>(
          hint: const Text('Select a Market'),
          items: List.generate(
            widget.markets.length,
            (index) => DropdownMenuItem(
              value: widget.markets[index],
              child: Text(widget.markets[index].name),
            ),
          ),
          onChanged: (val) => setState(() => selectedMarket = val),
        ),
        const SizedBox(height: 32),
        
        if (selectedMarket != null)
          Padding(
            key: ValueKey(selectedMarket),
            padding: const EdgeInsets.only(bottom: 32),
            child: DropdownButtonFormField<MarketSymbol>(
              hint: const Text('Select a Symbol'),
              items: List.generate(
                selectedMarket!.symbols!.length,
                (index) {
                  final symbol = selectedMarket!.symbols![index];
                  return DropdownMenuItem(
                    value: symbol,
                    child: Text(symbol.displayName),
                  );
                },
              ),
              onChanged: (symbol) {
                context.read<SymbolsBloc>().add(
                      GetSymbolTicksEvent(symbol!.id),
                    );
              },
            ),
          ),
      ],
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymbolsBloc, SymbolsState>(
      builder: (context, state) {
        if (state.status == OperationStatus.loading) {
          return const CircularProgressIndicator();
        }
        return Center(
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 24, color: Colors.black),
            child: StreamBuilder<num>(
              stream: (state as SymbolTicksState).priceTicks,
              builder: (context, snapshot) {
                if (state.status == OperationStatus.error) {
                  return Text(state.errorMessage ?? 'Error Loading Price');
                }
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                return Text('Price: \$${snapshot.data}');
              },
            ),
          ),
        );
      },
    );
  }
}
