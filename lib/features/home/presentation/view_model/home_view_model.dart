import 'package:flutter_bloc/flutter_bloc.dart';

class HomeViewModel extends Cubit<int> {
  HomeViewModel() : super(0);

  void setIndex(int index) => emit(index);
}
