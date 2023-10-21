import 'package:bataao/screens/splash_screen/splash_screen.dart';
import 'package:bataao/screens/welcome_screen/welcome_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_notification_channel/flutter_notification_channel.dart';
import 'package:flutter_notification_channel/notification_importance.dart';
import 'package:google_fonts/google_fonts.dart';

// FireBase Init
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Enter Full Screen
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));

  SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown])
      .then((value) async {
    await Firebase.initializeApp();
    var result = await FlutterNotificationChannel.registerNotificationChannel(
      description: 'For Showing messageing notifications .',
      id: 'chats',
      importance: NotificationImportance.IMPORTANCE_HIGH,
      name: 'Chats',
    );
    debugPrint("\nNotifications Chanel : $result");
    runApp(const MyApp());
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Bataao ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          fontFamily: GoogleFonts.lato().fontFamily,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            titleTextStyle: TextStyle(
                color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          )),
      initialRoute: '/splash_screen',
      routes: { 
        '/welcome_screen': (context) => const WelcomeScreen(),
        '/splash_screen': (context) => const SplashScreen()
      },
    );
  }
} 
