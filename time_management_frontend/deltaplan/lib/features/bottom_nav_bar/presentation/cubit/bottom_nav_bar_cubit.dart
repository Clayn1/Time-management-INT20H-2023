import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'bottom_nav_bar_state.dart';

class BottomNavBarCubit extends Cubit<BottomNavBarState> {
  BottomNavBarCubit() : super(BottomNavBarInitial(currentIndex: 0));

  changeIndex(int newIndex) async {
    emit(BottomNavBarInitial(currentIndex: newIndex));
  }
}
