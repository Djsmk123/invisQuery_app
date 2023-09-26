import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:invisquery/Core/utils/theme.dart';
import 'package:invisquery/Features/Auth/Page/Bloc/login/login_bloc.dart';
import 'package:invisquery/Features/Auth/Page/View/login_screen.dart';

import 'get_init.dart' as di;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.setUp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginBloc>(
          create: (context) =>
              LoginBloc(di.getIt()), // Create your LoginBloc here
        ),
      ],
      child: ScreenUtilInit(
        designSize: const Size(360, 800),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: CustomTheme.data,
          builder: EasyLoading.init(),
          home: const LoginScreen(),
        ),
      ),
    );
  }
}
