import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../../../core/base/base.dart';
import '../../../../../../core/utils/enums/enums.dart';
import '../../../../../auth/di/di.dart';

part 'is_resolver_provider.g.dart';

/// Whether the signed-in user is a resolver, read from the locally cached
/// role — the same lookup `Splash` uses to decide which shell to land in.
/// Gates [ReportStatusActionPanel]: a citizen viewing this same shared detail
/// page never sees the status-change action.
@riverpod
Future<bool> isResolver(Ref ref) async {
  final usecase = ref.read(getCachedRoleUsecaseProvider);
  final result = await usecase(const NoParams());

  return result.fold((_) => false, (role) => role == UserRole.resolver);
}
