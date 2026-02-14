import 'package:flutter/material.dart';
import 'package:food_app/views/screen/login_screen.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:food_app/providers/cart_provider.dart';
import 'package:food_app/providers/theme_provider.dart';
import 'package:food_app/providers/favorite_provider.dart';
import 'package:food_app/providers/order_provider.dart';

import 'package:food_app/views/widgets/bottum_nav_bar.dart';

void main() {
  runApp(const FoodApp());
}

class FoodApp extends StatelessWidget {
  const FoodApp({super.key});

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLoggedIn") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => FavoriteProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (_, themeProvider, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.currentTheme,

          // 🌞 LIGHT THEME
          theme: ThemeData(
            primarySwatch: Colors.red,
            scaffoldBackgroundColor: Colors.white,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),

          // 🌙 DARK THEME
          darkTheme: ThemeData.dark().copyWith(
            scaffoldBackgroundColor: Colors.black,
            appBarTheme: const AppBarTheme(
              backgroundColor: Colors.black,
              foregroundColor: Colors.white,
            ),
          ),

          // 🔐 CHECK LOGIN STATE
          home: FutureBuilder<bool>(
            future: checkLogin(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }

              return snapshot.data!
                  ? const BottomNavBarScreen()
                  : const LoginScreen();
            },
          ),
        ),
      ),
    );
  }
}
