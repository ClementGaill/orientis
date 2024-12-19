// ignore_for_file: file_names, use_build_context_synchronously
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:orienty/Auth/profilAuth.dart';
import 'package:orienty/Main/mainPage.dart';
import 'package:orienty/Widgets/Frontend/delayAnimation.dart';
import 'package:orienty/Widgets/Frontend/textField.dart';
import 'package:page_transition/page_transition.dart';

class PasswordPage extends StatefulWidget {
  final String email;

  const PasswordPage({super.key, required this.email});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> handleLogin() async {
    try {
      // Tentative de connexion
      // ignore: unused_local_variable
      final UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: widget.email,
        password: passwordController.text.trim(),
      );

      // Redirection vers la page principale
      Navigator.pushReplacement(
        context,
        PageTransition(
          type: PageTransitionType.rightToLeft,
          child: const MainPage(),
          duration: const Duration(milliseconds: 500),
        ),
      );
    } catch (e) {
      if (e is FirebaseAuthException && e.code == 'user-not-found') {
        try {
          // Création d'un nouvel utilisateur
          final UserCredential newUser = await _auth.createUserWithEmailAndPassword(
            email: widget.email,
            password: passwordController.text.trim(),
          );

          // Récupération de l'ID du nouvel utilisateur
          final String userId = newUser.user?.uid ?? '';

          // Redirection vers la page de configuration du profil
          Navigator.pushReplacement(
            context,
            PageTransition(
              type: PageTransitionType.rightToLeft,
              child: RegistrationPage(userId: userId),
              duration: const Duration(milliseconds: 500),
            ),
          );
        } catch (signupError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Erreur lors de l\'inscription : $signupError')),
          );
          print(signupError);
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur : $e')),
        );
        print('erreur: $e');
      }
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
                    'Une vérification s\'impose !',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                DelayedAnimation(
                  delay: 500,
                  child: Text(
                    'Rentre ton mots de passe !',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                DelayedAnimation(
                  delay: 700,
                  child: CustomTextField(
                    obscureText: true,
                    controller: passwordController,
                  )
                ),
                const SizedBox(height: 5.0),
                DelayedAnimation(
                  delay: 1000,
                  child: ElevatedButton(
                    onPressed: handleLogin,
                    child: const Text('Connexion !'),
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
