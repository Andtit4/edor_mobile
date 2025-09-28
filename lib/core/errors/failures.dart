import 'package:freezed_annotation/freezed_annotation.dart';

part 'failures.freezed.dart';

@freezed
class Failure with _$Failure {
  const factory Failure.cache({required String message}) = CacheFailure;
  const factory Failure.server({required String message}) = ServerFailure;
  const factory Failure.authentication({required String message}) = AuthenticationFailure;
  const factory Failure.unknown({required String message}) = UnknownFailure;
}
