import 'package:deltaplan/core/helper/images.dart';
import 'package:deltaplan/core/helper/notification.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/input_converter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/buttons/base_button.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/token_local_repository.dart';
import 'package:deltaplan/features/sign_up/presentation/registration_screen.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'components/auth_text_field.dart';
import 'cubit/auth_cubit/auth_cubit.dart';
import 'cubit/sign_in_cubit/sign_in_cubit.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.authCubit}) : super(key: key);

  final AuthCubit authCubit;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  SignInCubit cubit = sl();

  String email = '';
  String password = '';

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignInCubit, SignInState>(
      bloc: cubit,
      listener: (context, state) async {
        if (state is SignInSuccess) {
          widget.authCubit
              .saveUserSession(state.token)
              .then((value) => cubit.setFirebaseToken(FCM.fbToken));
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: CColors.black,
          body: KeyboardDismissOnTap(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.pw),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.ph,
                      ),
                      Image.asset(
                        PngImages.logo2,
                        color: CColors.white,
                        height: 130.ph,
                      ),
                      SizedBox(
                        height: 30.ph,
                      ),
                      Column(
                        children: [
                          Text(
                            'Welcome to DeltaPlan!',
                            style: montserrat.white.w700.s24,
                          ),
                          SizedBox(
                            height: 16.ph,
                          ),
                          Text(
                            'Please sign in your account',
                            style: montserrat.white.w500.s18,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.ph,
                      ),
                      AuthTextField(
                        hintText: 'Enter your email',
                        onChanged: (s) {
                          setState(() {
                            email = s;
                          });
                        },
                        keyboardType: TextInputType.emailAddress,
                      ),
                      SizedBox(
                        height: 12.ph,
                      ),
                      AuthTextField(
                        hintText: 'Enter your password',
                        onChanged: (s) {
                          setState(() {
                            password = s;
                          });
                        },
                        obscureText: true,
                      ),
                      SizedBox(
                        height: 30.ph,
                      ),
                      state is SignInFailure
                          ? Container(
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(bottom: 10.ph, left: 6.pw),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  state.message,
                                  style: montserrat.w500.s13
                                      .copyWith(color: Colors.red.shade400),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      _button(state),
                      SizedBox(
                        height: 30.ph,
                      ),
                      RichText(
                        text: TextSpan(
                          text: 'Don\'t have an account?',
                          style: montserrat.white.s14.w500,
                          children: <TextSpan>[
                            TextSpan(
                                text: '  Sign up',
                                style: montserrat.blue.s14.w500,
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => RegistrationScreen(
                                          authCubit: widget.authCubit,
                                        ),
                                      ),
                                    );
                                  })
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _button(SignInState state) => BaseButton(
        label: "Continue",
        onTap: () {
          if (InputChecker.checkEmail(email)) {
            cubit.signIn(email, password);
          } else {
            cubit.setEmailValidationError();
          }
        },
        isActive: email.isNotEmpty && password.length > 5,
        isLoading: state is SignInLoading,
        padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 14.ph),
      );
}
