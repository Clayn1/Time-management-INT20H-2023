import 'package:deltaplan/core/helper/images.dart';
import 'package:deltaplan/core/style/colors.dart';
import 'package:deltaplan/core/style/text_styles.dart';
import 'package:deltaplan/core/util/pixel_sizer.dart';
import 'package:deltaplan/core/widgets/app_bars/base_app_bar.dart';
import 'package:deltaplan/core/widgets/loading/loading_screen.dart';
import 'package:deltaplan/features/invites/presentation/cubit/invite_cubit.dart';
import 'package:deltaplan/injection_container.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'components/invite_tile.dart';

class InviteScreen extends StatefulWidget {
  const InviteScreen({Key? key}) : super(key: key);

  @override
  State<InviteScreen> createState() => _InviteScreenState();
}

class _InviteScreenState extends State<InviteScreen> {
  InviteCubit cubit = sl();

  @override
  void initState() {
    cubit.getInvites();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<InviteCubit, InviteState>(
      bloc: cubit,
      listener: (context, state) {
        if (state is InviteFailure) {
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
        return state is InviteInitial
            ? const LoadingScreen(
                withoutBackButton: true,
              )
            : Scaffold(
                backgroundColor: CColors.black,
                appBar: const BaseAppBar(
                  label: 'Invites',
                ),
                body: Container(
                  width: double.infinity,
                  padding: EdgeInsets.fromLTRB(20.pw, 20.ph, 20.pw, 0),
                  child: state.invites.isEmpty
                      ? const NoInvites()
                      : SingleChildScrollView(
                          child: Column(
                            children: [
                              ...List.generate(
                                state.invites.length,
                                (index) => Padding(
                                  padding: EdgeInsets.only(bottom: 8.ph),
                                  child: InviteTile(
                                    invite: state.invites[index],
                                    index: index,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 130.ph,
                              ),
                            ],
                          ),
                        ),
                ),
              );
      },
    );
  }
}

class NoInvites extends StatelessWidget {
  const NoInvites({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150.ph,
        ),
        Text(
          'You don\'t have any invites yet',
          style: montserrat.s18.w500.white,
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 30.ph,
        ),
        Image.asset(
          PngIcons.noMessages,
          color: CColors.white,
          height: 150.pw,
          width: 150.pw,
        ),
        SizedBox(
          height: 30.ph,
        ),
      ],
    );
  }
}
