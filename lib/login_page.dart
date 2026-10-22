import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  void initState() {
    super.initState();
    print("LoginPage: initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("LoginPage: didChangeDependencies");
  }

  @override
  void deactivate() {
    print("LoginPage: deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("LoginPage: dispose");
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("LoginPage: build");
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.storefront, size: 80),
            const SizedBox(height: 16),
            const Text("Mini Product Catalog", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                // ---------- Part 2: Navigator version (commented out) ----------
                // Navigator.pushNamed(context, '/products', arguments: 'Guest');

                // ---------- Part 3: go_router version ----------
                // goNamed REPLACES the stack, so the user can't press Back to Login.
                context.goNamed('products', queryParameters: {'user': 'Guest'});
              },
              child: const Text("Login"),
            ),
          ],
        ),
      ),
    );
  }
}
