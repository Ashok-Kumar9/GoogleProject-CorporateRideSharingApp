import 'package:corporate_ride_sharing/screens/Account/account.dart';
import 'package:corporate_ride_sharing/screens/giveRide/give_ride.dart';
import 'package:corporate_ride_sharing/screens/home/home_screen.dart';
import 'package:corporate_ride_sharing/screens/login/mobile_screen.dart';
import 'package:corporate_ride_sharing/screens/login/otp_screen.dart';
import 'package:corporate_ride_sharing/screens/profile/user_profile.dart';
import 'package:corporate_ride_sharing/screens/requestRide/request_ride.dart';
import 'package:corporate_ride_sharing/screens/rideHistory/ride_history.dart';
import 'package:corporate_ride_sharing/screens/roleSelection/role_selection.dart';
import 'package:corporate_ride_sharing/screens/space/space_screen.dart';
import 'package:corporate_ride_sharing/screens/splash/splash_screen.dart';
import 'package:corporate_ride_sharing/screens/vehicle/vehicle.dart';
import 'package:corporate_ride_sharing/utils/sharedPrefs/shared_prefs.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await SharedPrefs().init();
  String token =  await FirebaseAuth.instance.currentUser?.getIdToken() ?? '';
  SharedPrefs().authToken = token;
  // FirebaseAuth.instance.idTokenChanges().listen((token) {
  //   if (token != null) {
  //     SharedPrefs().authToken = token as String;
  //   }
  // });
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
        '/space': (context) => const SpaceScreen(),
        '/home': (context) => const HomeScreen(),
        '/role_selection': (context) => const RoleSelection(),
        '/user_profile': (context) => const UserProfile(),
        '/request_ride': (context) => const RequestRide(),
        '/give_ride': (context) => const GiveRide(),
        '/ride_history': (context) => const RideHistory(),
        '/account': (context) => const Account(),
        '/vehicle': (context) => const Vehicle(),
      },
      initialRoute: '/',
    );
  }
}
