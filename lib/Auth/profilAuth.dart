// ignore_for_file: use_build_context_synchronously, file_names, non_constant_identifier_names, prefer_const_literals_to_create_immutables, library_private_types_in_public_api, prefer_final_fields

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:orienty/Main/mainPage.dart';
import 'package:orienty/Widgets/Frontend/colors.dart';
import 'package:orienty/Widgets/Frontend/delayAnimation.dart';
import 'package:orienty/Widgets/Frontend/textField.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:page_transition/page_transition.dart';

class MainAuthProfile extends StatelessWidget {
  final String userId;
  
  const MainAuthProfile({required this.userId, super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();

    Future<void> saveAccount() async {
      try {
        Client client = Client()
            .setEndpoint('https://cloud.appwrite.io/v1')
            .setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '');
        Account account = Account(client);

        await account.updatePrefs(
          prefs: {'name': nameController.text.trim()},
        );

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyHomePage()),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Erreur lors de la configuration.")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Configurer le compte")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Nom",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: saveAccount,
              child: const Text("Enregistrer"),
            ),
          ],
        ),
      ),
    );
  }
}


class UserProfile {
  String nom = '';
  String prenom = '';
  String pseudo = '';
  String type = '';
  String nom_etablissement = '';
  bool publique = true;
}

