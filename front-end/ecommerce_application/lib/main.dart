import 'package:ecommerce_application/src/screens/cart/cart.dart';
import 'package:ecommerce_application/src/screens/signup/register.dart';
import 'package:flutter/material.dart';
import 'src/screens/login/login_page.dart';
import 'src/screens/home/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ecommerce Demo',
      initialRoute: '/login',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/login':
            return MaterialPageRoute(builder: (context) => const LoginPage());
          case '/register':
            return MaterialPageRoute(builder: (context) => const MyRegister());
          case '/home':
            final token = settings.arguments as String?;
            print("Navigating to home with token: $token"); // Debug print

            if (token == null) {
              // Handle error: No token found, show error or redirect to login
              return MaterialPageRoute(builder: (context) => const LoginPage());
            }
            return MaterialPageRoute(
              builder: (context) => HomePage(token: token),
            );
          case '/cart':
            return MaterialPageRoute(builder: (context) => const CartScreen());
          default:
            return null;
        }
      },
      theme: ThemeData(fontFamily: "SF-pro-Text"),
      // Removed the 'home' parameter as initialRoute handles it
    );
  }
}
