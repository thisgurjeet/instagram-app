import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:instagram_app/controllers/providers/user_provider.dart';
import 'package:instagram_app/views/responsive/mobile_screen_layout.dart';
import 'package:instagram_app/views/responsive/responsive_layout.dart';
import 'package:instagram_app/views/screens/login_screen.dart';
import 'package:provider/provider.dart';

import 'views/responsive/web_screen_layout.dart';
import 'views/screens/signup_screen.dart';
import 'models/utils/colors.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: 'AIzaSyByP38FGVhVpmFTE3aRULL_aZTjt_ZgL3A',
            appId: '1:573016274084:web:7b488bdf87b6751050a231',
            messagingSenderId: '573016274084',
            projectId: 'instagram-app-341cb',
            storageBucket: 'instagram-app-341cb.appspot.com'));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => UserProvider())],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Instagram Clone',
          // dark give us all the features that are present in the themedata dark
          theme: ThemeData.dark()
              .copyWith(scaffoldBackgroundColor: mobileBackgroundColor),
          home: StreamBuilder(
            stream: FirebaseAuth.instance.authStateChanges(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) {
                if (snapshot.hasData) {
                  return const Responsivelayout(
                      webScreenLayout: WebScreenLayout(),
                      mobileScreenLayout: MobileScreenLayout());
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('${snapshot.error}'),
                  );
                }
              }
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              return const LoginScreen();
            },
          )),
    );
  }
}
