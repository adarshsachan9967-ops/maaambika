abstract class SellState {
  const SellState();
}

class SellInitial extends SellState {
  const SellInitial();
}

class SellLoading extends SellState {
  const SellLoading();
}

class SellStepChanged extends SellState {
  final int step;
  final Map<String, dynamic>? selectedCategory;
  final Map<String, dynamic>? selectedModel;
  final int calculatedPrice;

  const SellStepChanged({
    required this.step,
    this.selectedCategory,
    this.selectedModel,
    required this.calculatedPrice,
  });
}

class SellOrderSuccess extends SellState {
  final String orderId;
  const SellOrderSuccess(this.orderId);
}

class SellError extends SellState {
  final String message;
  const SellError(this.message);
}
