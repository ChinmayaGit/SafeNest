import 'package:flutter/material.dart';
import 'package:parental_controll_app/signin.dart';

class SinginOptions extends StatefulWidget {
  static String routeName = 'signinOptions';
  const SinginOptions({super.key});

  @override
  State<SinginOptions> createState() => _SinginOptionsState();
}

class _SinginOptionsState extends State<SinginOptions> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade900, Colors.blue.shade700],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildButton(
                backgroundColor: Colors.blue.shade500,
                textColor: Colors.white,
                text: 'Login as Parent',
                onPressed: _navigateToParentSignIn,
              ),
              const SizedBox(height: 20),
              const Text(
                'OR',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              _buildButton(
                backgroundColor: Colors.yellow,
                textColor: Colors.red,
                text: 'Login as Child',
                onPressed: _navigateToChildSignIn,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildButton({
    required Color backgroundColor,
    required Color textColor,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.6,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(50),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Center(
              child: Text(
                text,
                style: TextStyle(
                  color: textColor,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Roboto', // Futuristic font
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _navigateToParentSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const SignIn(title: 'Parent', isParent: true);
        },
      ),
    );
  }

  void _navigateToChildSignIn() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) {
          return const SignIn(title: 'Child', isParent: false);
        },
      ),
    );
  }
}
