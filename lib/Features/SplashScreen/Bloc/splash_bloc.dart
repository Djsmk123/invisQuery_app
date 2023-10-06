import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart';

part 'splash_event.dart';
part 'splash_state.dart';

class SplashBloc extends Bloc<SplashEvent, SplashState> {
  final AuthRepoImpl authRepoImpl;
  SplashBloc(this.authRepoImpl) : super(SplashInitial()) {
    on<SplashEvent>((event, emit) async {
      if (event is SplashEventCheckAuth) {
        try {
          final res = await authRepoImpl.getAccessToken();
          if (res.$1 != null) {
            emit(const SplashLoadingSuccess(false));
          } else {
            //fetch user using access token
            final user = await authRepoImpl.getUser();
            if (user.$1 != null) {
              emit(const SplashLoadingSuccess(false));
            } else {
              emit(const SplashLoadingSuccess(true));
            }
          }
        } catch (e) {
          log(e.toString());
          emit(const SplashLoadingSuccess(false));
        }
      }
    });
  }
}
