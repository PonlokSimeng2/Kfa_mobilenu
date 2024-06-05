import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:kfa_mobilenu/afa/screens/Auth/login_page.dart';
import 'package:kfa_mobilenu/providers/auth_provider.dart';

class AuthWrapperWidget extends ConsumerStatefulWidget {
  const AuthWrapperWidget({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AuthWrapperWidgetState();
}

class _AuthWrapperWidgetState extends ConsumerState<AuthWrapperWidget> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    if (authState == null) {
      return const Login();
    }

    return widget.child;
  }
}
