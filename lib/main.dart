import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import './Screens/splash_screen.dart';
import './Provider/user_provider.dart';
import './Screens/home_screen.dart';
import './Screens/forget_password.dart';
import 'Screens/login_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown
  ]);
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(

      designSize: Size(360, 690),
      //minTextAdapt: true,
      //splitScreenMode: true,
      builder: (ctx, child) => ChangeNotifierProvider(
        create: (ctx) => UserProvider(),
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'NIMS School Diary',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.purple,
            fontFamily: 'Axiforma',
          ),
          home: SplashScreen(),
          routes: {
            LoginScreen.routeName: (ctx) => LoginScreen(),
            HomeScreen.routeName: (ctx) => HomeScreen(),
            ForgetPassword.routeName: (ctx) =>ForgetPassword()
          },
        ),
      ),
    );
  }
}
