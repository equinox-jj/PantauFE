import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/base/base.dart';
import '../../../../../auth/di/di.dart';

part 'logout_notifier.g.dart';

/// Clears the stored session. `AsyncData(true)` means the sign-out landed and
/// the listener may navigate away.
@riverpod
class Logout extends _$Logout {
  @override
  AsyncValue<bool> build() => const AsyncData(false);

  Future<void> logout() async {
    state = const AsyncLoading();

    final logoutUsecase = ref.read(logoutUsecaseProvider);
    final result = await logoutUsecase(const NoParams());

    result.fold(
      (l) => state = AsyncError(l, StackTrace.current),
      (_) => state = const AsyncData(true),
    );
  }
}
