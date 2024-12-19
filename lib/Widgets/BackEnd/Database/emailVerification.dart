// ignore_for_file: prefer_const_declarations, file_names, use_build_context_synchronously

import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:orienty/Widgets/Frontend/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EmailVerification {
  final BuildContext context;

  EmailVerification({required this.context});

  // Fonction pour vérifier si l'email est vérifié
  Future<void> checkEmailVerified() async {
    // Récupérer l'utilisateur actuel de Firebase
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Vérifier dans le cache si l'email a déjà été vérifié
      SharedPreferences prefs = await SharedPreferences.getInstance();
      bool? isEmailVerified = prefs.getBool('isEmailVerified');

      if (isEmailVerified != null && isEmailVerified) {
        // Si l'email est déjà marqué comme vérifié, on ne fait rien
        return;
      } else {
        // Si l'email n'est pas vérifié, vérifier si l'utilisateur a confirmé son email
        if (user.emailVerified) {
          // Marquer l'email comme vérifié dans le cache
          await prefs.setBool('isEmailVerified', true);
        } else {
          // Afficher un popup pour demander à l'utilisateur de vérifier son email
          _showEmailVerificationPopup();
        }
      }
    }
  }

  // Afficher un popup demandant de vérifier l'email
  SizedBox _showEmailVerificationPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final materialBanner = MaterialBanner(
        elevation: 0,
        backgroundColor: Colors.transparent,
        forceActionsBelow: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InkWell(
              borderRadius: BorderRadius.circular(15.0),
              onTap: () async {
                // Envoi d'un nouvel email de vérification
                try {
                  User? user = FirebaseAuth.instance.currentUser;
                  if (user != null) {
                    await user.sendEmailVerification();
                    // Fermer le popup
                    Navigator.of(context).pop();
                    // Afficher un message pour informer l'utilisateur
                    _showVerificationSentPopup();
                  }
                } catch (e) {
                  print("Erreur lors de l'envoi de l'email de vérification: $e");
                }
              },
              child: const AwesomeSnackbarContent(
                title: 'Vérifie ton email !',
                message: 'Faire vérifier son mail est important, car cela prouve que tu es un véritable utilisateur !',
              
                /// Change `contentType` to ContentType.success, ContentType.warning, or ContentType.help for variants
                contentType: ContentType.warning,
                color: warningColor,
                inMaterialBanner: true,
              ),
            ),
          ],
        ),
        actions: const [SizedBox.shrink()],
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(materialBanner);
    });

    return const SizedBox.shrink();
  }

  // Afficher un popup confirmant l'envoi de l'email de vérification
  SizedBox _showVerificationSentPopup() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final materialBanner = const MaterialBanner(
        elevation: 0,
        backgroundColor: Colors.transparent,
        forceActionsBelow: true,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AwesomeSnackbarContent(
              title: 'Vérifie ton email !',
              message: 'Faire vérifier son mail est important, car cela prouve que tu es un véritable utilisateur !',

              /// Change `contentType` to ContentType.success, ContentType.warning, or ContentType.help for variants
              contentType: ContentType.success,
              color: Color.fromARGB(255, 114, 229, 124),
              inMaterialBanner: true,
            ),
          ],
        ),
        actions: [SizedBox.shrink()],
      );

      ScaffoldMessenger.of(context)
        ..hideCurrentMaterialBanner()
        ..showMaterialBanner(materialBanner);
    });

    return const SizedBox.shrink();
  }
}