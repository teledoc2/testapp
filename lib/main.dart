import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:your_app/providers/app_provider.dart';
import 'package:your_app/screens/home_screen.dart';
import 'package:your_app/screens/second_screen.dart';
import 'package:your_app/l10n/l10n.dart';

final ThemeData appTheme = ThemeData(
  primaryColor: Color(0xFF38488F),
  scaffoldBackgroundColor: Color(0xFFF0F0F2),
  backgroundColor: Color(0xFFFDFDFF),
  fontFamily: 'Segoe UI',
  textTheme: TextTheme(
    headlineLarge: TextStyle(
      fontSize: 32.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineMedium: TextStyle(
      fontSize: 24.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineSmall: TextStyle(
      fontSize: 20.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    bodyMedium: TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
  ),
);

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter App',
      theme: appTheme,
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => HomeScreen(),
        '/second': (context) => SecondScreen(),
      },
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      builder: (context, child) {
        return ErrorBoundary(child: child!);
      },
    );
  }
}

class ErrorBoundary extends StatelessWidget {
  final Widget child;

  const ErrorBoundary({required this.child});

  @override
  Widget build(BuildContext context) {
    return FlutterErrorWidget(
      child: child,
      onError: (FlutterErrorDetails details) {
        // Log errors here
        debugPrint('Error caught: ${details.exception}');
      },
    );
  }
}

class FlutterErrorWidget extends StatelessWidget {
  final Widget child;
  final Function(FlutterErrorDetails) onError;

  const FlutterErrorWidget({required this.child, required this.onError});

  @override
  Widget build(BuildContext context) {
    return FlutterError.onError == null
        ? child
        : ErrorWidget.builder = (FlutterErrorDetails details) {
            onError(details);
            return Scaffold(
              body: Center(
                child: Text('Something went wrong!'),
              ),
            );
          };
  }
}
