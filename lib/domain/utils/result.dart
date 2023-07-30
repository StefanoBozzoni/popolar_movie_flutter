sealed class Failure {}

class DefaultFailure extends Failure {
  final String? errorMessage;
  DefaultFailure({this.errorMessage});
}

sealed class Result<T> {}

class ResultSuccess<T> extends Result<T> {
  final T data;
  ResultSuccess(this.data);
}

class ResultFailure extends Result<Failure> {
  final Failure failure;
  ResultFailure(this.failure);
}

class MyEither<R, T> {
  R? success;
  T? failure;
  MyEither({this.success, this.failure});

  fold({Function? successCond, Function? failureCond}) {
    if (success != null && successCond != null) {
      successCond(success);
    }
    if (failure != null && failureCond != null) {
      failureCond(failure);
    }
  }

  bool isSuccess() => success != null;
  bool isFailure() => failure != null;
}
