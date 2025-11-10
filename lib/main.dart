// import 'package:flutter/material.dart';
// import 'screens/quote_form_screen.dart';
//
// void main() => runApp(const QuoteBuilderApp());
//
// class QuoteBuilderApp extends StatelessWidget {
//   const QuoteBuilderApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Quote Builder',
//       theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
//       home: const QuoteFormScreen(),
//     );
//   }
// }

// import 'package:flutter/material.dart';
// import 'screens/quote_form_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// void main() => runApp(const QuoteBuilderApp());
//
// class QuoteBuilderApp extends StatelessWidget {
//   const QuoteBuilderApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Quote Builder',
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.indigo,
//         textTheme: GoogleFonts.poppinsTextTheme(),
//         appBarTheme: const AppBarTheme(
//           centerTitle: true,
//           backgroundColor: Colors.indigo,
//           foregroundColor: Colors.white,
//         ),
//       ),
//       home: const QuoteFormScreen(),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'screens/quote_form_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// void main() => runApp(const QuoteBuilderApp());
//
// class QuoteBuilderApp extends StatelessWidget {
//   const QuoteBuilderApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Quote Builder',
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.system, // ✅ System theme (light/dark)
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.indigo,
//         brightness: Brightness.light,
//         textTheme: GoogleFonts.poppinsTextTheme(),
//       ),
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.indigo,
//         brightness: Brightness.dark,
//         textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
//       ),
//       home: const QuoteFormScreen(),
//     );
//   }
// }


//
// import 'package:flutter/material.dart';
// import 'screens/quote_form_screen.dart';
// import 'package:google_fonts/google_fonts.dart';
//
// void main() => runApp(const QuoteBuilderApp());
//
// class QuoteBuilderApp extends StatelessWidget {
//   const QuoteBuilderApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       title: 'Smart Quote Builder',
//       debugShowCheckedModeBanner: false,
//       themeMode: ThemeMode.system, // ✅ System theme (light/dark)
//       theme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.indigo,
//         brightness: Brightness.light,
//         textTheme: GoogleFonts.poppinsTextTheme(),
//       ),
//       darkTheme: ThemeData(
//         useMaterial3: true,
//         colorSchemeSeed: Colors.indigo,
//         brightness: Brightness.dark,
//         textTheme: GoogleFonts.poppinsTextTheme(ThemeData.dark().textTheme),
//       ),
//       home: const QuoteFormScreen(),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'screens/quote_form_screen.dart';

void main() => runApp(const QuoteBuilderApp());

class QuoteBuilderApp extends StatelessWidget {
  const QuoteBuilderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Quote Builder',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo, // 🎨 accent color
        brightness: Brightness.light,
        textTheme: GoogleFonts.poppinsTextTheme(),
        scaffoldBackgroundColor: Colors.grey[50],

        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.indigo,
          foregroundColor: Colors.white,
          centerTitle: true,
          elevation: 1,
        ),

        // ✅ FIXED TYPE — use CardThemeData instead of CardTheme
        cardTheme: CardThemeData(
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),

        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.grey.shade100,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),

        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigo,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          ),
        ),
      ),
      home: const QuoteFormScreen(),
    );
  }
}
