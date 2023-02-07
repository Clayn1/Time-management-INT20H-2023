part of 'bottom_nav_bar_cubit.dart';

abstract class BottomNavBarState extends Equatable {
  int get currentIndex;

  @override
  List<Object?> get props => [currentIndex];
}

class BottomNavBarInitial extends BottomNavBarState {
  @override
  final int currentIndex;

  BottomNavBarInitial({required this.currentIndex});

  @override
  List<Object?> get props => [currentIndex];
}
