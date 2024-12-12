// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:orienty/Auth/passwordPage.dart';
import 'package:orienty/Widgets/Frontend/delayAnimation.dart';
import 'package:orienty/Widgets/Frontend/textField.dart';
import 'package:page_transition/page_transition.dart';

class EmailAuth extends StatefulWidget {
  const EmailAuth({super.key});

  @override
  State<EmailAuth> createState() => _EmailAuthState();
}

class _EmailAuthState extends State<EmailAuth> {
  final TextEditingController emailController = TextEditingController();

  void navigateToPasswordPage() {
    final email = emailController.text.trim();
    if (email.isNotEmpty) {
      Navigator.push(context, PageTransition(type: PageTransitionType.rightToLeft, child: PasswordPage(email: email), duration: const Duration(milliseconds: 500)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Veuillez entrer un email valide.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                DelayedAnimation(
                  delay: 200,
                  child: Text(
                    'Commençons !',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                DelayedAnimation(
                  delay: 500,
                  child: Text(
                    'Pour commencer, rentre ton numéro de téléEmailAuth...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                DelayedAnimation(
                  delay: 700,
                  child: CustomTextField(
                    hintText: 'john.doe@exemple.com',
                    keyboardType: TextInputType.emailAddress,
                    controller: emailController,
                  ),
                ),
                const SizedBox(height: 5.0),
                DelayedAnimation(
                  delay: 1000,
                  child: ElevatedButton(
                    onPressed: navigateToPasswordPage,
                    child: const Text('Commencer !'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
