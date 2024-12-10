import 'package:flutter/material.dart';
import 'package:orientis/Widgets/Frontend/delayAnimation.dart';
import 'package:orientis/Widgets/Frontend/textField.dart';

class Phone extends StatefulWidget {
  const Phone({super.key});

  @override
  State<Phone> createState() => _PhoneState();
}

class _PhoneState extends State<Phone> {
  final TextEditingController _phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    'Pour commencer, rentre ton numéro de téléphone...',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                DelayedAnimation(
                  delay: 700,
                  child: CustomTextField(
                    hintText: '1 23 45 67 89',
                    keyboardType: TextInputType.number,
                    controller: _phoneController,
                  ),
                ),
                const SizedBox(height: 5.0),
                DelayedAnimation(
                  delay: 1000,
                  child: ElevatedButton(
                    onPressed: () {},
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
