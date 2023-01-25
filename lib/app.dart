import 'package:deriv_test/app/theme/theme_data.dart';
import 'package:deriv_test/core/constants/config.dart';
import 'package:deriv_test/core/services/socket.dart';
import 'package:deriv_test/data/repos/price_tracker_repo.dart';
import 'package:deriv_test/data/repos/price_tracker_service.dart';
import 'package:deriv_test/domain/repos/price_tracker_repo.dart';
import 'package:deriv_test/presentation/bloc/symbols_bloc/symbols_bloc.dart';
import 'package:deriv_test/presentation/screens/symbols_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DerivApp extends StatelessWidget {
  const DerivApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider<IPriceTrackerRepo>(
      create: (context) => PriceTrackerRepoImpl(
        PriceTrackerServiceImpl(
          socket: SocketConnection(baseUrl: AppConfig.socketBaseUrl),
        ),
      ),
      child: BlocProvider(
        create: (context) => SymbolsBloc(context.read<IPriceTrackerRepo>()),
        child: MaterialApp(
          title: AppConfig.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeBuilder(primaryColor: Colors.blue).theme,
          home: const SymbolsScreen(),
        ),
      ),
    );
  }
}
