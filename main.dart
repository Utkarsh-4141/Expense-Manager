import 'package:expense_manager/Controller/category_controller.dart';
import 'package:expense_manager/View/splash_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import "package:expense_manager/Controller/transaction_controller.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyD05eRWiW7qPZ4WX-Sd5AvnuQoE_4HEi-w",
      appId: "1:702527171442:android:dcfd28fad14736f7868beb",
      messagingSenderId: "702527171442",
      projectId: "expense-manager-cffa1",
      storageBucket: "expense-manager-cffa1.firebasestorage.app",
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return Category(categoryList: []);
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return TransactionDemo(transactionList: []);
          },
        )
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: SplashScreen(),
      ),
    );
  }
}
