import 'package:flutter/material.dart';

import 'features/todo/presentation/pages/todo_view.dart';

class InitialScreen extends StatelessWidget {
  const InitialScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => TodoBlocProviderWrapper(),
              ),
            ),
            child: Text('Go to TODO'),
          ),
        ),
      ),
    );
  }
}
