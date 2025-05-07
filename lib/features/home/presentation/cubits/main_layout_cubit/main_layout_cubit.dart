import 'package:flutter_bloc/flutter_bloc.dart';
import 'main_layout_state.dart';

class MainLayoutCubit extends Cubit<MainLayoutState> {
  MainLayoutCubit() : super(const MainLayoutState());

  void changePage(int index) {
    emit(state.copyWith(currentIndex: index));
  }
} 