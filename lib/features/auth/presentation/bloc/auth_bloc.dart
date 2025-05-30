import 'package:blog_app/core/common/cubits/app_user/app_user_cubit.dart';
import 'package:blog_app/core/common/entities/user.dart';
import 'package:blog_app/features/auth/domain/usecase/current_user.dart';
import 'package:blog_app/features/auth/domain/usecase/user_sign_in.dart';
import 'package:blog_app/features/auth/domain/usecase/user_sign_up.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final UserSignUp _userSignUp;
  final UserSignIn _userSignIn;
  final CurrentUser _currentUser;
  final AppUserCubit _appUserCubit;
  AuthBloc(
      {required UserSignUp userSignUp,
      required UserSignIn userSignIn,
      required CurrentUser currentUser,
      required AppUserCubit appUserCubit})
      : _userSignUp = userSignUp,
        _userSignIn = userSignIn,
        _currentUser = currentUser,
        _appUserCubit = appUserCubit,
        super(AuthInitial()) {
    on<AuthEvent>((_, emit) => emit(AuthLoading()));

    on<AuthSignUp>((event, emit) async {
      final res = await _userSignUp(
        UserSignUpParams(
          name: event.name,
          email: event.email,
          password: event.password,
        ),
      );

      res.fold((failure) => emit(AuthFailure(failure.message)), (user) {
        _appUserCubit.updateUser(user);
        emit(AuthSuccess(user));
      });
    });

    on<AuthSignIn>((event, emit) async {
      final res = await _userSignIn(
        UserSignInParams(
          email: event.email,
          password: event.password,
        ),
      );
      res.fold((failure) => emit(AuthFailure(failure.message)), (user) {
        _appUserCubit.updateUser(user);
        emit(AuthSuccess(user));
      });
    });

    on<AuthIsUserLoggedIn>((event, emit) async {
      final res = await _currentUser(NoParams());
      res.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) {
          _appUserCubit.updateUser(user);
          emit(AuthSuccess(user));
        },
      );
    });
  }
}
