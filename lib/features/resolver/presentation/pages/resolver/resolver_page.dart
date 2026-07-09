import 'package:flutter/material.dart';

class ResolverPage extends StatelessWidget {
  const ResolverPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ResolverUI();
  }
}

class ResolverUI extends StatefulWidget {
  const ResolverUI({super.key});

  @override
  State<ResolverUI> createState() => _ResolverUIState();
}

class _ResolverUIState extends State<ResolverUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Resolver Page")));
  }
}
