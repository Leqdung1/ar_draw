import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:ragnarok_flutter/network/network_service.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

part 'network_state.dart';

class NetworkCubit extends Cubit<NetworkState> {
  static NetworkCubit? _instance;
  static NetworkCubit get instance => _instance ??= NetworkCubit._();

  factory NetworkCubit() => instance;

  NetworkCubit._() : super(const NetworkState(hasInternet: false)) {
    check;
    _subscription = _dataConnectionChecker.onStatusChange.listen((status) {
      if(status == DataConnectionStatus.disconnected){
        appLog.log('No internet connection',name: 'NetworkChecker');
        emit(const NetworkState(hasInternet: false));
      }else{
        appLog.log('Internet connected',name: 'NetworkChecker');
        emit(const NetworkState(hasInternet: true));
      }
    });
    appLog.log('NetworkCubit initialized: ${state.hasInternet}',name: 'NetworkChecker');
  }

  late final StreamSubscription _subscription;

  final DataConnectionChecker _dataConnectionChecker = DataConnectionChecker();

  Stream<NetworkState> get networkStream => stream.asBroadcastStream();

  Future<DataConnectionStatus> get check =>
      _dataConnectionChecker.connectionStatus;

  @override
  Future<void> close() {
    _subscription.cancel();
    return super.close();
  }
}
