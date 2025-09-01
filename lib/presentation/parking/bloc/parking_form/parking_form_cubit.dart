import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:zavona_flutter_app/presentation/parking/bloc/parking_form/parking_form_state.dart';
import 'package:zavona_flutter_app/presentation/parking/widgets/parking_form/parking_size_selection_widget.dart';

class ParkingFormCubit extends Cubit<ParkingFormState> {
  ParkingFormCubit() : super(ParkingFormState());

  void toggleSizeSelection(ParkingSize size) {
    final currentSizes = List<ParkingSize>.from(state.selectedSizes);
    if (currentSizes.contains(size)) {
      currentSizes.remove(size);
    } else {
      currentSizes.add(size);
    }
    emit(state.copyWith(selectedSizes: currentSizes));
  }

  void toggleRenOptIn(bool value) {
    emit(state.copyWith(optToRent: value));
  }

  void toggleSellOptIn(bool value) {
    emit(state.copyWith(optToSell: value));
  }
}
