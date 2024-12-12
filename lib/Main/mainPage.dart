// ignore_for_file: file_names, use_super_parameters, use_build_context_synchronously

import 'package:appwrite/appwrite.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orienty/Auth/homeAuth.dart';
















class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page d'accueil"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              try {
                // Déconnexion de l'utilisateur
                final account = Account(Client()
                  ..setEndpoint('https://cloud.appwrite.io/v1')
                  ..setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '') // Remplacez par votre Project ID
                  ..setSelfSigned());
                await account.deleteSession(sessionId: 'current');
                
                // Redirection vers la page de connexion
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeAuth()),
                );
              } catch (e) {
                print(e);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur lors de la déconnexion $e')),
                );
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Titre Principal',
              style: Theme.of(context).textTheme.displayLarge,
            ),
            const SizedBox(height: 10),
            Text(
              'Sous-titre',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Text(
              'Texte de paragraphe normal',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {},
              child: const Text('Bouton Exemple'),
            ),
          ],
        ),
      ),
    );
  }
}