import 'package:deltaplan/core/helper/images.dart';
import 'package:deltaplan/core/helper/notification.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/input_converter.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/app_bars/base_app_bar.dart';
import 'package:deltaplan/core/widgets/buttons/base_button.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/sign_up_cubit/sign_up_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

import 'components/auth_text_field.dart';

class RegistrationScreen extends StatefulWidget {
  RegistrationScreen({Key? key, required this.authCubit}) : super(key: key);

  final AuthCubit authCubit;

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  SignUpCubit cubit = sl();

  String name = "";
  String email = "";
  String password = "";

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SignUpCubit, SignUpState>(
      listener: (context, state) async {
        if (state is SignUpSuccess) {
          widget.authCubit.saveUserSession(state.token).then((value) {
            sl<SignInCubit>().setFirebaseToken(FCM.fbToken);
            Navigator.pop(context);
          });
        }
      },
      bloc: cubit,
      builder: (context, state) {
        return Scaffold(
          appBar: const BaseAppBar(
            label: '',
            isBackButton: true,
          ),
          backgroundColor: CColors.black,
          body: KeyboardDismissOnTap(
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 20.pw),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10.ph,
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
                            'Please register your account',
                            style: montserrat.white.w500.s18,
                          )
                        ],
                      ),
                      SizedBox(
                        height: 30.ph,
                      ),
                      AuthTextField(
                        hintText: 'Enter your name',
                        onChanged: (s) {
                          setState(() {
                            name = s;
                          });
                        },
                        keyboardType: TextInputType.name,
                      ),
                      SizedBox(
                        height: 12.ph,
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
                      state is SignUpFailure
                          ? Container(
                              width: double.infinity,
                              margin:
                                  EdgeInsets.only(bottom: 10.ph, left: 6.pw),
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  'Email is incorrect',
                                  style: montserrat.w500.s13
                                      .copyWith(color: Colors.red.shade400),
                                ),
                              ),
                            )
                          : const SizedBox(),
                      _button(state),
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

  Widget _button(SignUpState state) => BaseButton(
        label: "Continue",
        onTap: () {
          if (InputChecker.checkEmail(email)) {
            cubit.signUp(name, email, password);
          } else {
            cubit.setEmailValidationError();
          }
        },
        isActive: name.isNotEmpty && email.isNotEmpty && password.length > 5,
        isLoading: state is SignUpLoading,
        padding: EdgeInsets.symmetric(horizontal: 16.pw, vertical: 14.ph),
      );
}
