import 'package:demo/presentation/screens/home_screen.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  _navigateToHome() async{
    await Future.delayed(const Duration(seconds: 5));
    // ignore: use_build_context_synchronously
    Navigator.push(context, MaterialPageRoute(builder: (context)=> const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image(image: AssetImage('assets/images/list.png'),height: 130,width: 130,),
            SizedBox(height: 20,),
            SizedBox(
              width: 130,
              child: LinearProgressIndicator()
            ),
          ],
        ),
      ),
    );
  }
}