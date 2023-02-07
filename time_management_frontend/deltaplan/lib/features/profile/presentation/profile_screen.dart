import 'package:deltaplan/core/helper/images.dart';
import 'package:deltaplan/core/helper/notification.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/util/url_opener.dart';
import 'package:deltaplan/core/widgets/app_bars/base_app_bar.dart';
import 'package:deltaplan/core/widgets/images/user_avatar.dart';
import 'package:deltaplan/core/widgets/loading/loading_screen.dart';
import 'package:deltaplan/features/profile/presentation/cubit/user/user_cubit.dart';
import 'package:deltaplan/features/sign_up/domain/repositories/token_local_repository.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/auth_cubit/auth_cubit.dart';
import 'package:deltaplan/features/sign_up/presentation/cubit/sign_in_cubit/sign_in_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/profile_tile.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required this.authCubit}) : super(key: key);

  final AuthCubit authCubit;

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late UserCubit cubit;

  @override
  void initState() {
    cubit = sl();
    cubit.getUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<UserCubit, UserState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is UserFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Unexpected error occurred',
                style: montserrat.s14.white.w500,
              ),
            ),
          );
        }
      },
      builder: (context, state) {
        return state is! UserLoading
            ? Scaffold(
                appBar: const BaseAppBar(
                  label: 'Profile',
                ),
                backgroundColor: CColors.black,
                body: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.pw, 20.ph, 20.pw, 0),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.ph,
                      ),
                      const UserAvatar(),
                      SizedBox(
                        height: 20.ph,
                      ),
                      FittedBox(
                        child: Text(
                          state is UserSuccess
                              ? state.user.name ?? state.user.email ?? 'User'
                              : 'User',
                          style: montserrat.s18.w500.white,
                        ),
                      ),
                      SizedBox(
                        height: 50.ph,
                      ),
                      ProfileTile(
                        label: 'Help & Support',
                        icon: Icons.question_mark_rounded,
                        iconColor: Colors.green,
                        bgColor: const Color(0xFFD4FCDD),
                        onTap: () {
                          openUrl("mailto:valyakyo@gmail.com");
                        },
                      ),
                      SizedBox(
                        height: 8.ph,
                      ),
                      ProfileTile(
                        label: 'Logout',
                        icon: Icons.logout,
                        iconColor: Colors.red,
                        onTap: () async {
                          widget.authCubit.removeUserSession();
                          sl<SignInCubit>().deleteFirebaseToken(FCM.fbToken);
                        },
                      ),
                    ],
                  ),
                ),
              )
            : const LoadingScreen(
                withoutBackButton: true,
              );
      },
    );
  }
}
