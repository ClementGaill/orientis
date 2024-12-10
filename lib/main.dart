import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart' as widgets;
import 'package:orientis/Auth/phone.dart';

final navigatorKey = GlobalKey<NavigatorState>();


class MyHttpOverrides extends HttpOverrides{
  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Global Fonts with Bold',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.black,
        scaffoldBackgroundColor: Colors.white,
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
            backgroundColor: Colors.black, // Fond noir pour les boutons
            foregroundColor: Colors.white, // Texte en blanc
            textStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontFamily: 'BalooBhaijaan2',
            ),
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white, // Fond blanc pour la barre d'application
          foregroundColor: Colors.black, // Texte noir dans la barre d'application
          elevation: 0, // Sans ombre pour un style minimaliste
          centerTitle: false,
        ),
      ),
      home: const Phone(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Orientis'),
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
