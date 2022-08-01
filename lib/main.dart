import 'package:corporate_ride_sharing/screens/home/home_screen.dart';
import 'package:corporate_ride_sharing/screens/login/mobile_screen.dart';
import 'package:corporate_ride_sharing/screens/login/otp_screen.dart';
import 'package:corporate_ride_sharing/screens/roleSelection/role_selection.dart';
import 'package:corporate_ride_sharing/screens/splash/splash_screen.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs().init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  get phoneNumber => SharedPrefs().phoneNumber;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Corporate Ride Sharing',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black,
        brightness: Brightness.dark,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      routes: {
        '/': (context) => const SplashScreen(),
        '/mobile': (context) => const MobileScreen(),
        '/otp': (context) => OtpScreen(phoneNumber: phoneNumber),
        '/home': (context) => const HomeScreen(),
        '/role_selection': (context) => const RoleSelection(),
      },
      initialRoute: '/',
    );
  }
}
