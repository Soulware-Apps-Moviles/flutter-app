enum YouStatus { initial, loading, success, error }

class YouState {
  final YouStatus status;
  final String? errorMessage;

  const YouState({
    this.status = YouStatus.initial,
    this.errorMessage,
  });

  YouState copyWith({
    YouStatus? status,
    String? errorMessage,
  }) {
    return YouState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}