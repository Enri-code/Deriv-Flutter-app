import 'package:deriv_test/core/utils/operation_status.dart';
import 'package:deriv_test/domain/entities/market.dart';
import 'package:deriv_test/presentation/bloc/symbols_cubit/symbols_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SymbolsScreen extends StatefulWidget {
  const SymbolsScreen({Key? key}) : super(key: key);

  @override
  State<SymbolsScreen> createState() => _SymbolsScreenState();
}

class _SymbolsScreenState extends State<SymbolsScreen> {
  @override
  Widget build(BuildContext context) {
    context.read<SymbolsCubit>().getSymbols();
    return Scaffold(
      appBar: AppBar(title: const Text('Deriv Price Tracker')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: BlocBuilder<SymbolsCubit, SymbolsState>(
          builder: (context, state) {
            return StreamBuilder(
              stream: state.markets,
              builder: (context, snapshot) {
                if (snapshot.data?.isEmpty ?? true) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  children: [
                    _PickerWidget(markets: snapshot.data!),
                    const Expanded(child: Center(child: _PriceSection())),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

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
        DropdownButtonFormField<String>(
          hint: const Text('Select a Market'),
          items: List.generate(
            widget.markets.length,
            (index) => DropdownMenuItem(
              value: widget.markets[index].market,
              child: Text(widget.markets[index].name),
            ),
          ),
          onChanged: (val) => setState(() {
            selectedMarket = widget.markets.firstWhere((element) {
              return element.market == val;
            });
          }),
        ),
        const SizedBox(height: 32),
        DropdownButtonFormField<String>(
          hint: const Text('Select a Symbol'),
          items: List.generate(
            selectedMarket?.symbols!.length ?? 0,
            (index) {
              final symbol = selectedMarket!.symbols![index];
              return DropdownMenuItem(
                value: symbol.symbolId,
                child: Text(symbol.displayName),
              );
            },
          ),
          onChanged: (val) {
            context.read<SymbolsCubit>().getTicks(val!);
          },
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

class _PriceSection extends StatelessWidget {
  const _PriceSection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SymbolsCubit, SymbolsState>(
      builder: (context, state) {
        if (state is! SymbolTicksState ||
            state.status == OperationStatus.loading) {
          return const CircularProgressIndicator();
        }
        return Center(
          child: DefaultTextStyle(
            style: const TextStyle(fontSize: 24, color: Colors.black),
            child: StreamBuilder<num>(
              stream: state.priceTicks,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const CircularProgressIndicator();
                }
                if (state.status == OperationStatus.error) {
                  return Text(
                    state.errorMessage ?? 'Error Loading Price',
                  );
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
