import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invisquery/Features/SplashScreen/Bloc/splash_bloc.dart';

@RoutePage(name: 'Splash')
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    BlocProvider.of<SplashBloc>(context).add(SplashEventCheckAuth());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<SplashBloc, SplashState>(
        listener: (context, state) {
          if (state is SplashLoadingSuccess) {
            if (state.isAuthenticated) {
              context.router.replaceNamed('/home');
            } else {
              context.router.replaceNamed('/auth');
            }
          }
        },
        child: const Center(
          child: CircularProgressIndicator(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
