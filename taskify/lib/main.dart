import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:taskify/providers/task_provider.dart';
import 'package:taskify/screens/home_screen.dart';
import 'package:taskify/services/notification_service.dart';
import 'package:google_fonts/google_fonts.dart';

final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.system);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // Define modern color palette
  static const MaterialColor modernBlue = MaterialColor(
    0xFF2563EB, // Primary value
    <int, Color>{
      50: Color(0xFFEFF6FF),
      100: Color(0xFFDBEAFE),
      200: Color(0xFFBFDBFE),
      300: Color(0xFF93C5FD),
      400: Color(0xFF60A5FA),
      500: Color(0xFF3B82F6),
      600: Color(0xFF2563EB),
      700: Color(0xFF1D4ED8),
      800: Color(0xFF1E40AF),
      900: Color(0xFF1E3A8A),
    },
  );

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => TaskProvider(),
      child: ValueListenableBuilder<ThemeMode>(
        valueListenable: themeNotifier,
        builder: (_, mode, __) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Taskify',
            theme: ThemeData(
              primarySwatch: modernBlue,
              fontFamily: GoogleFonts.inter().fontFamily,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: const Color(0xFFFAFAFA),
              colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: modernBlue).copyWith(
                secondary: const Color(0xFF10B981),
                surface: Colors.white,
                surfaceVariant: const Color(0xFFF8FAFC),
              ),
              cardTheme: CardThemeData(
                elevation: 2,
                shadowColor: Colors.black.withOpacity(0.1),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: Colors.white,
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF1F2937),
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                titleTextStyle: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF1F2937),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: modernBlue,
                foregroundColor: Colors.white,
                elevation: 4,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
            ),
            darkTheme: ThemeData(
              primarySwatch: modernBlue,
              fontFamily: GoogleFonts.inter().fontFamily,
              visualDensity: VisualDensity.adaptivePlatformDensity,
              scaffoldBackgroundColor: const Color(0xFF0F172A),
              colorScheme: ColorScheme.fromSwatch(
                primarySwatch: modernBlue,
                brightness: Brightness.dark,
              ).copyWith(
                secondary: const Color(0xFF10B981),
                surface: const Color(0xFF1E293B),
                surfaceVariant: const Color(0xFF334155),
                onSurface: const Color(0xFFE2E8F0),
              ),
              cardTheme: CardThemeData(
                elevation: 4,
                shadowColor: Colors.black.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                color: const Color(0xFF1E293B),
              ),
              appBarTheme: AppBarTheme(
                backgroundColor: const Color(0xFF0F172A),
                foregroundColor: const Color(0xFFE2E8F0),
                elevation: 0,
                surfaceTintColor: Colors.transparent,
                titleTextStyle: GoogleFonts.inter(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFFE2E8F0),
                ),
              ),
              floatingActionButtonTheme: FloatingActionButtonThemeData(
                backgroundColor: modernBlue,
                foregroundColor: Colors.white,
                elevation: 6,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
              ),
              checkboxTheme: CheckboxThemeData(
                fillColor: WidgetStateProperty.resolveWith((states) {
                  if (states.contains(WidgetState.selected)) {
                    return modernBlue;
                  }
                  return const Color(0xFF475569);
                }),
                checkColor: WidgetStateProperty.all(Colors.white),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              dialogTheme: DialogThemeData(
                backgroundColor: const Color(0xFF1E293B),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16)),
                titleTextStyle: GoogleFonts.inter(
                  color: const Color(0xFFE2E8F0),
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
              ),
              inputDecorationTheme: InputDecorationTheme(
                filled: true,
                fillColor: const Color(0xFF334155),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: modernBlue, width: 2),
                ),
              ),
            ),
            themeMode: mode,
            home: const HomeScreen(),
          );
        },
      ),
    );
  }
}
