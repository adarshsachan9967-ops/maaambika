import '../../../data/models/earnings_summary.dart';

abstract class EarningsState {
  const EarningsState();
}

class EarningsInitial extends EarningsState {
  const EarningsInitial();
}

class EarningsLoading extends EarningsState {
  const EarningsLoading();
}

class EarningsLoaded extends EarningsState {
  final EarningsSummary summary;
  final String? message;

  const EarningsLoaded({
    required this.summary,
    this.message,
  });

  EarningsLoaded copyWith({
    EarningsSummary? summary,
    String? message,
  }) {
    return EarningsLoaded(
      summary: summary ?? this.summary,
      message: message,
    );
  }
}

class EarningsError extends EarningsState {
  final String errorMessage;
  const EarningsError(this.errorMessage);
}
