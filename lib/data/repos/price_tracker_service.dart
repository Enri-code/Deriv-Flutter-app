import 'dart:async';
import 'dart:convert';

import 'package:deriv_test/core/services/id_generator.dart';
import 'package:deriv_test/core/services/socket.dart';
import 'package:deriv_test/core/utils/socket_response.dart';
import 'package:deriv_test/domain/repos/price_tracker_service.dart';

class PriceTrackerServiceImpl extends IPriceTrackerService {
  PriceTrackerServiceImpl({required SocketConnection socket})
      : _socket = socket;

  final SocketConnection _socket;

  /// Broadcast Stream containing active ticks
  final _ticksStream = StreamController<String>.broadcast();

  /// Creates a streamSubscription for the ticks returned from the socket
  StreamSubscription? _ticksSub;

  /// Stores request id for tick, used to forget (close) connection
  String? _requestId;

  @override
  Future<List<Map<String, dynamic>>> getSymbols() async {
    _forgetTickSubscription();

    final parameters = {
      "active_symbols": "brief",
      "product_type": "basic",
      // "req_id": _requestId = IDGenerator.randomString(),
    };

    _socket.sink.add(jsonEncode(parameters));

    final response = jsonDecode(await _socket.stream.first);

    return (response['active_symbols'] as List).cast<Map<String, dynamic>>();
  }

  @override
  TicksResponse<Stream<String>> getTicks(String symbolId) {
    _forgetTickSubscription();

    final parameters = {
      'ticks': symbolId,
      "req_id": _requestId = IDGenerator.randomString(),
    };

    _socket.sink.add(jsonEncode(parameters));

    //Cancel current tick subscription and registers new one
    _ticksSub?.cancel();

    _ticksSub = _socket.stream.listen((event) {
      final newData = jsonDecode(event);
      //Adds [quote] key's value from tick map to stream, if exists
      if (newData['tick'] != null) {
        _ticksStream.add('Price: \$${newData['tick']['quote']}');
      } else if (newData['error'] != null) {
        _ticksStream.add(newData['error']['message']);
      }
    });

    return TicksResponse(
      ticksStream: _ticksStream.stream,
      subscriptionId: parameters['req_id'] as String,
    );
  }

  ///Sends request to forget server subscription before requestion new one
  void _forgetTickSubscription() {
    if (_requestId == null) return;
    _socket.sink.add(jsonEncode({"forget": _requestId}));
  }
}
