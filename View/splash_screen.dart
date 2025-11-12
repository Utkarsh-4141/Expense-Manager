import "package:expense_manager/View/login_screen.dart";
import "package:flutter/material.dart";
import "package:google_fonts/google_fonts.dart";

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void navigate(BuildContext context) {
    Future.delayed(const Duration(seconds: 3), () {
      // ignore: use_build_context_synchronously
      Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (context) {
        return const LoginScreen();
      }));
    });
  }

  @override
  Widget build(BuildContext context) {
    navigate(context);
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const SizedBox(height: 50),
          Container(
            padding: const EdgeInsets.all(30),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color.fromRGBO(234, 238, 235, 1),
            ),
            child: Image.asset("assets/icons/splash screen icon.png"),
          ),
          const SizedBox(height: 20),
          Text(
            "Expense Manager",
            style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: const Color.fromRGBO(0, 0, 0, 1)),
          )
        ],
      ),
    ));
  }
}
