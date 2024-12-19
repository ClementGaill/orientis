// ignore_for_file: file_names, use_super_parameters, use_build_context_synchronously
import 'package:dot_navigation_bar/dot_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:orienty/Auth/homeAuth.dart';
import 'package:orienty/Main/Pages/Chat/chat.dart';
import 'package:orienty/Widgets/BackEnd/Database/emailVerification.dart';
import 'package:orienty/Widgets/Frontend/colors.dart';


class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {

  @override
  void initState() {
    super.initState();
    EmailVerification(context: context).checkEmailVerified();
  }

  var _selectedTab = _SelectedTab.home;

  void _handleIndexChanged(int i) {
    setState(() {
      _selectedTab = _SelectedTab.values[i];
    });
  }

  @override
  Widget build(BuildContext context) {
    // Contenus des pages basés sur l'onglet sélectionné
    Widget pageContent;
    switch (_selectedTab) {
      case _SelectedTab.home:
        pageContent = const HomeScreen();
        break;
      case _SelectedTab.chat:
        pageContent = const ChatScreen();
        break;
      case _SelectedTab.profile:
        pageContent = const ProfileScreen();
        break;
    }
    
    return Scaffold(
      extendBody: true,
      body: pageContent,
      bottomNavigationBar: SizedBox(
        height: 130, // Ajustez la hauteur selon les besoins
        child: DotNavigationBar(
          backgroundColor: secondaryColor,
          margin: const EdgeInsets.symmetric(horizontal: 10),
          currentIndex: _SelectedTab.values.indexOf(_selectedTab),
          dotIndicatorColor: primaryColor,
          unselectedItemColor: greyColor,
          splashBorderRadius: 50,
          marginR: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          onTap: _handleIndexChanged,
          items: [
            DotNavigationBarItem(
              icon: const Icon(LucideIcons.home),
              selectedColor: primaryColor,
            ),
            DotNavigationBarItem(
              icon: const Icon(LucideIcons.compass),
              selectedColor: primaryColor,
            ),
            DotNavigationBarItem(
              icon: const Icon(LucideIcons.user2),
              selectedColor: primaryColor,
            ),
          ],
        ),
      ),

    );

  }
}

// Enum pour définir les onglets
enum _SelectedTab { home, chat, profile }




// Écrans pour chaque onglet
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: primaryColor,
      body: Center(
        child: Text(
          "Home Page",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const GroupChatsPage();
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: errorColor,
      body: Center(
        child: IconButton(onPressed: () {FirebaseAuth.instance.signOut();}, icon: const Icon(LucideIcons.logOut))
      ),
    );
  }
}








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
                FirebaseAuth.instance.signOut();
                
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