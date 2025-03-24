part of 'network_cubit.dart';

class NetworkState extends Equatable {
  const NetworkState({
    required this.hasInternet,
  });

  final bool hasInternet;

  @override
  List<Object> get props => [
      hasInternet,
  ];
}
