import 'package:flutter/material.dart';
import '../Widgets/Frontend/delayAnimation.dart';
import 'package:pinput/pinput.dart';

class OTP extends StatefulWidget {
  final String phone;
  final String verificationId;

  const OTP({required this.phone, required this.verificationId, super.key});

  @override
  State<OTP> createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  final TextEditingController _pinController = TextEditingController();

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
                    'Une vérification s\'impose !',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                DelayedAnimation(
                  delay: 500,
                  child: Text(
                    'Rentre les numéro reçu au ${widget.phone}.',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 10),
                DelayedAnimation(
                  delay: 700,
                  child: Pinput(
                    controller: _pinController,
                    length: 6,
                    defaultPinTheme: PinTheme(
                      width: double.infinity,
                    ),
                  ),
                ),
                const SizedBox(height: 5.0),
                DelayedAnimation(
                  delay: 1000,
                  child: ElevatedButton(
                    onPressed: () {},
                    child: const Text('Vérifier !'),
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
