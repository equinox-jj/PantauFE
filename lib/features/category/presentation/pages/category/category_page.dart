import 'package:flutter/material.dart';

class CategoryPage extends StatelessWidget {
  const CategoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CategoryUI();
  }
}

class CategoryUI extends StatefulWidget {
  const CategoryUI({super.key});

  @override
  State<CategoryUI> createState() => _CategoryUIState();
}

class _CategoryUIState extends State<CategoryUI> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: Text("Category Page")));
  }
}
