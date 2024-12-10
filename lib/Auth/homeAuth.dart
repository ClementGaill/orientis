import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:orientis/Widgets/Frontend/delayAnimation.dart';

class HomeAuth extends StatefulWidget {
  const HomeAuth({super.key});

  @override
  State<HomeAuth> createState() => _HomeAuthState();
}

class _HomeAuthState extends State<HomeAuth> {
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
                DelayedAnimation(delay: 500, child: SvgPicture.asset('assets/Images/Illustration/Flat/SearchFile.svg', height: 270.0,)),
                const SizedBox(height: 15.0,),
                DelayedAnimation(delay: 1000, child: Text('Bienvenue !', style: Theme.of(context).textTheme.titleLarge,)),
                DelayedAnimation(delay: 1500, child: Text('Prêts a trouver la filière de tes rêves ?', style: Theme.of(context).textTheme.titleSmall,)),
                const SizedBox(height: 10.0,),
                DelayedAnimation(delay: 2000, child: ElevatedButton(onPressed: () {}, child: const Text('Commencer !'))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}