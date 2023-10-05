part of 'splash_bloc.dart';

abstract class SplashState extends Equatable {
  const SplashState();
}

class SplashInitial extends SplashState {
  @override
  List<Object> get props => [];
}

class SplashLoadingSuccess extends SplashState {
  final bool isAuthenticated;

  const SplashLoadingSuccess(this.isAuthenticated);
  @override
  List<Object?> get props => [];
}
