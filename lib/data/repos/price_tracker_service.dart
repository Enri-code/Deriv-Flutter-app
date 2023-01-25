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

  final _ticksStream = StreamController<num>.broadcast();

  ///Creates a streamSubscription for the ticks returned from the socket
  StreamSubscription? _ticksSub;
  int? _requestId;

  @override
  Future<List<Map<String, dynamic>>> getSymbols() async {
    _forgetTickSubscription();

    final parameters = jsonEncode({
      "active_symbols": "brief",
      "product_type": "basic",
      "req_id": _requestId = IDGenerator.randomInt(),
    });

    _socket.sink.add(parameters);
    
    return jsonDecode(await _socket.stream.first)['active_symbols']
        as List<Map<String, dynamic>>;
  }

  @override
  TicksResponse<Stream<num>> getTicks(String symbolId) {
    _forgetTickSubscription();
    final map = {
      'ticks': symbolId,
      "req_id": _requestId = IDGenerator.randomInt(),
    };

    _socket.sink.add(jsonEncode(map));

    _ticksSub ??= _socket.stream.listen((event) {
      final newData = jsonDecode(event);
      if (newData['tick'] != null) {
        _ticksStream.add(newData['tick']['quote']);
      } else if (newData['error'] != null) {
        _ticksStream.add(-999);
      }
    });

    return TicksResponse(
      ticksStream: _ticksStream.stream,
      subscriptionId: map['req_id'] as int,
    );
  }

  void _forgetTickSubscription() {
    if (_requestId == null) return;
    final parameters = jsonEncode({"forget": _requestId});
    _socket.sink.add(parameters);
  }
}
