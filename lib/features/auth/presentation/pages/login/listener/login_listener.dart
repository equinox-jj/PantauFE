import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../../core/components/dialog/dialog.dart';
import '../provider/provider.dart';

class LoginListener extends ConsumerWidget {
  const LoginListener({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(loginUserProvider, (previous, next) {
      switch (next) {
        case AsyncLoading():
          LoadingDialog.show(context);
          break;
        case AsyncData(value: final result):
          LoadingDialog.dismiss(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              content: Center(child: Text(result?.message ?? '')),
            ),
          );
          break;
        case AsyncError(error: final error):
          LoadingDialog.dismiss(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              content: Center(child: Text(error.toString())),
            ),
          );
          break;
      }
    });

    return child;
  }
}
