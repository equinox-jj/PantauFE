import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pantau/features/auth/presentation/pages/login/listener/listener.dart';

import '../../../../../core/components/button/button.dart';
import '../../../../../core/components/textfield/textfield.dart';
import '../../../../../core/utils/extensions/extensions.dart';
import 'provider/provider.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = .new();
  final TextEditingController _passwordController = .new();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LoginListener(
          child: Column(
            crossAxisAlignment: .stretch,
            children: [
              Text(
                'Welcome back',
                style: context.textTheme.headlineLarge,
              ),
              Text(
                'Sign in to keep tracking your reports.',
                style: context.textTheme.bodyLarge,
              ),
              Text(
                'Email',
                style: context.textTheme.labelLarge,
              ),
              AppTextField(
                controller: _emailController,
              ),
              Text(
                'Password',
                style: context.textTheme.labelLarge,
              ),
              AppTextField(
                controller: _passwordController,
              ),
              AppButton(
                text: 'Sign in',
                trailing: const Icon(Icons.arrow_forward),
                variant: ButtonVariant.primary,
                onPressed: () async {
                  await ref
                      .read(loginUserProvider.notifier)
                      .login(
                        email: _emailController.text,
                        password: _passwordController.text,
                      );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
