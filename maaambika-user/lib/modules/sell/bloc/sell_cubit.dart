import 'package:flutter_bloc/flutter_bloc.dart';
import 'sell_state.dart';

class SellCubit extends Cubit<SellState> {
  SellCubit() : super(const SellInitial());

  int _step = 0;
  Map<String, dynamic>? _category;
  Map<String, dynamic>? _model;
  int _calculatedPrice = 0;

  void selectCategory(Map<String, dynamic> category) {
    _category = category;
    _step = 1;
    emit(SellStepChanged(
      step: _step,
      selectedCategory: _category,
      selectedModel: _model,
      calculatedPrice: _calculatedPrice,
    ));
  }

  void selectModel(Map<String, dynamic> model, int basePrice) {
    _model = model;
    _calculatedPrice = basePrice;
    _step = 2;
    emit(SellStepChanged(
      step: _step,
      selectedCategory: _category,
      selectedModel: _model,
      calculatedPrice: _calculatedPrice,
    ));
  }

  void updatePrice(int price) {
    _calculatedPrice = price;
    emit(SellStepChanged(
      step: _step,
      selectedCategory: _category,
      selectedModel: _model,
      calculatedPrice: _calculatedPrice,
    ));
  }

  void setStep(int step) {
    _step = step;
    emit(SellStepChanged(
      step: _step,
      selectedCategory: _category,
      selectedModel: _model,
      calculatedPrice: _calculatedPrice,
    ));
  }

  void reset() {
    _step = 0;
    _category = null;
    _model = null;
    _calculatedPrice = 0;
    emit(const SellInitial());
  }
}
