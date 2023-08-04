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

  fold({Function(R)? successCond, Function(T)? failureCond}) {
    final R? mysuccess = success;
    if (mysuccess != null && successCond != null) {
      successCond(mysuccess);
    }
    final T? myfailure = failure;
    if (myfailure != null && failureCond != null) {
        failureCond(myfailure);
    }
  }

  bool isSuccess() => success != null;
  bool isFailure() => failure != null;
}
