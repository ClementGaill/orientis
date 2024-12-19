// ignore_for_file: use_super_parameters, library_private_types_in_public_api

import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:orienty/Auth/homeAuth.dart';
import 'package:orienty/Main/mainPage.dart';
import 'package:orienty/Widgets/Frontend/colors.dart';
import 'package:orienty/firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  // Initialisation de Firebase avec les options spécifiques à la plateforme
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Utilisation du fichier généré
  );

  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Global Fonts with Bold',
      theme: ThemeData(
        colorScheme: colorScheme,
        brightness: Brightness.light,
        primaryColor: primaryColor,
        scaffoldBackgroundColor: backgroundColor,
        fontFamily: 'BalooBhaijaan2',
        textTheme: const TextTheme(
          // Définition des styles pour chaque type de texte
          displayLarge: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 57.0,
            fontWeight: FontWeight.bold, // Gras
          ),
          displayMedium: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 45.0,
            fontWeight: FontWeight.bold, // Gras
          ),
          displaySmall: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 36.0,
            fontWeight: FontWeight.bold, // Gras
          ),

          headlineMedium: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 28.0,
            fontWeight: FontWeight.bold, // Gras
          ),
          headlineSmall: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 24.0,
            fontWeight: FontWeight.bold, // Gras
          ),

          titleLarge: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 22.0,
            fontWeight: FontWeight.bold, // Gras
          ),
          titleMedium: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16.0,
            fontWeight: FontWeight.normal, // Normal
          ),
          titleSmall: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14.0,
            fontWeight: FontWeight.normal, // Normal
          ),

          bodyLarge: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16.0,
            fontWeight: FontWeight.normal, // Normal
          ),
          bodyMedium: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14.0,
            fontWeight: FontWeight.normal, // Normal
          ),
          
          bodySmall: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12.0,
            fontWeight: FontWeight.normal, // Normal
          ),
          
          labelLarge: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14.0,
            fontWeight: FontWeight.bold, // Gras pour les boutons
          ),
          labelSmall: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 11.0,
            fontWeight: FontWeight.normal, // Normal
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            minimumSize: const widgets.Size(double.infinity, 50),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
            backgroundColor: primaryColor, // Fond noir pour les boutons
            foregroundColor: backgroundColor, // Texte en blanc
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'BalooBhaijaan2',
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: backgroundColor, // Fond blanc pour la barre d'application
          foregroundColor: primaryColor, // Texte noir dans la barre d'application
          elevation: 0, // Sans ombre pour un style minimaliste
          centerTitle: false,
        ),
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    verifyAuth();
  }

  void verifyAuth() async {
    // Utilisation de Future.delayed pour garantir que la navigation se produit après l'initialisation complète
    await Future.delayed(const Duration(seconds: 2)); // Attente de 2 secondes pour s'assurer que l'initialisation est complète

    try {
      // Vérification si l'utilisateur est authentifié via Firebase
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Si l'utilisateur est connecté, on redirige vers MainPage
        print('Utilisateur connecté');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const MainPage()),
          );
        }
      } else {
        // Si l'utilisateur n'est pas connecté, on redirige vers HomeAuth
        print('Utilisateur non connecté');
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeAuth()),
          );
        }
      }
    } catch (e) {
      print('Erreur lors de la vérification de l\'authentification: $e');
      // Redirection vers HomeAuth en cas d'erreur
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomeAuth()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Vous pouvez retourner un widget SplashScreen ou une animation de chargement ici
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
}