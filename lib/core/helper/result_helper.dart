class ResultHelper<T> {
  final bool isLoading;
  final bool isSuccess;
  final bool isError;
  final String titleMessage;
  final String descriptionMessage;
  final T? data;

  const ResultHelper({
    this.isLoading = false,
    this.isSuccess = false,
    this.isError = false,
    this.titleMessage = '',
    this.descriptionMessage = '',
    this.data,
  });

  const ResultHelper.initial() : this();

  factory ResultHelper.loading() => const ResultHelper(isLoading: true);

  factory ResultHelper.success({
    T? data,
    String titleMessage = '',
    String descriptionMessage = '',
  }) =>
      ResultHelper(
        isSuccess: true,
        titleMessage: titleMessage,
        descriptionMessage: descriptionMessage,
        data: data,
      );

  factory ResultHelper.error({
    T? data,
    String titleMessage = '',
    String descriptionMessage = '',
  }) =>
      ResultHelper(
        isError: true,
        titleMessage: titleMessage,
        descriptionMessage: descriptionMessage,
        data: data,
      );

  ResultHelper<T> copyWith({
    bool? isLoading,
    bool? isSuccess,
    bool? isError,
    String? titleMessage,
    String? descriptionMessage,
    T? data,
  }) =>
      ResultHelper(
        isLoading: isLoading ?? this.isLoading,
        isSuccess: isSuccess ?? this.isSuccess,
        isError: isError ?? this.isError,
        titleMessage: titleMessage ?? this.titleMessage,
        descriptionMessage: descriptionMessage ?? this.descriptionMessage,
        data: data ?? this.data,
      );
}
