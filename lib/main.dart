import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:service_pro_provider/Admin%20Panel/admin_dashboard.dart';
import 'package:service_pro_provider/Provider/category_provider/category_provider.dart';
import 'package:service_pro_provider/Provider/category_provider/put_category_provider.dart';
import 'package:service_pro_provider/Provider/chat_user_provider.dart';
import 'package:service_pro_provider/Provider/profile_provider.dart';
import 'package:service_pro_provider/Provider/login_logout_provider.dart';
import 'package:service_pro_provider/Ui/navigator/navigator_scaffold.dart';
import 'package:service_pro_provider/Ui/login_signup/login_screen.dart';
import 'package:service_pro_provider/Ui/splash_screen/splash_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferences.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginLogoutProvider()),
        ChangeNotifierProvider(create: (_) => ChatUserProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => CategoryProvider()),
        ChangeNotifierProvider(create: (_) => UpdateCategory()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: Color(0xFF42cbac),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => SplashScreen(),
          '/dashboard': (context) => const NavigatorScaffold(),
          '/login': (context) => const LoginScreen(),
          '/admin': (context) => const AdminDashboard(),
        },
      ),
    );
  }
}
