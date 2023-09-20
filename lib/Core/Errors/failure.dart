import 'package:equatable/equatable.dart';

sealed class Failure extends Equatable {
  final String message;
  const Failure({required this.message});
}

class InternetConnectionFailure extends Failure {
  const InternetConnectionFailure(
      {super.message = "Internet connection is not available"});
  @override
  List<Object?> get props => [];
}

class EndpointFailure extends Failure {
  const EndpointFailure({super.message = "Something went wrong"});
  @override
  List<Object?> get props => [];
}

class JsonDecodeFailure extends Failure {
  const JsonDecodeFailure(
      {super.message = "Failed to decode data from server"});
  @override
  List<Object?> get props => [];
}

class JsonEncodeFailure extends Failure {
  const JsonEncodeFailure({super.message = "Failed to encode data"});
  @override
  List<Object?> get props => [];
}

class ServiceError extends JsonEncodeFailure {
  const ServiceError({super.message = "Something went wrong"});
  @override
  List<Object?> get props => [];
}

class StorageFailure extends JsonEncodeFailure {
  const StorageFailure({super.message = "Not able to read/write storage"});
  @override
  List<Object?> get props => [];
}
