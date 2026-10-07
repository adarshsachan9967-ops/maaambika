abstract class PartnerInspectionEvent {
  const PartnerInspectionEvent();
}

class ToggleChecklistEvent extends PartnerInspectionEvent {
  final String key;
  final bool value;

  const ToggleChecklistEvent({
    required this.key,
    required this.value,
  });
}

class SubmitInspectionEvent extends PartnerInspectionEvent {
  const SubmitInspectionEvent();
}
