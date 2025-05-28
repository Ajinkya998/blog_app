import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/secrets/supabase_secrets.dart';
import 'package:blog_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:blog_app/features/auth/data/repository/auth_repository_impl.dart';
import 'package:blog_app/features/auth/domain/repository/auth_repository.dart';
import 'package:blog_app/features/auth/domain/usecase/current_user.dart';
import 'package:blog_app/features/auth/domain/usecase/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecase/user_sign_up.dart';
import 'package:blog_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

final serviceLocator = GetIt.instance;

Future<void> initDependencies() async {
  _initAuth();
  final supabase = await Supabase.initialize(
    url: SupabaseSecrets.supabaseUrl,
    anonKey: SupabaseSecrets.supabaseAnonKey,
  );
  serviceLocator.registerSingleton<SupabaseClient>(supabase.client);
}

void _initAuth() {
  serviceLocator.registerFactory<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(serviceLocator<SupabaseClient>()),
  );

  serviceLocator.registerFactory<AuthRepository>(
    () => AuthRepositoryImpl(serviceLocator<AuthRemoteDataSource>()),
  );

  serviceLocator.registerFactory<UserSignUp>(
    () => UserSignUp(serviceLocator<AuthRepository>()),
  );

  serviceLocator.registerFactory<UserSignIn>(
      () => UserSignIn(serviceLocator<AuthRepository>()));

  serviceLocator.registerFactory<CurrentUser>(
      () => CurrentUser(serviceLocator<AuthRepository>()));

  serviceLocator.registerLazySingleton<AppUserCubit>(() => AppUserCubit());

  serviceLocator.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      userSignUp: serviceLocator<UserSignUp>(),
      userSignIn: serviceLocator<UserSignIn>(),
      currentUser: serviceLocator<CurrentUser>(),
      appUserCubit: serviceLocator<AppUserCubit>(),
    ),
  );
}
