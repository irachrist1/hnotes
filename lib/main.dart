import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/strings.dart';
import 'shared/providers/user_provider.dart';
import 'shared/providers/daily_log_provider.dart';
import 'shared/providers/notification_provider.dart';
import 'features/onboarding/screens/welcome_screen.dart';
import 'features/dashboard/screens/dashboard_screen.dart';

void main() {
  runApp(const HNotesApp());
}

class HNotesApp extends StatelessWidget {
  const HNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => DailyLogProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        home: const SplashScreen(),
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Load user data after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Provider.of<UserProvider>(context, listen: false).loadUserProfile();
      await Provider.of<DailyLogProvider>(context, listen: false).loadLogs();
      await Provider.of<NotificationProvider>(context, listen: false).loadNotifications();

      // Wait a moment for splash effect
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

      // Navigate based on onboarding status
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      if (userProvider.hasCompletedOnboarding) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (_) => DashboardScreen(
              userProfile: userProvider.userProfile!,
            ),
          ),
        );
      } else {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const WelcomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF1F3DBD),
              Color(0xFF1792DB),
            ],
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.favorite_rounded,
                size: 80,
                color: Colors.white,
              ),
              SizedBox(height: 24),
              Text(
                AppStrings.appName,
                style: TextStyle(
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 24),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
