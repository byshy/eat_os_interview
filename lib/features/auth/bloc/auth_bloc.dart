import 'dart:async';
import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:eat_os_interview/models/models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:formz/formz.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is EmailChanged) {
      final email = Email.dirty(event.email);
      yield state.copyWith(
        email: email.valid ? email : Email.pure(event.email),
        status: Formz.validate([email, state.password]),
      );
    } else if (event is PasswordChanged) {
      final password = Password.dirty(event.password);
      yield state.copyWith(
        password: password.valid ? password : Password.pure(event.password),
        status: Formz.validate([state.email, password]),
      );
    } else if (event is EmailUnfocused) {
      final email = Email.dirty(state.email.value);
      yield state.copyWith(
        email: email,
        status: Formz.validate([email, state.password]),
      );
    } else if (event is PasswordUnfocused) {
      final password = Password.dirty(state.password.value);
      yield state.copyWith(
        password: password,
        status: Formz.validate([state.email, password]),
      );
    } else if (event is FormSubmitted) {
      final email = Email.dirty(state.email.value);
      final password = Password.dirty(state.password.value);
      yield state.copyWith(
        email: email,
        password: password,
        status: Formz.validate([email, password]),
      );
      if (state.status.isValidated) {
        yield state.copyWith(status: FormzStatus.submissionInProgress);
        await Future<void>.delayed(const Duration(seconds: 1));
        yield state.copyWith(status: FormzStatus.submissionSuccess);
      }
    } else if (event is FacebookLoginEvent) {
      await loginWithFacebook();

      yield state.copyWith(status: FormzStatus.submissionSuccess);
    }
  }

  final fb = FacebookLogin();

  Future<void> loginWithFacebook() async {
    final res = await fb.logIn(['email']);

    fb.loginBehavior = FacebookLoginBehavior.webViewOnly;

    switch (res.status) {
      case FacebookLoginStatus.loggedIn:
        final token = res.accessToken.token;
        final graphResponse = await Dio().get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${token}');
        final profile = json.decode(graphResponse.data);

        print('profile: $profile');

        break;
      case FacebookLoginStatus.cancelledByUser:
        // User cancel log in
        break;
      case FacebookLoginStatus.error:
        // Log in failed
        print('Error while log in: ${res.errorMessage}');
        break;
    }

    return;
  }
}
