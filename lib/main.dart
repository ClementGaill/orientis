// ignore_for_file: use_super_parameters

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:appwrite/appwrite.dart';
import 'package:orienty/Auth/homeAuth.dart';
import 'package:orienty/Main/mainPage.dart';
import 'package:orienty/Widgets/Frontend/colors.dart';

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
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  void verifyAuth() async {
    // Configuration Appwrite
    Client client = Client();
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '')
        .setSelfSigned();


    // Vérification de la session
    try {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MyHomePage()),
      );
      print('connected');
    } catch (e) {
      Navigator.pushReplacement(
      context,
        MaterialPageRoute(builder: (context) => const HomeAuth()),
      );
      print('no connected');
    }
  }


  @override
  void initState() {
    super.initState();

    verifyAuth();
  }
  @override
  Widget build(BuildContext context) {

    return const Scaffold(

    );
  }
}