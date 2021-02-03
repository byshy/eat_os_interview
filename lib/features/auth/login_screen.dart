import 'dart:math';

import 'package:eat_os_interview/features/auth/bloc/auth_bloc.dart';
import 'package:eat_os_interview/routing/navigation_service.dart';
import 'package:eat_os_interview/routing/routes.dart';
import 'package:eat_os_interview/utils/decorations.dart';
import 'package:eat_os_interview/utils/dimentions.dart';
import 'package:eat_os_interview/utils/global_widgets/custom_raised_button.dart';
import 'package:eat_os_interview/utils/global_widgets/loading_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:keyboard_actions/keyboard_actions.dart';
import 'package:keyboard_actions/keyboard_actions_config.dart';

import '../../di.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey _mainContainer = GlobalKey();
  final GlobalKey _headerHeight = GlobalKey();

  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();

  double elasticHeight = 0;

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        sl<AuthBloc>().add(EmailUnfocused());
      }
    });
    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        sl<AuthBloc>().add(PasswordUnfocused());
      }
    });
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      calculateHeight();
    });
  }

  void calculateHeight() {
    final RenderBox renderBoxRed =
        _mainContainer.currentContext.findRenderObject();
    final RenderBox headerRenderBoxRed =
        _headerHeight.currentContext.findRenderObject();

    Future.delayed(
      Duration(milliseconds: 110),
      () {
        double _height = MediaQuery.of(context).size.height -
            renderBoxRed.size.height -
            headerRenderBoxRed.size.height;
        if (_height > 0) {
          setState(() {
            elasticHeight = _height;
          });
        } else {
          setState(() {
            elasticHeight = 0;
          });
        }
      },
    );
  }

  @override
  void didUpdateWidget(LoginScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    calculateHeight();
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  KeyboardActionsConfig _buildConfig(BuildContext context) {
    return KeyboardActionsConfig(
      keyboardActionsPlatform: KeyboardActionsPlatform.IOS,
      keyboardBarColor: Colors.grey[200],
      nextFocus: true,
      actions: [
        KeyboardActionsItem(
          focusNode: _emailFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.nextFocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Next',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }
          ],
        ),
        KeyboardActionsItem(
          focusNode: _passwordFocusNode,
          toolbarButtons: [
            (node) {
              return GestureDetector(
                onTap: () => node.unfocus(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Done',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ),
              );
            }
          ],
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: KeyboardActions(
        config: _buildConfig(context),
        tapOutsideToDismiss: true,
        child: ListView(
          // This controller is used to prevent the ListView from scrolling
          // when its height matches the screen
          controller: ScrollController(),
          padding: EdgeInsets.zero,
          children: [
            SizedBox(height: elasticHeight / 2),
            Padding(
              key: _headerHeight,
              padding: const EdgeInsets.symmetric(horizontal: 38),
              child: Column(
                children: [
                  Placeholder(fallbackHeight: 200),
                  SizedBox(height: 20),
                  Text(
                    'Welcome to my assigned task!',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    'I hope it meets the standards and you get to like it.',
                  ),
                ],
              ),
            ),
            SizedBox(height: elasticHeight / 2),
            Container(
              key: _mainContainer,
              padding: EdgeInsets.only(
                top: 64,
                right: 37,
                left: 37,
                bottom: max(
                  MediaQuery.of(context).viewPadding.bottom,
                  minBottomPadding,
                ),
              ),
              child: BlocListener<AuthBloc, AuthState>(
                listener: (context, state) {
                  if (state.status.isSubmissionSuccess) {
                    sl<NavigationService>().navigateToAndRemove(home);
                  }
                },
                child: BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, state) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        TextFormField(
                          initialValue: state.email.value,
                          focusNode: _emailFocusNode,
                          keyboardType: TextInputType.emailAddress,
                          onChanged: (value) {
                            sl<AuthBloc>().add(EmailChanged(email: value));
                          },
                          textInputAction: TextInputAction.next,
                          decoration: inputDecoration.copyWith(
                            labelStyle: TextStyle(color: Colors.grey),
                            icon: const Icon(Icons.email),
                            labelText: 'Email',
                            errorText: state.email.invalid
                                ? 'Please ensure the email entered is valid'
                                : null,
                          ),
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          initialValue: state.password.value,
                          focusNode: _passwordFocusNode,
                          obscureText: true,
                          onChanged: (value) {
                            sl<AuthBloc>()
                                .add(PasswordChanged(password: value));
                          },
                          textInputAction: TextInputAction.done,
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus();
                          },
                          decoration: inputDecoration.copyWith(
                            labelStyle: TextStyle(color: Colors.grey),
                            icon: const Icon(Icons.lock),
                            helperMaxLines: 2,
                            labelText: 'Password',
                            errorMaxLines: 2,
                            errorText: state.password.invalid
                                ? '''Password must be at least 8 characters and contain at least one letter and number'''
                                : null,
                          ),
                        ),
                        SizedBox(height: 20),
                        CustomRaisedButton(
                          onTap: state.status.isValidated
                              ? () => sl<AuthBloc>().add(FormSubmitted())
                              : null,
                          child: state.status.isSubmissionInProgress
                              ? LoadingIndicator()
                              : Text(
                                  'LOGIN',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(15),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    offset: Offset(0, -2),
                    blurRadius: 10,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
