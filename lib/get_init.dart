import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:invisquery/Core/Network/network.dart';
import 'package:invisquery/Core/utils/parser.dart';
import 'package:invisquery/Core/utils/stroage.dart';
import 'package:invisquery/Features/Auth/Data/DataSource/auth_repo_impl.dart'; // Import the AuthRepoImpl
import 'package:invisquery/Features/Auth/Domain/Reposatiory/auth_repo.dart';
import 'package:invisquery/Features/Auth/Page/Bloc/login/login_bloc.dart';

final getIt = GetIt.instance;

Future<void> setUp() async {
  // Add 'void' to the setUp function declaration
  // Bloc
  getIt.registerFactory(() => LoginBloc(getIt<
      AuthRepoImpl>())); // Use getIt<AuthRepoImpl>() to retrieve the AuthRepoImpl instance

  // Repositories
  getIt.registerLazySingleton<AuthRepo>(
      () => AuthRepoImpl(getIt(), getIt())); // Register AuthRepoImpl

  //! External
  const FlutterSecureStorage storage = FlutterSecureStorage();
  getIt.registerLazySingleton(() => storage);
  getIt.registerLazySingleton(() => http.Client());
  final InternetConnectionCheckerPlus checkerPlus =
      InternetConnectionCheckerPlus();
  getIt.registerLazySingleton(() => checkerPlus);

  // Core

  getIt.registerLazySingleton<NetworkService>(
      () => NetworkServiceImpl(getIt(), getIt()));
  getIt.registerLazySingleton<JsonObjectUtils>(
      () => JsonObjectUtils()); // Register JsonObjectUtils
  getIt.registerLazySingleton<StorageService>(() => StorageService(getIt<
      FlutterSecureStorage>())); // Use getIt<FlutterSecureStorage>() to retrieve the FlutterSecureStorage instance
}
