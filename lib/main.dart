// ============================================================================
//  Homework – Section 4: State Lifecycle & Navigation
//  Mini Product Catalog — Amr Ahmed El-Ghareeb
// ============================================================================
//
//  PART 1 – Lifecycle answers
//  a) First time a page opens:
//     initState -> didChangeDependencies -> build
//     (e.g. "ProductsPage: initState", "ProductsPage: didChangeDependencies ...",
//      "ProductsPage: build")
//
//  b) After pressing the heart button:
//     only build runs again, because setState() marks the State dirty and
//     Flutter rebuilds the widget. initState/didChangeDependencies don't rerun.
//
//  c) Leaving a page and going back:
//     - Opening Details on top of Products (push): Products is NOT disposed — it
//       stays in the stack. Details runs initState -> didChangeDependencies -> build.
//     - Pressing back / Add to Cart (pop): Details runs deactivate -> dispose.
//       Products only runs build again (setState with the cart message).
//     - Login -> Products with goNamed: the stack is replaced, so LoginPage runs
//       deactivate -> dispose and ProductsPage runs initState -> didChangeDependencies -> build.
//
//  d) Resizing the browser window:
//     didChangeDependencies -> build run again on ProductsPage.
//     Why: we read MediaQuery.sizeOf(context) inside didChangeDependencies, so the
//     page DEPENDS on the MediaQuery InheritedWidget. When the window size changes,
//     MediaQuery changes and Flutter notifies every widget that depends on it by
//     calling didChangeDependencies, then rebuilds it. That's also how the layout
//     switches between ListView (< 600) and GridView (>= 600).
//
//  PART 4 – Short answers
//  1) context.go vs context.push:
//     - go REPLACES the current navigation stack with the new location (no back).
//       Example: Login -> Products uses context.goNamed('products', ...).
//     - push ADDS a new page on top of the stack (back works and it can return a result).
//       Example: Products -> Details uses context.push('/details/Laptop/1200').
//
//  2) We used go for Login -> Products because after logging in the user should
//     not be able to press Back and return to the Login page. We used push for
//     Products -> Details because the user must be able to go back to the list,
//     and we need to await the result ("Laptop added to cart") from Details.
//
//  3) Path parameter vs query parameter:
//     - A path parameter is part of the route path itself and is required:
//       /details/Laptop/1200   (route "/details/:name/:price")
//     - A query parameter comes after "?" as key=value and is optional:
//       /products?user=Guest
// ============================================================================

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'details_page.dart';
import 'login_page.dart';
import 'products_page.dart';

void main() {
  runApp(const MyApp());
}

// ---------------------------------------------------------------------------
//  PART 2 – Navigator version (kept, but commented out)
// ---------------------------------------------------------------------------
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Mini Product Catalog',
//       initialRoute: '/',
//       routes: {
//         '/': (context) => const LoginPage(),
//         '/products': (context) {
//           // Read the data sent with Navigator.pushNamed(..., arguments: 'Guest')
//           final username = ModalRoute.of(context)!.settings.arguments as String? ?? 'Guest';
//           return ProductsPage(username: username);
//         },
//       },
//     );
//   }
// }

// ---------------------------------------------------------------------------
//  PART 3 – go_router version (active)
// ---------------------------------------------------------------------------
final GoRouter _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/products',
      name: 'products',
      builder: (context, state) {
        // Query parameter: /products?user=Guest
        final user = state.uri.queryParameters['user'] ?? 'Guest';
        return ProductsPage(username: user);
      },
    ),
    GoRoute(
      path: '/details/:name/:price',
      name: 'details',
      builder: (context, state) {
        // Path parameters: /details/Laptop/1200
        final name = state.pathParameters['name']!;
        final price = int.parse(state.pathParameters['price']!);
        return DetailsPage(name: name, price: price);
      },
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Product Catalog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(colorSchemeSeed: Colors.teal, useMaterial3: true),
      routerConfig: _router,
    );
  }
}
