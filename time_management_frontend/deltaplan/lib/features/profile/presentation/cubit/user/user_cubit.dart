import 'package:bloc/bloc.dart';
import 'package:deltaplan/features/profile/domain/entities/user.dart';
import 'package:deltaplan/features/profile/domain/repositories/user_repository.dart';
import 'package:meta/meta.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit({required this.repository}) : super(UserLoading());

  final UserRepository repository;

  Future getUser() async {
    final response = await repository.getUser();
    emit(response.fold(
        (failure) => UserFailure(), (data) => UserSuccess(user: data)));
  }
}
