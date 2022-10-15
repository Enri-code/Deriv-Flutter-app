import 'package:deriv_test/core/constants/config.dart';
import 'package:deriv_test/data/repos/price_tracker_repo.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/presentation/bloc/symbols_cubit/symbols_cubit.dart';
import 'package:deriv_test/presentation/screens/symbols_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DerivApp extends StatelessWidget {
  const DerivApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IPriceTrackerRepo>(
      create: (context) => PriceTrackerRepoImpl(),
      child: BlocProvider(
        create: (context) => SymbolsCubit(context.read<IPriceTrackerRepo>()),
        child: const MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          home: SymbolsScreen(),
        ),
      ),
    );
  }
}