class RegistrationPage extends StatefulWidget {
  final String userId;
  const RegistrationPage({required this.userId, super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final UserProfile _userProfile = UserProfile();
  final TextEditingController _controllerNom = TextEditingController();
  final TextEditingController _controllerPrenom = TextEditingController();
  final TextEditingController _controllerPseudo = TextEditingController();
  int _currentStep = 0;

  late Client _client;
  late Databases _databases;

  final String _databaseId = '6759cd6e001c2ac7636f';
  final String _collectionId = '6759cd7a0007299ae37f';

  final List<String> _titles = [
    "Tes informations personnelles",
    "Ton pseudo",
    "Dans quelle filière es-tu ?",
    "Quelle est ton établissement scolaire ?",
    "Veux-tu que ton profil soit public ?",
    "C'est prêt !"
  ];

  final List<String> _descriptions = [
    "Ça restera entre toi et Orienty, promis !",
    "Il sera affiché publiquement...",
    "Si tu es étudiant, tu devras faire vérifier tes informations.",
    "On ne communiquera rien avec cet établissement.",
    "Si ton profil est privé, personne n'aura accès à ton établissement scolaire et ton pseudo sera remplacé par tes initiales uniquement.",
    "Votre profil est configuré avec succès !"
  ];

  final List<Widget> _fields = [];
  String? _errorMessage;

  @override
  void initState() {
    super.initState();

    // Initialiser AppWrite client
    _client = Client()
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject(dotenv.env['APPWRITE_PROJECT_ID'] ?? '');
    _databases = Databases(_client);

    // Ajouter les étapes du formulaire
    _fields.addAll([
      // Étape 1: Nom et prénom
      Row(
        children: [
          Expanded(
            child: DelayedAnimation(
              delay: 200,
              child: CustomTextField(
                controller: _controllerNom,
                hintText: 'Nom',
              ),
            ),
          ),
          const SizedBox(width: 15.0),
          Expanded(
            child: DelayedAnimation(
              delay: 400,
              child: CustomTextField(
                controller: _controllerPrenom,
                hintText: 'Prénom',
              ),
            ),
          ),
        ],
      ),
      // Étape 2: Pseudo
      DelayedAnimation(
        delay: 200,
        child: CustomTextField(
          controller: _controllerPseudo,
          hintText: 'Pseudo',
        ),
      ),
      // Étape 3: Filière
      Column(
        children: [
          DelayedAnimation(
            delay: 200,
            child: ChoiceSelector(
              list: const ["Étudiant", "Lycéen", "Terminal"],
              onChanged: (selectedChoice) {
                setState(() {
                  _userProfile.type = selectedChoice;
                });
              },
            ),
          ),
          const SizedBox(height: 40.0),
          DelayedAnimation(
            delay: 400,
            child: TextButton.icon(
              onPressed: () {},
              label: const Text('En savoir plus'),
              icon: const Icon(Icons.info_outline, size: 16),
            ),
          ),
        ],
      ),
      // Étape 4: Établissement
      DelayedAnimation(
        delay: 200,
        child: SchoolSearchPage(
          onSchoolSelected: (String selectedSchool) {
            setState(() {
              _userProfile.nom_etablissement = selectedSchool;
            });
          },
        ),
      ),
      // Étape 5: Profil public ou non
      DelayedAnimation(
        delay: 200,
        child: ChoiceSelector(
          list: ['Oui', 'Non'],
          initialChoice: 'Oui',
          onChanged: (selectedChoice) {
            setState(() {
              _userProfile.publique = selectedChoice == 'Oui';
            });
          },
        ),
      ),
      // Étape 6: Confirmation
      SvgPicture.asset('assets/Images/Illustration/Flat/Confirmed.svg', height: 270.0,),
    ]);
  }

  Future<void> _createUserProfile() async {
    try {
      // Remplir les données du profil utilisateur
      _userProfile.nom = _controllerNom.text.trim();
      _userProfile.prenom = _controllerPrenom.text.trim();
      _userProfile.pseudo = _controllerPseudo.text.trim();

      // Vérifier que les champs obligatoires sont remplis
      if (_userProfile.nom.isEmpty ||
          _userProfile.prenom.isEmpty ||
          _userProfile.pseudo.isEmpty) {
        throw Exception("Tous les champs doivent être remplis.");
      }

      Account account = Account(_client);
      try {
        User user = await account.get();
        print('Utilisateur connecté : ${user.email}');
      } catch (e) {
        print('Aucun utilisateur connecté.');
        // Rediriger l'utilisateur vers une page de connexion
      }


      // Créer le document
      await _databases.createDocument(
        databaseId: _databaseId,
        collectionId: _collectionId,
        documentId: widget.userId,
        data: {
          'Nom': _userProfile.nom,
          'Prenom': _userProfile.prenom,
          'Pseudo': _userProfile.pseudo,
          'Type': _userProfile.type,
          'NomEtablissement': _userProfile.nom_etablissement,
          'AccountPublique': _userProfile.publique,
        },
        permissions: [
          Permission.read(Role.user(widget.userId)),
          Permission.write(Role.user(widget.userId)),
        ],
      );
      
      Navigator.push(context, PageTransition(type: PageTransitionType.bottomToTop, child: const MyHomePage(), duration: const Duration(milliseconds: 500)));
    } catch (e) {
      // Gérer les erreurs
      print("Erreur lors de la création du profil : $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur : ${e.toString()}')),
      );
    }
  }

  void _nextStep() async {
    setState(() {
      _errorMessage = null;
    });

    if (_currentStep == 0) {
      if (_controllerNom.text.isEmpty || _controllerPrenom.text.isEmpty) {
        setState(() {
          _errorMessage = "Veuillez remplir votre nom et prénom.";
        });
        return;
      }
      _userProfile.nom = _controllerNom.text;
      _userProfile.prenom = _controllerPrenom.text;
    } else if (_currentStep == 1) {
      if (_controllerPseudo.text.isEmpty) {
        setState(() {
          _errorMessage = "Veuillez entrer un pseudo.";
        });
        return;
      }
      _userProfile.pseudo = _controllerPseudo.text;
    } else if (_currentStep == 2 && _userProfile.type.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez sélectionner une filière.";
        return;
      });
    } else if (_currentStep == 3 && _userProfile.nom_etablissement.isEmpty) {
      setState(() {
        _errorMessage = "Veuillez sélectionner un établissement.";
        return;
      });
    }

    if (_currentStep < _fields.length - 1) {
      setState(() {
        _currentStep++;
      });
    } else {
      // Dernière étape : envoi des données
      await _createUserProfile();
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            _fields.length,
            (index) => Expanded(
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                height: 4.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: index < _currentStep
                      ? primaryColor
                      : index == _currentStep
                          ? primaryColor
                          : greyColor,
                ),
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _titles[_currentStep],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 10),
                Text(
                  _descriptions[_currentStep],
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 20),
                if (_errorMessage != null)
                  Text(
                    _errorMessage!,
                    style: const TextStyle(color: errorColor),
                  ),
                _fields[_currentStep],
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            if (_currentStep > 0)
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _previousStep,
              ),
            const Spacer(),
            Expanded(
              child: ElevatedButton(
                onPressed: _nextStep,
                child: Text(_currentStep < _fields.length - 1 ? "Suivant" : "Terminer"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



class ChoiceSelector extends StatefulWidget {
  final List<String> list;
  final Function(String) onChanged;
  final String? initialChoice; // Nouvelle option pour la présélection

  const ChoiceSelector({
    required this.onChanged,
    required this.list,
    this.initialChoice,
    super.key,
  });

  @override
  _ChoiceSelectorState createState() => _ChoiceSelectorState();
}

class _ChoiceSelectorState extends State<ChoiceSelector> {
  String? _selectedchoice;
  String? _pressedChoice; // Track the pressed item

  @override
  void initState() {
    super.initState();
    // Initialiser la sélection avec initialChoice si elle est définie
    _selectedchoice = widget.initialChoice;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: widget.list.map((choice) {
        final isSelected = _selectedchoice == choice;
        final isPressed = _pressedChoice == choice;

        return GestureDetector(
          onTapDown: (_) {
            setState(() {
              _pressedChoice = choice; // Set as pressed
            });
          },
          onTapUp: (_) {
            setState(() {
              _selectedchoice = choice;
              _pressedChoice = null; // Reset press state
              widget.onChanged(choice);
            });
          },
          onTapCancel: () {
            setState(() {
              _pressedChoice = null; // Reset if cancelled
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
            decoration: BoxDecoration(
              color: isSelected
                  ? Theme.of(context).primaryColor
                  : isPressed
                      ? Colors.black
                      : Colors.grey[200],
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(
                color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
                width: 2.0,
              ),
            ),
            child: Text(
              choice,
              style: TextStyle(
                color: isSelected || isPressed ? Colors.white : Colors.black,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}





class SchoolSearchPage extends StatefulWidget {
  final Function(String) onSchoolSelected;

  const SchoolSearchPage({super.key, required this.onSchoolSelected});

  @override
  _SchoolSearchPageState createState() => _SchoolSearchPageState();
}

class _SchoolSearchPageState extends State<SchoolSearchPage> {
  TextEditingController _searchController = TextEditingController();
  List<dynamic> _searchResults = [];
  bool _isLoading = false;
  dynamic _selectedSchool;
  bool _isSelectionMode = true;

  // Fonction pour appeler la première API
  Future<List<dynamic>> _fetchFromFirstAPI(String query) async {
    const String baseUrl =
        'https://data.education.gouv.fr/api/explore/v2.1/catalog/datasets/fr-en-annuaire-education/records';
    const String refinedType = 'Lycée';
    const String limit = '20';

    final Uri apiUrl = Uri.parse(
        '$baseUrl?limit=$limit&refine=type_etablissement:$refinedType&where=nom_etablissement%20LIKE%20%27%25$query%25%27');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'].map((record) => record).toList();
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (error) {
      print("Error fetching data from first API: $error");
      return [];
    }
  }

  // Fonction pour appeler la deuxième API
  Future<List<dynamic>> _fetchFromSecondAPI(String query) async {
    const String baseUrl =
        'https://api.opendata.onisep.fr/api/1.0/dataset/5fa586da5c4b6/search';
    const String limit = '10';

    final Uri apiUrl = Uri.parse('$baseUrl?q=$query&size=$limit');

    try {
      final response = await http.get(apiUrl);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['results'].map((record) => record).toList();
      } else {
        print("Error: ${response.statusCode}");
        return [];
      }
    } catch (error) {
      print("Error fetching data from second API: $error");
      return [];
    }
  }

  // Fonction pour rechercher des établissements dans les deux API
  Future<void> _searchSchool(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    List<dynamic> resultsFromFirstAPI = await _fetchFromFirstAPI(query);
    List<dynamic> resultsFromSecondAPI = await _fetchFromSecondAPI(query);

    Set<String> uniqueNames = {};
    List<dynamic> uniqueResults = [];

    for (var result in [...resultsFromFirstAPI, ...resultsFromSecondAPI]) {
      String name = result['nom_etablissement'] ?? result['nom'] ?? '';
      if (!uniqueNames.contains(name)) {
        uniqueNames.add(name);
        uniqueResults.add(result);
      }
    }

    setState(() {
      _searchResults = uniqueResults;
      _isLoading = false;
    });
  }

  void _selectSchool(dynamic school) {
    setState(() {
      _selectedSchool = school;
      _isSelectionMode = false;
    });

    // Retourne le nom de l'établissement sélectionné au parent
    String schoolName = school['nom_etablissement'] ?? school['nom'] ?? '';
    widget.onSchoolSelected(schoolName);
  }

  void _editSelection() {
    setState(() {
      _selectedSchool = null;
      _isSelectionMode = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          transitionBuilder: (Widget child, Animation<double> animation) {
            return ScaleTransition(
              scale: animation,
              child: child,
            );
          },
          child: _isSelectionMode
              ? Column(
                  key: ValueKey<bool>(_isSelectionMode),
                  children: [
                    CustomTextField(
                      icon: LucideIcons.search,
                      hintText: 'Nom de l’établissement...',
                      controller: _searchController,
                      onSubmitted: (query) {
                        _searchSchool(query);
                      },
                    ),
                    const SizedBox(height: 20),
                    _isLoading
                        ? const CircularProgressIndicator()
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _searchResults.length,
                            itemBuilder: (context, index) {
                              final school = _searchResults[index];
                              return ListTile(
                                title: Text(
                                    school['nom_etablissement'] ?? school['nom'] ?? ''),
                                subtitle: Text(school['nom_commune'] ?? school['commune'] ?? ''),
                                onTap: () {
                                  _selectSchool(school);
                                },
                              );
                            },
                          ),
                  ],
                )
              : Column(
                  key: ValueKey<bool>(_isSelectionMode),
                  children: [
                    ListTile(
                      title: Text(
                          _selectedSchool['nom_etablissement'] ?? _selectedSchool['nom'] ?? ''),
                      subtitle: Text(
                          _selectedSchool['nom_commune'] ?? _selectedSchool['commune'] ?? ''),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _editSelection,
                      ),
                    ),
                  ],
                ),
        ),
      ],
    );
  }
}
