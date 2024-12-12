// ignore_for_file: file_names, use_build_context_synchronously
import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orienty/Auth/profilAuth.dart';
import 'package:orienty/Main/mainPage.dart';
import 'package:orienty/Widgets/Frontend/textField.dart';
import 'package:page_transition/page_transition.dart';
import '../Widgets/Frontend/delayAnimation.dart';

class PasswordPage extends StatefulWidget {
  final String email;

  const PasswordPage({required this.email, super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  late Client client;
  late Account account;

  @override
  void initState() {
    super.initState();
    client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '');
    account = Account(client);
  }

  Future<void> handleLogin() async {
    try {
      // Tentative de connexion
      await account.createEmailPasswordSession(
        email: widget.email,
        password: passwordController.text.trim(),
      );
      // Redirection vers la page d'accueil
      Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: const MyHomePage(), duration: const Duration(milliseconds: 500)));
    } catch (e) {
      if (e is AppwriteException && e.code == 401) {
        // Si l'utilisateur n'existe pas, création d'un nouveau compte
        final newUser = await account.create(
          userId: ID.unique(),
          email: widget.email,
          password: passwordController.text.trim(),
        );

        // Récupération de l'ID du nouvel utilisateur
        final userId = newUser.$id;

        // Créer une session pour le nouvel utilisateur
        await account.createEmailPasswordSession(
          email: widget.email,
          password: passwordController.text.trim(),
        );

        // Redirection vers la page de configuration
        Navigator.pushReplacement(context, PageTransition(type: PageTransitionType.rightToLeft, child: RegistrationPage(userId: userId), duration: const Duration(milliseconds: 500)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
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
